
SchemeCatalogRequirements.new do |r|
  r.label "energy-consumption-data"
  r.comment "Energy Consumption Data API"
  r.required_type DCAT::DataService
  r.role_required_to_publish Role.at("scheme/perseus/role/energy-data-provider")
  r.required_metadata do |m|
    m.endpoint_description RegistryFiles.openapi("consumption-data", "0.0.1")
    m.heartbeat_description RegistryFiles.openapi("heartbeat", "0.1")
    m.licence Licence.at("scheme/perseus/licence/energy-consumption-data/0.1")
    m.sensitivity_class SensitivityClass::IB1_SP
    m.dataset_assurance AssuranceLevel::Level2
    m.dataset_assurance AssuranceLevel::Level3
    m.dataset_assurance AssuranceLevel::Level4
    m.role_required_to_access Role.at("scheme/perseus/role/carbon-accounting-platform")
  end
  r.require_all_and_allow_additional RequiredMetadata::ROLE_REQUIRED_TO_ACCESS
  r.require_any_one_of RequiredMetadata::DATASET_ASSURANCE # Effect is "at least level 2"
end

SchemeCatalogRequirements.new do |r|
  r.label "emissions-report"
  r.comment "Emissions Report API"
  r.required_type DCAT::DataService
  r.role_required_to_publish Role.at("scheme/perseus/role/carbon-accounting-platform")
  r.required_metadata do |m|
    # TODO: OpenAPI file for emissions report
    # m.endpoint_description RegistryFiles.openapi("emissions-report", "0.0.1")
    m.heartbeat_description RegistryFiles.openapi("heartbeat", "0.1")
    m.licence Licence.at("scheme/perseus/licence/emissions-report/0.1")
    m.sensitivity_class SensitivityClass::IB1_SP
    m.dataset_assurance AssuranceLevel::Level2
    m.dataset_assurance AssuranceLevel::Level3
    m.dataset_assurance AssuranceLevel::Level4
    m.role_required_to_access Role.at("scheme/perseus/role/finance-provider")
  end
  r.require_all_and_allow_additional RequiredMetadata::ROLE_REQUIRED_TO_ACCESS
  r.require_any_one_of RequiredMetadata::DATASET_ASSURANCE # Effect is "at least level 2"
end
