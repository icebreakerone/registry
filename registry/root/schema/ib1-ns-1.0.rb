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

  RdfSchemaClass.new(IB1::Role.uri) do |c|
    c.sub_class_of RDFS::Resource
  end
  # TODO: Properties for Role

  RdfSchemaClass.new(IB1::SchemeCatalogRequirements.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  RdfSchemaClass.new(IB1::RequiredMetadata.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  RdfSchemaClass.new(IB1::Licence.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  RdfSchemaClass.new(IB1::AssuranceLevel.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  RdfSchemaClass.new(IB1::SensitivityClass.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  RdfSchemaClass.new(IB1::SourceType.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  RdfSchemaClass.new(IB1::Process.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  RdfSchemaClass.new(IB1::Policy.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  # -------------------------------------------------------------------------

  RdfSchemaProperty.new(Ns.ib1("trustFramework")) do |p|
    p.comment "The Trust Framework which governs this resource."
    p.range IB1::TrustFramework
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::Role
    p.domain IB1::SchemeCatalogRequirements
    p.domain IB1::Licence
  end

  RdfSchemaProperty.new(Ns.ib1("scheme")) do |p|
    p.comment "The Scheme which governs this resource."
    p.range IB1::Scheme
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::Role
    p.domain IB1::SchemeCatalogRequirements
    p.domain IB1::Licence
  end

  # TODO: How should version numbers be handled? Nothing seems to have a concept of a version number
  RdfSchemaProperty.new(Ns.ib1("version")) do |p|
    p.comment "Identifier of a version, usually a version number."
    p.range RDFS::Literal
    p.domain IB1::Licence
    p.domain IB1::Policy
  end

  RdfSchemaProperty.new(Ns.ib1("licenceTerms")) do |p|
    p.comment "URL of the licence terms."
    p.range RDFS::Resource
    p.domain IB1::Licence
  end

  RdfSchemaProperty.new(Ns.ib1("licenceDuration")) do |p|
    p.comment "Licence duration as a structured string."
    p.range RDFS::Literal
    p.domain IB1::Licence
  end

  RdfSchemaProperty.new(Ns.ib1("permittedUse")) do |p|
    p.comment "Permitted use allowed by a licence."
    p.range RDFS::Literal
    p.domain IB1::Licence
  end

  RdfSchemaProperty.new(Ns.ib1("additionalCondition")) do |p|
    p.comment "Additional conditions for a licence."
    p.range RDFS::Literal
    p.domain IB1::Licence
  end

  RdfSchemaProperty.new(Ns.ib1("permissionText")) do |p|
    p.comment "Permission text which must be used to seek permission from an end user."
    p.range RDFS::Resource
    p.domain IB1::Licence
  end

  RdfSchemaProperty.new(Ns.ib1("policyText")) do |p|
    p.comment "URL of the licence terms."
    p.range RDFS::Resource
    p.domain IB1::Policy
  end

  RdfSchemaProperty.new(Ns.ib1("datasetAssurance")) do |p|
    p.comment "Assurance level for a dataset."
    p.range IB1::AssuranceLevel
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::RequiredMetadata
  end

  RdfSchemaProperty.new(Ns.ib1("sensitivityClass")) do |p|
    p.comment "Sensitivity class for a dataset."
    p.range IB1::SensitivityClass
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

  RdfSchemaProperty.new(Ns.ib1("roleRequiredToAccess")) do |p|
    p.comment "Role of Trust Framework Members who can access this resource."
    p.range IB1::Role
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::RequiredMetadata
  end

  RdfSchemaProperty.new(Ns.ib1("roleRequiredToPublish")) do |p|
    p.comment "Role of Trust Framework Members who can publish resources meeting this standard."
    p.range IB1::Role
    p.domain IB1::SchemeCatalogRequirements
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

IB1::ASSURANCE_LEVELS.each do |label, comment|
  AssuranceLevel.new(Ns.ib1(label)) do |l|
    l.label label
    l.comment comment
  end
end

IB1::SENSITIVITY_CLASSES.each do |label, comment|
  SensitivityClass.new(Ns.ib1(label)) do |c|
    c.label label
    c.comment "#{comment} (#{label})"
  end
end
