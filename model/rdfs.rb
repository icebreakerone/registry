# frozen_string_literal: true

Ns.namespace(:rdfs, "http://www.w3.org/2000/01/rdf-schema#")

module RDFS
  Class = RdfClass.new(Ns.rdfs("Class"))
  Property = RdfClass.new(Ns.rdfs("Property"))
  Resource = RdfClass.new(Ns.rdfs("Resource"))
  Literal = RdfClass.new(Ns.rdfs("Literal"))
end

class RdfSchemaClass < Resource
  rdf_class RDFS::Class.uri

  property :sub_class_of, Ns.rdfs("subClassOf"), RdfClass
  property :is_defined_by, Ns.rdfs("isDefinedBy"), RdfUri
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
end

class RdfSchemaProperty < Resource
  rdf_class RDFS::Property.uri

  property :is_defined_by, Ns.rdfs("isDefinedBy"), RdfUri
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :domain, Ns.rdfs("domain"), RdfClass
  property :range, Ns.rdfs("range"), RdfClass
end
