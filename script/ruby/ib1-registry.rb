# frozen_string_literal: true

require 'fileutils'

OUTPUT_DIR = 'output'

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

require "./ib1_schema/ib1.rb"

model = RdfModel.new
Resource.all_resources.each do |resource|
  model.add(resource)
end

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

puts "Writing Registry RDF and HTML..."
FileUtils.mkdir_p("#{OUTPUT_DIR}/ns")
model.write_all_formats("#{OUTPUT_DIR}/ns/1.0", "IB1 RDF Schema")

File.open("#{OUTPUT_DIR}/index.html", "w") do |f|
  title = "IB1 Registry"
  f.write Templates::TEMPLATES['index.html.erb'].result(binding)
end
