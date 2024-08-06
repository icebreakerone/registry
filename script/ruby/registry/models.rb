# frozen_string_literal: true

class RdfClass
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
Ns.namespace(:rdf, "http://www.w3.org/1999/02/22-rdf-syntax-ns#")

# ---------------------------------------------------------------------------

class ResourceClass < RdfClass
  attr_reader :uri

  @@all_resources = []
  RDF_TYPE = Ns.rdf("type")

  def self.rdf_class(klass)
    self.const_set(:RDF_CLASS, klass)
  end

  def initialize(uri)
    @uri = uri
    @properties = [[RDF_TYPE, self.class.const_get(:RDF_CLASS)]]
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

  def _add_terms_to(jresource, model)
    @properties.each do |uri, value|
      model._add_property(jresource, uri, value)
    end
  end
end

# ---------------------------------------------------------------------------

class RdfModel
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
    @used_prefix[value.prefix] = true if value.kind_of?(RdfUri)
  end
  def _finish
    # Only include used prefixes for neatness
    Ns.each_prefix do |symbol, prefix|
      if @used_prefix[prefix]
        @jmodel.setNsPrefix(symbol, prefix)
      end
    end
  end
  def dump
    _finish()
    Jena::RDFDataMgr.write(java.lang.System.out, @jmodel, Jena::Lang.TURTLE)
  end
end
