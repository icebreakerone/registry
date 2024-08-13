# frozen_string_literal: true

# TODO: Configurable prefix
Ns.namespace(:ib1, "https://registry.ib1.org/ns/1.0#")

module IB1
  TrustFramework = RdfClass.new(Ns.ib1("TrustFramework"))
  TrustFrameworkGroup = RdfClass.new(Ns.ib1("TrustFrameworkGroup"))
  Scheme = RdfClass.new(Ns.ib1("Scheme"))
  MemberGroup = RdfClass.new(Ns.ib1("MemberGroup"))
  SchemeCatalogRequirements = RdfClass.new(Ns.ib1("SchemeCatalogRequirements"))
  RequiredMetadata = RdfClass.new(Ns.ib1("RequiredMetadata"))
  LicenceInterpretation = RdfClass.new(Ns.ib1("Licence"))
end

# ---------------------------------------------------------------------------

class TrustFrameworkGroup < RegistryResource
  rdf_class IB1::TrustFrameworkGroup.uri

  def generate_uri_suffix
    first_label()
  end

  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :member, Ns.dc("relation"), RdfUri # TODO: Better term for member URLs
end

# ---------------------------------------------------------------------------

class TrustFramework < RegistryResource
  rdf_class IB1::TrustFramework.uri

  def generate_uri_suffix
    'trust-framework'
  end

  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
end

# ---------------------------------------------------------------------------

class Scheme < RegistryResource
  rdf_class IB1::TrustFramework.uri

  def generate_uri_suffix
    "scheme/#{self.first_label}"
  end

  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :trust_framework, Ns.ib1("trustFramework"), TrustFramework
end

# Class for resources within a Scheme which has the required properties and generates a nice URL
class SchemeResource < RegistryResource
  def type_name_for_url
    raise "type_name_for_url must be defined for #{self.class.name}"
  end
  def self.type_name_for_url(symbol)
    define_method(:type_name_for_url) { symbol }
  end
  def generate_uri_suffix
    "#{self.first_scheme.uri.suffix}/#{self.type_name_for_url}/#{self.first_label}"
  end
  property :trust_framework, Ns.ib1("trustFramework"), TrustFramework
  property :scheme, Ns.ib1("scheme"), Scheme
end

# ---------------------------------------------------------------------------

class MemberGroup < SchemeResource
  rdf_class IB1::MemberGroup.uri
  type_name_for_url :group
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
end

# ---------------------------------------------------------------------------

class LicenceInterpretation < SchemeResource
  rdf_class IB1::LicenceInterpretation.uri
  type_name_for_url :licence
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
end

# ---------------------------------------------------------------------------

class RequiredMetadata < SchemeResource
  rdf_class IB1::RequiredMetadata.uri
  property :endpoint_description, Ns.dcat("endpointDescription"), OpenAPIFile
  property :heartbeat_description, Ns.dcat("heartbeatDescription"), OpenAPIFile
  property :permit_group, Ns.ib1("permitGroup"), MemberGroup
  property :licence, Ns.dcterms("licence"), RdfUri # TODO: Typesafe licence URIs
end

class SchemeCatalogRequirements < SchemeResource
  rdf_class IB1::SchemeCatalogRequirements.uri
  type_name_for_url :standard
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  bnode :required_metadata, Ns.ib1("requiredMetadata"), RequiredMetadata
end
