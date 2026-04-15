
Policy.new do |p|
  p.label "data-license"
  p.comment "Use of Perseus permission text in Scheme data transfers"
  p.policy_purpose PolicyPurpose::DataProtection
  p.policy_text PolicyFile.name("data-license", INITIAL_REGISTRY_VERSION)
end

Policy.new do |v|
  v.version "PERSEUS-INITIAL" do |p|
    p.label "information-provision"
    p.comment "Information Provision"
    p.policy_purpose PolicyPurpose::DataProtection
    p.policy_text PdfFile.name("information-provision-policy", "PERSEUS-INITIAL")
  end
  v.version "DISTRIBUTOR-ACCESS" do |p|
    p.policy_text PdfFile.name("information-provision-policy", "DISTRIBUTOR-ACCESS")
    p.deprecate_other_version "PERSEUS-INITIAL", "2026-06-01"
  end
end

Policy.new do |p|
  p.label "data-retention"
  p.comment "Data Retention"
  p.policy_purpose PolicyPurpose::DataProtection
  p.policy_text PolicyFile.name("data-retention", INITIAL_REGISTRY_VERSION)
end
