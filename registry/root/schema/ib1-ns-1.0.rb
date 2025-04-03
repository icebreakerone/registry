# frozen_string_literal: true

IB1_SCHEMA_DOCUMENT_URL = RdfUri.new(Ns.ib1_prefix.gsub(/\#\z/,''), nil)

Context.within do |context|
  context.every_resource do |resource|
    resource.is_defined_by IB1_SCHEMA_DOCUMENT_URL
    resource.label resource.uri.suffix
  end

  versioned_classes = []

  # -------------------------------------------------------------------------

  RdfSchemaClass.new(IB1::RegistryChange.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

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
  versioned_classes << IB1::SchemeCatalogRequirements

  RdfSchemaClass.new(IB1::RequiredMetadata.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  RdfSchemaClass.new(IB1::License.uri) do |c|
    c.sub_class_of RDFS::Resource
  end
  versioned_classes << IB1::License

  RdfSchemaClass.new(IB1::DatasetAssuranceLevel.uri) do |c|
    c.sub_class_of RDFS::Resource
  end

  RdfSchemaClass.new(IB1::SensitivityClassRequirement.uri) do |c|
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
  versioned_classes << IB1::Process

  RdfSchemaClass.new(IB1::Agreement.uri) do |c|
    c.sub_class_of RDFS::Resource
  end
  versioned_classes << IB1::Agreement

  RdfSchemaClass.new(IB1::Policy.uri) do |c|
    c.sub_class_of RDFS::Resource
  end
  versioned_classes << IB1::Policy

  # -------------------------------------------------------------------------

  RdfSchemaProperty.new(Ns.ib1("trustFramework")) do |p|
    p.comment "The Trust Framework which governs this resource."
    p.range IB1::TrustFramework
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::Role
    p.domain IB1::SchemeCatalogRequirements
    p.domain IB1::License
  end

  RdfSchemaProperty.new(Ns.ib1("scheme")) do |p|
    p.comment "The Scheme which governs this resource."
    p.range IB1::Scheme
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::Role
    p.domain IB1::SchemeCatalogRequirements
    p.domain IB1::License
  end

  # -------------------------------------------------------------------------
  # Registry versioning

  RdfSchemaProperty.new(Ns.ib1("version")) do |p|
    p.comment "Identifier of a version, usually a version number."
    p.range RDFS::Literal
    versioned_classes.each { |klass| p.domain klass }
  end

  RdfSchemaProperty.new(Ns.ib1("availableFrom")) do |p|
    p.comment "Earliest time when this resource may be used."
    p.range RDFS::Literal
    versioned_classes.each { |klass| p.domain klass }
  end

  RdfSchemaProperty.new(Ns.ib1("deprecatedAfter")) do |p|
    p.comment "Latest time this resource may be used for new applications. Not present or in the future for the current version."
    p.range RDFS::Literal
    versioned_classes.each { |klass| p.domain klass }
  end

  RdfSchemaProperty.new(Ns.ib1("prohibitedAfter")) do |p|
    p.comment "May not be used after this time. ib1:deprecatedAfter must be set, with a datetime no later than this time."
    p.range RDFS::Literal
    versioned_classes.each { |klass| p.domain klass }
  end

  RdfSchemaProperty.new(Ns.ib1("hasCurrentVersion")) do |p|
    p.comment "URI of the current version of this resource. The current version has a URL pointing to itself."
    p.range RDFS::Resource
    versioned_classes.each { |klass| p.domain klass }
  end

  RdfSchemaProperty.new(Ns.ib1("previousVersion")) do |p|
    p.comment "URI of the previous version."
    p.range RDFS::Resource
    versioned_classes.each { |klass| p.domain klass }
  end

  RdfSchemaProperty.new(Ns.ib1("registryChange")) do |p|
    p.comment "URI of a resource which explains why the Registry was changed."
    p.range IB1::RegistryChange
    versioned_classes.each { |klass| p.domain klass }
  end

  # -------------------------------------------------------------------------

  RdfSchemaProperty.new(Ns.ib1("licenseTerms")) do |p|
    p.comment "URL of the license terms."
    p.range RDFS::Resource
    p.domain IB1::License
  end

  RdfSchemaProperty.new(Ns.ib1("licenseDuration")) do |p|
    p.comment "License duration as a structured string."
    p.range RDFS::Literal
    p.domain IB1::License
  end

  RdfSchemaProperty.new(Ns.ib1("permittedUse")) do |p|
    p.comment "Permitted use allowed by a license."
    p.range RDFS::Literal
    p.domain IB1::License
  end

  RdfSchemaProperty.new(Ns.ib1("additionalCondition")) do |p|
    p.comment "Additional conditions for a license."
    p.range RDFS::Literal
    p.domain IB1::License
  end

  RdfSchemaProperty.new(Ns.ib1("permissionText")) do |p|
    p.comment "Permission text which must be used to seek permission from an end user."
    p.range RDFS::Resource
    p.domain IB1::License
  end

  RdfSchemaProperty.new(Ns.ib1("agreementText")) do |p|
    p.comment "URL of the agreement terms."
    p.range RDFS::Resource
    p.domain IB1::Agreement
  end

  RdfSchemaProperty.new(Ns.ib1("policyText")) do |p|
    p.comment "URL of the license terms."
    p.range RDFS::Resource
    p.domain IB1::Policy
  end

  RdfSchemaProperty.new(Ns.ib1("processDescription")) do |p|
    p.comment "Formal human readable description of the Process."
    p.range RDFS::Resource
    p.domain IB1::Process
  end

  RdfSchemaProperty.new(Ns.ib1("datasetAssurance")) do |p|
    p.comment "Assurance level for a dataset."
    p.range IB1::DatasetAssuranceLevel
    p.domain DCAT::Dataset
    p.domain DCAT::DataService
    p.domain IB1::RequiredMetadata
  end

  RdfSchemaProperty.new(Ns.ib1("sensitivityClassRequirement")) do |p|
    p.comment "Requirements for data processed with a Sensitivity class."
    p.range IB1::SensitivityClassRequirement
    p.domain IB1::SensitivityClass
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

