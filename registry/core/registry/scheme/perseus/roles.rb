
Role.new do |g|
  g.label "energy-data-provider"
  g.comment "Energy Data Provider"
end

Role.new do |g|
  g.label "carbon-accounting-platform"
  g.comment "Carbon Accounting Platforms"
end

Role.new do |g|
  g.label "finance-provider"
  g.comment "Finance Providers"
end

# TODO: Remove this role? Mainly here for testing multiple roles in a certificate.
Role.new do |g|
  g.label "auditor"
  g.comment "Auditor"
end
