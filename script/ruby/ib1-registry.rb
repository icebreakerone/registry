# frozen_string_literal: true

require 'fileutils'
require 'json'

# ---------------------------------------------------------------------------

OUTPUT_DIR = ENV['OUTPUT_DIR'] || 'output'
puts "Output directory: #{OUTPUT_DIR}"
abort("No environment specified as first argument") if ARGV[0].nil?
ENVIRONMENT = ARGV[0]
ENVIRONMENT_HOSTNAME_PART = (ENVIRONMENT == 'production') ? '' : ENVIRONMENT+'.'

abort("No registry source directory specified as second argument") if ARGV[1].nil?
abort("Registry source is not a directory") unless File.directory?(ARGV[1])
REGISTRY_SOURCE = File.expand_path(ARGV[1])
REGISTRY_INFO_JSON = "#{REGISTRY_SOURCE}/registry.json"
abort("registry.json does not exist in Registry source directory") unless File.exist?(REGISTRY_INFO_JSON)

# ---------------------------------------------------------------------------

$CLASSPATH.append(File.open("script/.classpath.txt") { |f| f.read.split(':') })

module Jena
  ModelFactory = org.apache.jena.rdf.model.ModelFactory
  RDFDataMgr = org.apache.jena.riot.RDFDataMgr
  Lang = org.apache.jena.riot.Lang
  XSDDatatype = org.apache.jena.datatypes.xsd.XSDDatatype
end

# Load scripts
require "./script/ruby/registry/models.rb"
require "./script/ruby/registry/files.rb"
require "./script/ruby/registry/templates.rb"

# Load model
require "./model/rdf.rb"
require "./model/rdfs.rb"
require "./model/dc.rb"
require "./model/dcat.rb"
require "./model/ib1.rb"

# ---------------------------------------------------------------------------

if File.directory? OUTPUT_DIR
  puts "Removing old output files..."
  FileUtils.rm_rf OUTPUT_DIR
end
begin
  FileUtils.mkdir OUTPUT_DIR
rescue Errno::EEXIST
  # ignore
end
puts "Copying static files..."
Dir.glob("web/static/**/*").each do |filename|
  unless filename.include?('/.')
    target = OUTPUT_DIR + filename.sub('web/static','')
    if File.file?(filename)
      FileUtils.cp(filename, target)
    else
      FileUtils.mkdir(target, :mode => 0755)
    end
  end
end

# ---------------------------------------------------------------------------

puts "Setting up Registry..."
registry_info = JSON.parse(File.read(REGISTRY_INFO_JSON))
puts "Registry: #{registry_info['name']}"
hostname_part = registry_info['hostnamePart']
DOMAIN_NAME = (hostname_part == '') ? 'ib1.org' : 'trust.ib1.org'
REGISTRY_HOSTNAME_PART = (hostname_part == '') ? '' : hostname_part+'.'
REGISTRY_HOSTNAME = "registry.#{REGISTRY_HOSTNAME_PART}#{ENVIRONMENT_HOSTNAME_PART}#{DOMAIN_NAME}"
puts "Hostname: #{REGISTRY_HOSTNAME}"

REGISTRY_NAME = registry_info['name'] + (ENVIRONMENT == 'production' ? '' : " (#{ENVIRONMENT})")

Ns.namespace(:registry, "https://#{REGISTRY_HOSTNAME}/", true) # not used as prefix in RDF documents

# ---------------------------------------------------------------------------

puts "Loading Registry resources..."
require "#{REGISTRY_SOURCE}/resources.rb"
Resource.perform_final_validation

# ---------------------------------------------------------------------------

puts "Copying Registry files..."
RegistryFiles._copy_to_output

puts "Writing Registry RDF and HTML..."
# All resources as a single file
model = RdfModel.new
Resource.all_resources.each do |resource|
  model.add(resource)
end
model.write_all_formats("#{OUTPUT_DIR}/registry", registry_info['name'])

# Write individual files for resources
Resource.all_resources.each do |resource|
  uri = resource.uri
  if uri.prefix == Ns.registry_prefix
    suffix = uri.suffix
    if !suffix.start_with?('/') && suffix =~ /\A([a-zA-Z0-9\/\-]+\/)?([a-zA-Z0-9][a-zA-Z0-9\.\-]*)\z/   # basic checks on URI so don't accidently splat files everywhere
      dir = $1
      FileUtils.mkdir_p("#{OUTPUT_DIR}/#{dir}") unless dir.nil?
      single_model = RdfModel.new
      single_model.add(resource)
      name = resource.respond_to?(:human_readable_name) ? resource.human_readable_name : "Resource"
      single_model.write_all_formats("#{OUTPUT_DIR}/#{suffix}", name)
    else
      puts "WARNING: Not writing resource with URI suffix #{suffix} as it fails basic checks"
    end
  end
end

File.open("#{OUTPUT_DIR}/index.html", "w") do |f|
  title = REGISTRY_NAME
  registry_index_html = ERB.new(File.read("#{REGISTRY_SOURCE}/index.html")).result(binding)
  f.write Templates::TEMPLATES['index.html.erb'].result(binding)
end
