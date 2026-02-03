
SchemeCatalogRequirements.new do |v|
  # Using "version" (not change) because it is a version, the Change resource just describes it.
  v.version "PERSEUS-INITIAL" do |r|
    r.available_from :CHANGE # could specify a date explicitly, but this just uses the date of the Change resource.
    r.label "energy-consumption-data"
    r.comment "Energy Consumption Data API"
    r.required_type DCAT::DataService
    r.role_required_to_publish Role.at("scheme/perseus/role/energy-data-provider")
    r.required_metadata do |m|
                                              # Using the Change ID here, explicitly
      m.endpoint_description OpenAPIFile.name("consumption-data", "PERSEUS-INITIAL")
      m.heartbeat_description OpenAPIFile.name("heartbeat", "PERSEUS-INITIAL")
      m.license License.at("scheme/perseus/license/energy-consumption-data/#{Change.id("PERSEUS-INITIAL")}")
      m.sensitivity_class SensitivityClass::IB1_SP
      m.dataset_assurance DatasetAssuranceLevel::GenericLevel2
      m.dataset_assurance DatasetAssuranceLevel::GenericLevel3
      m.dataset_assurance DatasetAssuranceLevel::GenericLevel4
      m.role_required_to_access Role.at("scheme/perseus/role/carbon-accounting-provider")
    end
    r.require_all_and_allow_additional RequiredMetadata::ROLE_REQUIRED_TO_ACCESS
    r.require_any_one_of RequiredMetadata::DATASET_ASSURANCE # Effect is "at least level 2"
  end

  v.version "INDUSTRY-COMPLIANCE-2024" do |r|
    r.required_metadata do |m|
      m.license License.at("scheme/perseus/license/energy-consumption-data/#{Change.id("INDUSTRY-COMPLIANCE-2024")}")
    end
    # Can't change the deprecatedAfter, prohibitedAfter of a version on that version itself,
    # because it wouldn't be associated with the right change.
    # Change resource will need a "changesDeprecationOf" term to link to the older versions it modifies.
    r.deprecate_other_version "PERSEUS-INITIAL", "2026-06-01"
  end
end

SchemeCatalogRequirements.new do |r|
  v.version "PERSEUS-INITIAL" do |r|
    r.label "emissions-report"
    r.comment "Emissions Report API"
    r.required_type DCAT::DataService
    r.role_required_to_publish Role.at("scheme/perseus/role/carbon-accounting-provider")
    r.required_metadata do |m|
      # TODO: OpenAPI file for emissions report
      # m.endpoint_description RegistryFiles.openapi("emissions-report", INITIAL_REGISTRY_VERSION)
      m.heartbeat_description OpenAPIFile.name("heartbeat", INITIAL_REGISTRY_VERSION)
      m.license License.at("scheme/perseus/license/emissions-report/#{INITIAL_REGISTRY_VERSION}")
      m.sensitivity_class SensitivityClass::IB1_SP
      m.dataset_assurance DatasetAssuranceLevel::GenericLevel2
      m.dataset_assurance DatasetAssuranceLevel::GenericLevel3
      m.dataset_assurance DatasetAssuranceLevel::GenericLevel4
      m.role_required_to_access Role.at("scheme/perseus/role/financial-service-provider")
    end
    r.require_all_and_allow_additional RequiredMetadata::ROLE_REQUIRED_TO_ACCESS
    r.require_any_one_of RequiredMetadata::DATASET_ASSURANCE # Effect is "at least level 2"
  end
end
