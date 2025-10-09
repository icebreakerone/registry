
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
