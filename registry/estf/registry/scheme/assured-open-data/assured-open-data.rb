
aod = Scheme.new do |s|
  s.label 'assured-open-data'
  s.comment "Assured Open Data Scheme"
end

INITIAL_REGISTRY_VERSION = "2025-10-20"
initial_aod_change = RegistryChange.new do |c|
  c.label INITIAL_REGISTRY_VERSION
  c.comment "ESTF Assured Open Data scheme initial Registry contents"
  c.scheme aod
  # TODO: Rest of the change information
end

Context.within do |context|
  context.every_resource do |resource|
    resource.scheme aod
    if resource.kind_of? VersionedSchemeResource
      # This is a very minimal implementation of the RegistryChange which will only cope with one change.
      resource.registry_change initial_aod_change
      resource.version INITIAL_REGISTRY_VERSION
      resource.has_current_version resource
      resource.available_from Date.parse(INITIAL_REGISTRY_VERSION) # TODO: Date time?
    end
  end

  TechnicalProfile.new do |p|
    p.comment "Assured Open Data Technical Profile"
    p.uses RdfUri.new("https://specification.trust.ib1.org/registry/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/registry-versioning/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/data-catalog-records/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/data-catalog-publishing/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/generic-sensitivity-classes/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/generic-dataset-assurance-levels/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/open-data/1.0/", nil)
    p.uses RdfUri.new("https://specification.trust.ib1.org/assured-open-data/1.0/", nil)
  end

  context.files "#{File.dirname(__FILE__)}/files", "scheme/assured-open-data"

# Assured Open Data publication doesn't require roles
#  require "#{File.dirname(__FILE__)}/roles.rb"
# Scheme doesn't mandate which Open Data licences are used
#  require "#{File.dirname(__FILE__)}/licenses.rb"
#  require "#{File.dirname(__FILE__)}/scheme-catalog-requirements.rb"
#  require "#{File.dirname(__FILE__)}/provenance.rb"
#  require "#{File.dirname(__FILE__)}/assurance.rb"
#  require "#{File.dirname(__FILE__)}/processes.rb"

  require "#{File.dirname(__FILE__)}/agreements.rb"
  require "#{File.dirname(__FILE__)}/policies.rb"

end
