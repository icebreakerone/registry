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
  LicenceInterpretation = RdfClass.new(Ns.ib1("LicenceInterpretation"))
  Grant = RdfClass.new(Ns.ib1("Grant"))
  Obligation = RdfClass.new(Ns.ib1("Obligation"))
  AssuranceLevel = RdfClass.new(Ns.ib1("AssuranceLevel"))
  SensitivityClass = RdfClass.new(Ns.ib1("SensitivityClass"))

  GRANTS = [
    ['GrantUseAny',           'use_any', 'Use the artefact internally for any purpose'],
    ['GrantUseDevelopment',   'use_dev', 'Use the artefact internally for development purposes only (i.e. private or limited development of new works, products or services)'],
    ['GrantUseNonCommercial', 'use_noncom', 'Use the artefact internally for non-commercial purposes only (e.g. education, research, charity work etc.)'],
    ['GrantAdaptAny',         'adapt_any', 'Adapt the artefact for internal use for any purpose'],
    ['GrantAdaptDevelopment', 'adapt_dev', 'Adapt the artefact for internal use for development purposes only (i.e. private or limited development of new works, products or services)'],
    ['GrantAdaptNonCommercial','adapt_noncom', 'Adapt the artefact for internal use for non-commercial purposes only (e.g. education, research, charity work etc.)'],
    ['GrantCombineAny',       'combine_any', "Combine ('remix') the artefact with any other artefacts"],
    ['GrantCombineExternal',  'combine_external', "Combine ('remix') the artefact with other external artefacts"],
    ['GrantCombineInternal',  'combine_internal', "Combine ('remix') the artefact with the Data Consumer's own products or services"],
    ['GrantRedistributeOriginal','redistribute_original', "Redistribute ('onward share' - including to any customers of the Service Provider) the original artefact"],
    ['GrantRedistributeDerived','redistribute_derived', "Redistribute ('onward share' - including to any customers of the Service Provider) derivatives of the original artefact not produced from other data sets, i.e. filtered or cleaned data"],
    ['GrantRedistributeCombined','redistribute_combined', "Redistribute ('onward share' - including to any customers of the Service Provider) derivatives of the artefact produced through artefact combination or use in the Data Consumer's own products or services"]
  ]
  OBLIGATIONS = [
    ['ObligationFullTextOfLicence', 'ft', 'Re-users must display the full text of the license every time they use the work'],
    ['ObligationAttribution', 'by', 'Re-users must attribute the work to the original source when they use it'],
    ['ObligationSameLicence', 'sa', 'Re-users who create derivatives of the work must release the derivatives under the same license as the original work, if they choose to distribute the derivatives']
  ]
  ASSURANCE_LEVELS = (1..4).map do |level|
    ["AssuranceLevel#{level}", "Assurance level #{level}"]
  end
  SENSITIVITY_CLASSES = [
    ['SensitivityClassClosed', 'Closed data - datasets which must not be shared.'],
    ['SensitivityClassOpen', 'Open Data - full open access, under an open data licence. Free to use, by anyone, for any purpose.'],
    ['SensitivityClassSharedA', 'Shared data - datasets which can/could be shared, but which require the user to agree to standard T&Cs to access. May include some openly licensed materials (e.g. CC BY-SA or GNU AGPLv3).'],
    ['SensitivityClassSharedB', 'Shared data - datasets which can/could be shared, but currently require some bilateral contract negotiation. May include data currently shared on the basis of group-based access. May include aggregated, anonymised or pseudonymised data about individuals.'],
    ['SensitivityClassPersonal', 'Datasets which include personal data, requiring appropriate consent to share, or other legal bases to data processing, as defined by the UK DPA 2018.']
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
  property :is_replaced_by, Ns.dcterms("isReplacedBy"), Grant
end
IB1::GRANTS.each do |label, legacy_label, comment|
  uri = Ns.ib1(label).as(Grant::URI)
  Grant.const_set(label.sub(/\AGrant/,'').to_sym, uri)
end

class Obligation < Resource # Doesn't need to be in a Scheme or TrustFramework
  rdf_class IB1::Obligation.uri
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :trust_framework, Ns.ib1("trustFramework"), TrustFramework
  property :scheme, Ns.ib1("scheme"), Scheme
  property :is_replaced_by, Ns.dcterms("isReplacedBy"), Obligation
end
IB1::OBLIGATIONS.each do |label, legacy_label, comment|
  uri = Ns.ib1(label).as(Obligation::URI)
  Obligation.const_set(label.sub(/\AObligation/,'').to_sym, uri)
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

class AssuranceLevel < Resource # Doesn't need to be in a Scheme or TrustFramework
  rdf_class IB1::AssuranceLevel.uri
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :trust_framework, Ns.ib1("trustFramework"), TrustFramework
  property :scheme, Ns.ib1("scheme"), Scheme
end
IB1::ASSURANCE_LEVELS.each do |label, comment|
  uri = Ns.ib1(label).as(AssuranceLevel::URI)
  AssuranceLevel.const_set(label.sub(/\AAssurance/,'').to_sym, uri)
end

# ---------------------------------------------------------------------------

class SensitivityClass < Resource # Doesn't need to be in a Scheme or TrustFramework
  rdf_class IB1::SensitivityClass.uri
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :trust_framework, Ns.ib1("trustFramework"), TrustFramework
  property :scheme, Ns.ib1("scheme"), Scheme
end
IB1::SENSITIVITY_CLASSES.each do |label, comment|
  uri = Ns.ib1(label).as(SensitivityClass::URI)
  SensitivityClass.const_set(label.sub(/\ASensitivityClass/,'').to_sym, uri)
end

# ---------------------------------------------------------------------------

class SchemeResourceWithVisibleProperties < SchemeResource
  def self.inherited(subclass)
    subclass.const_set(:PropertyURI, Class.new(RdfUri))
  end
  def self.property(symbol, uri, *classes)
    self.const_set(symbol.to_s.upcase.to_sym, uri.as(self.const_get(:PropertyURI, false)))
    super
  end
end

class RequiredMetadata < SchemeResourceWithVisibleProperties
  rdf_class IB1::RequiredMetadata.uri
  property :endpoint_description, Ns.dcat("endpointDescription"), OpenAPIFile
  property :heartbeat_description, Ns.dcat("heartbeatDescription"), OpenAPIFile
  property :permit_group, Ns.ib1("permitGroup"), MemberGroup
  property :licence, Ns.dcterms("licence"), LicenceInterpretation
  property :sensitivity_class, Ns.ib1("sensitivityClass"), SensitivityClass
  property :dataset_assurance, Ns.ib1("datasetAssurance"), AssuranceLevel
end

class SchemeCatalogRequirements < SchemeResource
  rdf_class IB1::SchemeCatalogRequirements.uri
  type_name_for_url :standard
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :required_type, Ns.ib1("requiredType"), RdfClass
  bnode :required_metadata, Ns.ib1("requiredMetadata"), RequiredMetadata
  property :require_all_and_allow_additional, Ns.ib1("requireAllAndAllowAdditional"), RequiredMetadata::PropertyURI
  property :require_any_one_of, Ns.ib1("requireAnyOneOf"), RequiredMetadata::PropertyURI
  property :require_any_value, Ns.ib1("requireAnyValue"), RequiredMetadata::PropertyURI
  property :require_absence_of, Ns.ib1("requireAbsenceOf"), RequiredMetadata::PropertyURI
end
