
SchemeCatalogRequirements.new do |r|
  r.label "energy-consumption-data"
  r.comment "Energy Consumption Data API"
  r.required_type DCAT::DataService
  r.role_required_to_publish Role.at("scheme/perseus/role/energy-data-provider")
  r.required_metadata do |m|
    m.endpoint_description OpenAPIFile.name("consumption-data", INITIAL_REGISTRY_VERSION)
    m.heartbeat_description OpenAPIFile.name("heartbeat", INITIAL_REGISTRY_VERSION)
    m.license License.at("scheme/perseus/license/energy-consumption-data/#{INITIAL_REGISTRY_VERSION}")
    m.sensitivity_class SensitivityClass::IB1_SP
    m.dataset_assurance AssuranceLevel::Level2
    m.dataset_assurance AssuranceLevel::Level3
    m.dataset_assurance AssuranceLevel::Level4
    m.role_required_to_access Role.at("scheme/perseus/role/carbon-accounting-provider")
  end
  r.require_all_and_allow_additional RequiredMetadata::ROLE_REQUIRED_TO_ACCESS
  r.require_any_one_of RequiredMetadata::DATASET_ASSURANCE # Effect is "at least level 2"
end

SchemeCatalogRequirements.new do |r|
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
    m.dataset_assurance AssuranceLevel::Level2
    m.dataset_assurance AssuranceLevel::Level3
    m.dataset_assurance AssuranceLevel::Level4
    m.role_required_to_access Role.at("scheme/perseus/role/financial-service-provider")
  end
  r.require_all_and_allow_additional RequiredMetadata::ROLE_REQUIRED_TO_ACCESS
  r.require_any_one_of RequiredMetadata::DATASET_ASSURANCE # Effect is "at least level 2"
end
