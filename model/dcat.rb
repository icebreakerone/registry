# frozen_string_literal: true

Ns.namespace(:dcat, "http://www.w3.org/ns/dcat#")

module DCAT
  Dataset = RdfClass.new(Ns.dcat("Dataset"))
  DataService = RdfClass.new(Ns.dcat("DataService"))
end
