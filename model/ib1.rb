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
  Grant = RdfClass.new(Ns.ib1("Grant"))
  Obligation = RdfClass.new(Ns.ib1("Obligation"))

  GRANTS = [
    ['use_any', 'Use the artefact internally for any purpose'],
    ['use_dev', 'Use the artefact internally for development purposes only (i.e. private or limited development of new works, products or services)'],
    ['use_noncom', 'Use the artefact internally for non-commercial purposes only (e.g. education, research, charity work etc.)'],
    ['adapt_any', 'Adapt the artefact for internal use for any purpose'],
    ['adapt_dev', 'Adapt the artefact for internal use for development purposes only (i.e. private or limited development of new works, products or services)'],
    ['adapt_noncom', 'Adapt the artefact for internal use for non-commercial purposes only (e.g. education, research, charity work etc.)'],
    ['combine_any', "Combine ('remix') the artefact with any other artefacts"],
    ['combine_external', "Combine ('remix') the artefact with other external artefacts"],
    ['combine_internal', "Combine ('remix') the artefact with the Data Consumer's own products or services"],
    ['redistribute_original', "Redistribute ('onward share' - including to any customers of the Service Provider) the original artefact"],
    ['redistribute_derived', "Redistribute ('onward share' - including to any customers of the Service Provider) derivatives of the original artefact not produced from other data sets, i.e. filtered or cleaned data"],
    ['redistribute_combined', "Redistribute ('onward share' - including to any customers of the Service Provider) derivatives of the artefact produced through artefact combination or use in the Data Consumer's own products or services"]
  ]
  OBLIGATIONS = [
    ['ft', 'Re-users must display the full text of the license every time they use the work'],
    ['by', 'Re-users must attribute the work to the original source when they use it'],
    ['sa', 'Re-users who create derivatives of the work must release the derivatives under the same license as the original work, if they choose to distribute the derivatives']
  ]
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

class Grant < Resource # Doesn't need to be in a Scheme or TrustFramework
  rdf_class IB1::Grant.uri
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :trust_framework, Ns.ib1("trustFramework"), TrustFramework
  property :scheme, Ns.ib1("scheme"), Scheme
end
IB1::GRANTS.each do |label, comment|
  uri = Ns.ib1(label).as(Grant::URI)
  Grant.class.define_method(label.to_sym) { uri }
end

class Obligation < Resource # Doesn't need to be in a Scheme or TrustFramework
  rdf_class IB1::Obligation.uri
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :trust_framework, Ns.ib1("trustFramework"), TrustFramework
  property :scheme, Ns.ib1("scheme"), Scheme
end
IB1::OBLIGATIONS.each do |label, comment|
  uri = Ns.ib1(label).as(Obligation::URI)
  Obligation.class.define_method(label.to_sym) { uri }
end

class LicenceInterpretation < SchemeResource
  include RegistryResource::AddVersionToUri
  rdf_class IB1::LicenceInterpretation.uri
  type_name_for_url :licence
  property :label, Ns.rdfs("label"), String
  property :version, Ns.ib1("versionIdentifier"), String
  property :comment, Ns.rdfs("comment"), String
  property :licence_url, Ns.dcterms("licence"), RdfUri
  property :grant, Ns.rdfs("grant"), Grant
  property :obligation, Ns.rdfs("obligation"), Obligation
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
