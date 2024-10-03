# frozen_string_literal: true

Ns.namespace(:rdf, "http://www.w3.org/1999/02/22-rdf-syntax-ns#")

module RDF
  Type = RdfClass.new(Ns.rdf("type"))
end
