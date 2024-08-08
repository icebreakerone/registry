# frozen_string_literal: true

class RdfClass
  attr_reader :uri
  def initialize(uri)
    @uri = uri
  end

  def _to_rdf_value(jmodel)
    jmodel.createResource(self.uri.to_uri_s)
  end
  
  def _modify_used_prefix(used_prefix)
    used_prefix[self.uri.prefix] = true
  end
end

# ---------------------------------------------------------------------------

class RdfUri
  attr_reader :prefix, :suffix
  def initialize(prefix, suffix)
    @prefix = prefix
    @suffix = suffix
  end
  def to_uri_s
    @prefix + (@suffix || '')
  end
  def _to_rdf_value(jmodel)
    jmodel.createResource(self.to_uri_s)
  end
  def _modify_used_prefix(used_prefix)
    used_prefix[@prefix] = true
  end
end

# ---------------------------------------------------------------------------

class Ns
  @@all_prefix = []
  def self.namespace(symbol, prefix)
    @@all_prefix << [symbol, prefix]
    Ns.class.define_method(symbol) do |suffix|
      RdfUri.new(prefix, suffix)
    end
    Ns.class.define_method("#{symbol}_prefix".to_sym) do
      prefix
    end
  end
  def self.each_prefix(&block)
    @@all_prefix.each(&block)
  end
end

# ---------------------------------------------------------------------------

class Context
  @@stack = []
  def self.within
    context = Context.new
    @@stack.push(context)
    yield context
    @@stack.pop
  end
  def every_resource(&block)
    raise "Already set every_resource block" if @every_resource
    @every_resource = block
  end
  def self._resource_added(resource)
    @@stack.reverse_each do |context|
      context._resource_added(resource)
    end
  end
  def _resource_added(resource)
    @every_resource.call(resource) if @every_resource
  end
end

# ---------------------------------------------------------------------------

class Resource
  attr_reader :uri

  @@all_resources = []
  def self.clear_all
    @@all_resources.clear
  end

  def self.rdf_class(klass)
    self.const_set(:RDF_CLASS, klass)
  end

  def initialize(uri)
    @uri = uri
    @properties = [[RDF::Type.uri, self.class.const_get(:RDF_CLASS)]]
    Context._resource_added(self)
    yield self if block_given?
    @@all_resources << self
  end

  def self.property(symbol, uri, value_class)
    define_method(symbol) do |value|
      raise "Value should be #{value_class.name}" unless value.kind_of?(value_class)
      @properties << [uri, value]
      self
    end
  end

  def self.all_resources
    @@all_resources.dup
  end

  def _to_rdf_value(jmodel)
    jmodel.createResource(self.uri.to_uri_s)
  end

  def _add_terms_to(jresource, model)
    @properties.each do |uri, value|
      model._add_property(jresource, uri, value)
    end
  end
end

# ---------------------------------------------------------------------------

class RdfModel
  OUTPUT_FORMATS = [
    [Jena::Lang.TURTLE, '.ttl', 'RDF (Turtle)'],
    [Jena::Lang.RDFXML, '.rdf', 'RDF/XML'],
    [Jena::Lang.JSONLD, '.jsonld', 'RDF (JSON-LD)']
  ]
  def initialize
    @jmodel = Jena::ModelFactory.createDefaultModel()
    @used_prefix = {}
  end
  def add(resource)
    jresource = @jmodel.createResource(resource.uri.to_uri_s)
    resource._add_terms_to(jresource, self)
    self
  end
  def _add_property(jresource, uri, value)
    jproperty = @jmodel.createProperty(uri.prefix, uri.suffix)
    jresource.addProperty(jproperty, value.respond_to?(:_to_rdf_value) ? value._to_rdf_value(@jmodel) : value)
    @used_prefix[uri.prefix] = true
    value._modify_used_prefix(@used_prefix) if value.respond_to?(:_modify_used_prefix)
  end
  def _finish
    return if @finished
    # Only include used prefixes for neatness
    Ns.each_prefix do |symbol, prefix|
      if @used_prefix[prefix]
        @jmodel.setNsPrefix(symbol, prefix)
      end
    end
    @finished = true
  end
  def dump
    _finish()
    Jena::RDFDataMgr.write(java.lang.System.out, @jmodel, Jena::Lang.TURTLE)
  end
  def write_all_formats(basename, title)
    _finish()
    OUTPUT_FORMATS.each do |lang, extension|
      outputstream = java.io.FileOutputStream.new("#{basename}#{extension}")
      begin
        Jena::RDFDataMgr.write(outputstream, @jmodel, lang)
      ensure
        outputstream.close
      end
    end
    File.open("#{basename}.html", "w") do |f|
      f.write Templates::TEMPLATES['rdf.html.erb'].result(binding)
    end
  end
end
