# frozen_string_literal: true

require 'fileutils'
require 'json'

# ---------------------------------------------------------------------------

OUTPUT_DIR = 'output'

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

# ---------------------------------------------------------------------------

if File.directory? OUTPUT_DIR
  puts "Removing old output files..."
  FileUtils.rm_rf OUTPUT_DIR
end
FileUtils.mkdir OUTPUT_DIR
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

# ---------------------------------------------------------------------------

puts "Loading Registry resources..."
require "#{REGISTRY_SOURCE}/resources.rb"

# ---------------------------------------------------------------------------

puts "Writing Registry RDF and HTML..."

File.open("#{OUTPUT_DIR}/index.html", "w") do |f|
  title = registry_info['name']
  f.write Templates::TEMPLATES['index.html.erb'].result(binding)
end
