
Policy.new do |p|
  p.label "data-licence"
  p.comment "Data Licencing Policy"
  p.policy_text PolicyFile.name("data-licence", INITIAL_REGISTRY_VERSION)
end
