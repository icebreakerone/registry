
perseus = Scheme.new do |s|
  s.label 'perseus'
  s.comment "Perseus Scheme"
end

INITIAL_REGISTRY_VERSION = "2024-12-05"
initial_perseus_change = RegistryChange.new do |c|
  c.label INITIAL_REGISTRY_VERSION
  c.comment "Perseus Pilot initial Registry contents"
  c.scheme perseus
  # TODO: Rest of the change information
end

Context.within do |context|
  context.every_resource do |resource|
    resource.scheme perseus
    if resource.kind_of? VersionedSchemeResource
      # This is a very minimal implementation of the RegistryChange which will only cope with one change.
      resource.registry_change initial_perseus_change
      resource.version INITIAL_REGISTRY_VERSION
      resource.has_current_version resource
      resource.available_from Date.parse(INITIAL_REGISTRY_VERSION) # TODO: Date time?
    end
  end

  context.files "#{File.dirname(__FILE__)}/files", "scheme/perseus"

  require "#{File.dirname(__FILE__)}/roles.rb"
  require "#{File.dirname(__FILE__)}/licenses.rb"
  require "#{File.dirname(__FILE__)}/scheme-catalog-requirements.rb"
  require "#{File.dirname(__FILE__)}/provenance.rb"
  require "#{File.dirname(__FILE__)}/assurance.rb"
  require "#{File.dirname(__FILE__)}/processes.rb"
  require "#{File.dirname(__FILE__)}/agreements.rb"
  require "#{File.dirname(__FILE__)}/policies.rb"

end
