# frozen_string_literal: true

class RdfClass
end

class RdfUri
  def initialize(prefix, suffix)
    @prefix = prefix
    @suffix = suffix
  end
end

class Ns
  def self.namespace(symbol, prefix)
    Ns.class.define_method(symbol) do |suffix|
      RdfUri.new(prefix, suffix)
    end
    Ns.class.define_method("#{symbol}_prefix".to_sym) do
      prefix
    end
  end
end

class ResourceClass < RdfClass
  def self.rdf_class(klass)
    @@klass = klass
  end

  def initialize(uri)
    @properties = []
    yield self if block_given?
  end

  def self.property(symbol, uri, value_class)
    define_method(symbol) do |value|
      raise "Value should be #{value_class.name}" unless value.kind_of?(value_class)
      @properties << [uri, value]
      self
    end
  end
end
