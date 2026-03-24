
estf = TrustFramework.new do |tf|
  tf.label "estf"
  tf.comment "Energy Sector Trust Framework"
end

Context.within do |context|
  context.every_resource do |resource|
    resource.trust_framework estf
  end
#  context.files("#{File.dirname(__FILE__)}/files", "")

  TechnicalProfileTF.new do |p|
    p.label "estf"
    p.comment "Energy Sector Trust Framework Technical Profile"
    p.version "2026-02-18"
    p.uses RdfUri.new("https://specification.trust.ib1.org/registry/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/registry-versioning/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/registry-process-resources/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/machine-readable-data-licenses/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/role-based-access-control/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/member-identity-digital-certificates/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/directory-issued-server-tls-certificates/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/baseline-tls-configuration/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/oauth-with-member-identity-certificates/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/message-delivery-to-applications/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/withdrawal-of-permission/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/permission-records/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/provenance-records/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/data-catalog-records/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/data-catalog-publishing/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/generic-dataset-assurance-levels/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/generic-sensitivity-classes/1.0/", nil)
  end

  IncludeIn.environment(['production', 'sandbox'], 'Assured Open Data') do
    require "#{File.dirname(__FILE__)}/scheme/assured-open-data/assured-open-data.rb"
  end
end
