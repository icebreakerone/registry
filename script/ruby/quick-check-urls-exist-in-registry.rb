# usage
#     cat something | script/quick-check-urls-exist-in-registry output/registry.ttl

REGISTRY_FILE = ARGV[0]
raise "No registry file specified" unless REGISTRY_FILE && File.exist?(REGISTRY_FILE)

$CLASSPATH.append(File.open("script/.classpath.txt") { |f| f.read.split(':') })
module Jena
  RDFDataMgr = org.apache.jena.riot.RDFDataMgr
end

def normalise_url(s)
  s.sub(/\/\/(\w+?\.\w+?\.)(\w+?\.)?trust\.ib1\.org/, '//\1trust.ib1.org')
end

model = Jena::RDFDataMgr.loadModel(REGISTRY_FILE)

urls = Hash.new

model.listStatements().each do |s|
  if s.getSubject().isURIResource()
    urls[normalise_url(s.getSubject().getURI().to_s)] = true
  end
#  if s.getObject().isResource() && s.getObject().asResource().isURIResource()
#    urls[s.getObject().asResource().getURI()] = true
#  end
end

# Print all URLs in the registry file
# urls.keys.sort.each {|k| p k }

input = STDIN.read
not_in_registry = Hash.new
input.scan(/(https?:\/\/[a-z0-9\.-]+?ib1\.org\/[\/A-Za-z0-9\.-]+)/) do
  u = normalise_url($1)
  not_in_registry[u] = true unless urls[u]
#  p $1
end

puts "Not in registry:"
not_in_registry.keys.sort.each { |url| puts url }
