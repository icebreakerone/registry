
TrustFrameworkGroup.new do |g|
  g.label "trust-frameworks"
  g.comment "All Trust Frameworks operated by Icebreaker One"
  g.member RdfUri.new("https://registry.core.#{ENVIRONMENT_HOSTNAME_PART}trust.ib1.org/trust-framework", nil)
end
