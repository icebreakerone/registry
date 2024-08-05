$CLASSPATH.append(File.open("script/.classpath.txt") { |f| f.read.split(':') })

module Jena
  ModelFactory = org.apache.jena.rdf.model.ModelFactory
  RDFDataMgr = org.apache.jena.riot.RDFDataMgr
  Lang = org.apache.jena.riot.Lang
end

model = Jena::ModelFactory.createDefaultModel()
model.setNsPrefix("ex", "http://example.org/something/")
# model.setNsPrefix("rdf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
model.setNsPrefix("rdfs", "http://www.w3.org/2000/01/rdf-schema#")
resource = model.createResource("https://example.org/abc2")
resource.addProperty(model.createProperty("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "type"), 
  model.createResource("http://www.w3.org/2000/01/rdf-schema#Property"))
resource.addProperty(model.createProperty("http://example.org/something/", "sdf"), "ABC Two");
model.createProperty("http://example.org/something/", "sdf")

Jena::RDFDataMgr.write(java.lang.System.out, model, Jena::Lang.TURTLE)
