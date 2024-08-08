# frozen_string_literal: true

IB1_SCHEMA_DOCUMENT_URL = RdfUri.new(Ns.ib1_prefix.gsub(/\#\z/,''), nil)

Context.within do |context|
  context.every_resource do |resource|
    resource.is_defined_by IB1_SCHEMA_DOCUMENT_URL
    resource.label resource.uri.suffix
  end

  # -------------------------------------------------------------------------

  RdfSchemaClass.new(IB1::TrustFramework.uri) do |c|
    c.sub_class_of RDFS::Resource
  end
  # TODO: Properties for TrustFramework

  RdfSchemaClass.new(IB1::TrustFrameworkGroup.uri) do |c|
    c.sub_class_of RDFS::Resource
  end
  # TODO: Properties for TrustFrameworkGroup

  RdfSchemaClass.new(IB1::MemberGroup.uri) do |c|
    c.sub_class_of RDFS::Resource
  end
  # TODO: Properties for MemberGroup

  RdfSchemaClass.new(IB1::SchemeCatalogRequirements.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  RdfSchemaClass.new(IB1::RequiredMetadata.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  # -------------------------------------------------------------------------

  RdfSchemaProperty.new(Ns.ib1("trustFramework")) do |p|
    p.comment "The Trust Framework which governs this resource."
    p.range IB1::TrustFramework
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::SchemeCatalogRequirements
  end

  RdfSchemaProperty.new(Ns.ib1("datasetAssurance")) do |p|
    p.comment "Assurance level for a dataset."
    p.range RDFS::Literal  # TODO: This should use Resource URLs as an enum
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::RequiredMetadata
  end

  RdfSchemaProperty.new(Ns.ib1("sensitivityClass")) do |p|
    p.comment "Sensitivity class for a dataset."
    p.range RDFS::Literal  # TODO: This should use Resource URLs as an enum
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::RequiredMetadata
  end

  RdfSchemaProperty.new(Ns.ib1("oauthIssuer")) do |p|
    p.comment "OAuth Issuer URL used to obtain Permission to access this resource."
    p.range RDFS::Resource
    p.domain DCAT::DataService
    p.domain IB1::RequiredMetadata
  end

  RdfSchemaProperty.new(Ns.ib1("permitGroup")) do |p|
    p.comment "A Group of Trust Framework Members who can access this resource."
    p.range IB1::MemberGroup
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::RequiredMetadata
  end

  RdfSchemaProperty.new(Ns.ib1("heartbeatDescription")) do |p|
    p.comment "URL of an OpenAPI definition of heatbeat service."
    p.range RDFS::Resource
    p.domain DCAT::DataService
    p.domain IB1::RequiredMetadata
  end

  RdfSchemaProperty.new(Ns.ib1("dataSchema")) do |p|
    p.comment "The URL of a schema file specifying the format of the downloadable file."
    p.range RDFS::Resource
    p.domain DCAT::Dataset
    p.domain IB1::RequiredMetadata
  end

  RdfSchemaProperty.new(Ns.ib1("requiredType")) do |p|
    p.comment "The type of the DCAT Catalog entry which describes the conforming data source."
    p.range RDF::Type
    p.domain IB1::SchemeCatalogRequirements
  end

  RdfSchemaProperty.new(Ns.ib1("requiredMetadata")) do |p|
    p.comment "The metadata values required for the conforming data source."
    p.range IB1::RequiredMetadata
    p.domain IB1::SchemeCatalogRequirements
  end

  RdfSchemaProperty.new(Ns.ib1("requireAllAndAllowAdditional")) do |p|
    p.comment "All the values in the requirements must be included for this term, but additional values are allowed."
    p.range RDFS::Property
    p.domain IB1::SchemeCatalogRequirements
  end

  RdfSchemaProperty.new(Ns.ib1("requireAnyOneOf")) do |p|
    p.comment "Exactly one of the values in the requirements must be included for this term. No other values are allowed."
    p.range RDFS::Property
    p.domain IB1::SchemeCatalogRequirements
  end

  RdfSchemaProperty.new(Ns.ib1("requireAnyValue")) do |p|
    p.comment "The term must be present, with any valid value."
    p.range RDFS::Property
    p.domain IB1::SchemeCatalogRequirements
  end

  RdfSchemaProperty.new(Ns.ib1("requireAbsenceOf")) do |p|
    p.comment "The term must not be present."
    p.range RDFS::Property
    p.domain IB1::SchemeCatalogRequirements
  end

end
