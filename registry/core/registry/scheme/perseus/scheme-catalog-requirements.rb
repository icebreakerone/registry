
# TODO: Persues standards, uncomment inclusion in perseus.rb

SchemeCatalogRequirements.new do |r|
  r.label "consumption-data"
  r.comment "Consumption data API"
  r.required_type DCAT::DataService
  r.role_required_to_publish Role.at("scheme/perseus/role/carbon-accounting")
  r.required_metadata do |m|
    m.endpoint_description RegistryFiles.openapi("consumption-data", "0.0.1")
    m.heartbeat_description RegistryFiles.openapi("heartbeat", "0.1")
    m.licence LicenceInterpretation.at("scheme/perseus/licence/cc-by/4.0")
    m.sensitivity_class SensitivityClass::IB1_SP
    m.dataset_assurance AssuranceLevel::Level2
    m.dataset_assurance AssuranceLevel::Level3
    m.dataset_assurance AssuranceLevel::Level4
    m.role_required_to_access Role.at("scheme/perseus/role/consumption-reader")
  end
  r.require_all_and_allow_additional RequiredMetadata::ROLE_REQUIRED_TO_ACCESS
  r.require_any_one_of RequiredMetadata::DATASET_ASSURANCE # Effect is "at least level 2"
end
