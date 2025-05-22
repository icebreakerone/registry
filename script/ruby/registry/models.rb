# frozen_string_literal: true

require 'date'


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
  def as(klass)
    raise "Class must be subtype of RdfUri" unless klass <= RdfUri
    klass.new(@prefix, @suffix)
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
  def self.namespace(symbol, prefix, dont_set_as_rdf_prefix = false)
    @@all_prefix << [symbol, prefix, dont_set_as_rdf_prefix]
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

Ns.namespace(:xsd, "http://www.w3.org/2001/XMLSchema#")

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

  attr_reader :registry_files
  def files(source, destination)
    raise "Already set files for context" if @registry_files
    @registry_files = RegistryFiles.new(source, destination)
  end
  def self._current_files
    @@stack.reverse.map {|c| c.registry_files}.compact
  end
end

# ---------------------------------------------------------------------------

module IncludeIn
  def self.environment(env, name)
    if ENVIRONMENT == env
      yield
    else
      puts "\n*** Omitting '#{name}' as environment is not '#{env}'\n\n"
    end
  end
end

# ---------------------------------------------------------------------------

class Resource
  attr_reader :uri

  @@all_resources = []
  @@pending_type_checks = []
  def self.clear_all
    @@all_resources.clear
    @@pending_type_checks.clear
  end

  def self.rdf_class(klass)
    self.const_set(:RDF_CLASS, klass)
  end

  def self.inherited(subclass)
    # Typed subclass for Resource URIs
    subclass.const_set(:URI, Class.new(RdfUri))
  end

  def initialize(uri = nil)
    @uri = uri
    @properties = [[RDF::Type.uri, self.class.const_get(:RDF_CLASS, false), :type]]
    Context._resource_added(self)
    @defined_at = caller.find { |e| e.start_with?(REGISTRY_SOURCE) }
    return if uri == :bnode
    yield self if block_given?
    @@all_resources << self
  end

  # Private for template
  def _properties_for_template
    @properties
  end
  def _bnodes_for_template
    @bnodes || []
  end

  def self.property(symbol, uri, *value_classes)
    # Add Resource URI classes to allowed classes
    classes = value_classes.dup
    value_classes.each do |klass|
      begin
        classes << klass.const_get(:URI, false)
      rescue NameError
        # Ignore, not a Resource class
      end
    end
    raise "No value classes set" if classes.empty?
    define_method(symbol) do |value|
      raise "Value should be #{classes.map { |k| k.name } .join(' or ')}" unless classes.find { |k| value.kind_of?(k) }
      @properties << [uri, value, symbol]
      self
    end
    define_method("first_#{symbol}".to_sym) do
      value_a = @properties.find { |_,_,s| s == symbol}
      raise "No #{symbol} property added to resource defined at #{@defined_at}" if value_a.nil?
      value_a[1]
    end
  end

  def self.bnode(symbol, uri, node_class)
    define_method(symbol) do |&block|
      @bnodes ||= []
      bnode = node_class.new(:bnode)
      bnode.mark_as_bnode!
      @bnodes << [uri, bnode, symbol]
      block.call bnode
      self
    end
  end

  def self.at(uri_suffix)
    @@pending_type_checks << [self, uri_suffix, caller.find { |e| e.start_with?(REGISTRY_SOURCE) }]
    self.const_get(:URI).new(Ns.registry_prefix, uri_suffix)
  end

  def self.perform_final_validation
    @@pending_type_checks.each do |klass, uri_suffix, defined_at|
      unless @@all_resources.find { |r| (r.class == klass) && (r.uri.suffix == uri_suffix) }
        raise "#{klass.name} with suffix #{uri_suffix} hasn't been defined, but was used at #{defined_at}"
      end
    end
  end

  def self.all_resources
    @@all_resources.dup
  end

  def find_all_linked_resources
    @@all_resources.filter do |r|
      r.is_linked_to?(self)
    end
  end

  def is_linked_to?(resource)
    suffix = resource.uri.suffix
    @properties.each do |uri, value, symbol|
      v = value.kind_of?(Resource) ? value.uri : value
      return true if v.kind_of?(RdfUri) && v.suffix == suffix
    end
    if @bnodes
      @bnodes.each do |uri, bn, symbol|
        return true if bn.is_linked_to?(resource)
      end
    end
    false
  end

  def _to_rdf_value(jmodel)
    jmodel.createResource(self.uri.to_uri_s)
  end

  def _add_terms_to(jresource, model)
    @properties.each do |uri, value|
      model._add_property(jresource, uri, value)
    end
    (@bnodes || []).each do |uri, bnode|
      jbnode = model.jmodel.createResource()
      bnode._add_terms_to(jbnode, model)
      model._add_property(jresource, uri, jbnode)
    end
  end

  def mark_as_bnode!; @is_bnode = true; end
  def is_bnode?; @is_bnode; end
end

# ---------------------------------------------------------------------------

class RegistryResource < Resource
  def uri
    @uri ||= Ns.registry(self.generate_uri_suffix)
  end
  def generate_uri_suffix
    raise "generate_uri_suffix must be defined for #{self.class.name}"
  end
  def human_readable_name
    [:comment, :label].each do |try_symbol|
      @properties.each do |_, value, symbol|
        return value.to_s if symbol == try_symbol
      end
    end
  end
end

# ---------------------------------------------------------------------------

class Date
  def _to_rdf_value(jmodel)
    jmodel.createTypedLiteral(
      self.to_s(),
      Jena::XSDDatatype::XSDdate
    )
  end
end

class RdfModel
  attr_reader :resources
  attr_reader :jmodel
  OUTPUT_FORMATS = [
    [Jena::Lang.TURTLE, '.ttl', 'RDF (Turtle)'],
    [Jena::Lang.RDFXML, '.rdf', 'RDF/XML'],
    [Jena::Lang.JSONLD, '.jsonld', 'RDF (JSON-LD)']
  ]
  def initialize
    @jmodel = Jena::ModelFactory.createDefaultModel()
    @used_prefix = {
      "http://www.w3.org/2001/XMLSchema#" => true # for value types
    }
    @resources = []
  end
  def add(resource)
    raise "Mustn't add bnodes" if resource.is_bnode?
    jresource = @jmodel.createResource(resource.uri.to_uri_s)
    resource._add_terms_to(jresource, self)
    @resources << resource
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
    Ns.each_prefix do |symbol, prefix, dont_set_as_rdf_prefix|
      if @used_prefix[prefix] && !dont_set_as_rdf_prefix
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
