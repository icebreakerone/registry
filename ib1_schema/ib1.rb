# frozen_string_literal: true

IB1_SCHEMA_DOCUMENT_URL = RdfUri.new(Ns.ib1_prefix.gsub(/\#\z/,''), nil)

RdfSchemaProperty.new(Ns.ib1("trustFramework")) do |p|
  p.label("Trust Framework")
  p.is_defined_by(IB1_SCHEMA_DOCUMENT_URL)
end

RdfSchemaProperty.new(Ns.ib1("datasetAssurance")) do |p|
  p.label("Assurance level for a dataset")
  p.is_defined_by(IB1_SCHEMA_DOCUMENT_URL)
end
