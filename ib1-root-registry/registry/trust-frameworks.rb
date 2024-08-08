
TrustFrameworkGroup.new(Ns.registry("trust-frameworks")) do |g|
  g.comment "All Trust Frameworks operated by Icebreaker One"
  g.member RdfUri.new("https://registry.core.#{ENVIRONMENT_HOSTNAME_PART}ib1.org/trust-framework", nil)
end
