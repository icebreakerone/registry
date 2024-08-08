# frozen_string_literal: true

# TODO: Configurable prefix
Ns.namespace(:ib1, "https://registry.ib1.org/ns/1.0#")

module IB1
  TrustFramework = RdfClass.new(Ns.ib1("TrustFramework"))
  TrustFrameworkGroup = RdfClass.new(Ns.ib1("TrustFrameworkGroup"))
  MemberGroup = RdfClass.new(Ns.ib1("MemberGroup"))
  SchemeCatalogRequirements = RdfClass.new(Ns.ib1("SchemeCatalogRequirements"))
  RequiredMetadata = RdfClass.new(Ns.ib1("RequiredMetadata"))
end

class TrustFrameworkGroup < Resource
  rdf_class IB1::TrustFrameworkGroup.uri
  property :comment, Ns.rdfs("comment"), String
  property :member, Ns.dc("relation"), RdfUri # TODO: Better term for member URLs
end
