# frozen_string_literal: true

Ns.namespace(:rdfs, "http://www.w3.org/2000/01/rdf-schema#")

class RdfSchemaClass < ResourceClass
  rdf_class Ns.rdfs("Class")

  property :sub_class_of, Ns.rdfs("subClassOf"), RdfClass
  property :is_defined_by, Ns.rdfs("isDefinedBy"), RdfUri
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
end

class RdfSchemaProperty < ResourceClass
  rdf_class Ns.rdfs("Property")

  property :is_defined_by, Ns.rdfs("isDefinedBy"), RdfUri
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :domain, Ns.rdfs("domain"), RdfClass
  property :range, Ns.rdfs("range"), RdfClass
end
