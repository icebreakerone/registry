# frozen_string_literal: true

$CLASSPATH.append(File.open("script/.classpath.txt") { |f| f.read.split(':') })

module Jena
  ModelFactory = org.apache.jena.rdf.model.ModelFactory
  RDFDataMgr = org.apache.jena.riot.RDFDataMgr
  Lang = org.apache.jena.riot.Lang
end

def _require_all(pattern)
  Dir.glob(pattern).sort.each do |file|
    require file
  end
end

# Load scripts
_require_all("./script/ruby/registry/**/*.rb")

# Load model
_require_all("./model/**/*.rb")

# TODO: Configurable prefix
Ns.namespace(:ib1, "https://registry.ib1.org/ns/1.0#")

require "./ib1_schema/ib1.rb"

model = RdfModel.new
ResourceClass.all_resources.each do |resource|
  model.add(resource)
end
model.dump
