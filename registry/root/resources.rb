
# The root registry also has the RDF schema definition. Write this first, then clear all resources.
require "#{REGISTRY_SOURCE}/schema/ib1-ns-1.0.rb"
Resource.perform_final_validation
begin
  model = RdfModel.new
  Resource.all_resources.each do |resource|
    model.add(resource)
  end
  FileUtils.mkdir_p("#{OUTPUT_DIR}/ns")
  model.write_all_formats("#{OUTPUT_DIR}/ns/1.0", "IB1 RDF Schema")
  Resource.clear_all
end

# Registry resources
require "#{REGISTRY_SOURCE}/registry/policy-purposes.rb"
require "#{REGISTRY_SOURCE}/registry/organization-assurance-levels.rb"
require "#{REGISTRY_SOURCE}/registry/dataset-assurance-levels.rb"
require "#{REGISTRY_SOURCE}/registry/sensitivity-classes.rb"

require "#{REGISTRY_SOURCE}/registry/trust-frameworks.rb"

# Additional resources defined by Specifications
require "#{REGISTRY_SOURCE}/registry/specification/open-data.rb"
require "#{REGISTRY_SOURCE}/registry/specification/assured-open-data.rb"
