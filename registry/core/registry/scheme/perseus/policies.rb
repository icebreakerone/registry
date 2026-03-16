
Policy.new do |p|
  p.label "data-license"
  p.comment "Use of Perseus permission text in Scheme data transfers"
  p.policy_purpose PolicyPurpose::DataProtection
  p.policy_text PolicyFile.name("data-license", INITIAL_REGISTRY_VERSION)
end

Policy.new do |p|
  p.label "information-provision"
  p.comment "Information Provision"
  p.policy_purpose PolicyPurpose::DataProtection
  p.policy_text PdfFile.name("information-provision-policy", INITIAL_REGISTRY_VERSION)
end

Policy.new do |p|
  p.label "data-retention"
  p.comment "Data Retention"
  p.policy_purpose PolicyPurpose::DataProtection
  p.policy_text PolicyFile.name("data-retention", INITIAL_REGISTRY_VERSION)
end

Policy.new do |p|
  p.label "data-license-terms"
  p.comment "Data License Terms"
  p.policy_purpose PolicyPurpose::DataProtection
  p.policy_text PolicyFile.name("data-license-terms", INITIAL_REGISTRY_VERSION)
end

Policy.new do |p|
  p.label "license-metadata-definitions"
  p.comment "License Metadata Definitions"
  p.policy_purpose PolicyPurpose::DataProtection
  p.policy_text PolicyFile.name("license-metadata-definitions", INITIAL_REGISTRY_VERSION)
end
