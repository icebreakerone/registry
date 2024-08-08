
# The root registry also has the RDF schema definition. Write this first, then clear all resources.
require "#{REGISTRY_SOURCE}/schema/ib1-ns-1.0.rb"
model = RdfModel.new
Resource.all_resources.each do |resource|
  model.add(resource)
end
FileUtils.mkdir_p("#{OUTPUT_DIR}/ns")
model.write_all_formats("#{OUTPUT_DIR}/ns/1.0", "IB1 RDF Schema")
Resource.clear_all
