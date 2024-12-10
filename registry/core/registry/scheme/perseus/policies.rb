
Policy.new do |p|
  p.label "data-licence"
  p.comment "Use of Perseus consent text in Scheme data transfers"
  p.policy_text PolicyFile.name("data-licence", INITIAL_REGISTRY_VERSION)
end
