# frozen_string_literal: true

# TODO: Configurable prefix
Ns.namespace(:ib1, "https://registry.trust.ib1.org/ns/1.0#")

module IB1
  RegistryChange = RdfClass.new(Ns.ib1("RegistryChange"))
  TrustFramework = RdfClass.new(Ns.ib1("TrustFramework"))
  TrustFrameworkGroup = RdfClass.new(Ns.ib1("TrustFrameworkGroup"))
  Scheme = RdfClass.new(Ns.ib1("Scheme"))
  Role = RdfClass.new(Ns.ib1("Role"))
  SchemeCatalogRequirements = RdfClass.new(Ns.ib1("SchemeCatalogRequirements"))
  RequiredMetadata = RdfClass.new(Ns.ib1("RequiredMetadata"))
  Licence = RdfClass.new(Ns.ib1("Licence"))
  AssuranceLevel = RdfClass.new(Ns.ib1("AssuranceLevel"))
  SensitivityClass = RdfClass.new(Ns.ib1("SensitivityClass"))
  SourceType = RdfClass.new(Ns.ib1("SourceType"))
  Process = RdfClass.new(Ns.ib1("Process"))
  Policy = RdfClass.new(Ns.ib1("Policy"))

  ASSURANCE_LEVELS = (1..4).map do |level|
    ["AssuranceLevel#{level}", "Assurance level #{level}"]
  end
  SENSITIVITY_CLASSES = [
    ['IB1-C', 'Closed data - datasets which must not be shared.'],
    ['IB1-O', 'Open Data - full open access, under an open data licence. Free to use, by anyone, for any purpose.'],
    ['IB1-SA', 'Shared data - datasets which can/could be shared, but which require the user to agree to standard T&Cs to access. May include some openly licensed materials (e.g. CC BY-SA or GNU AGPLv3).'],
    ['IB1-SB', 'Shared data - datasets which can/could be shared, but currently require some bilateral contract negotiation. May include data currently shared on the basis of group-based access. May include aggregated, anonymised or pseudonymised data about individuals.'],
    ['IB1-SP', 'Datasets which include personal data, requiring appropriate consent to share, or other legal bases to data processing, as defined by the UK DPA 2018.']
  ]
end

class TrustFramework < RegistryResource; end
class Scheme < RegistryResource; end

# ---------------------------------------------------------------------------

class RegistryChange < RegistryResource
  rdf_class IB1::RegistryChange.uri

  def generate_uri_suffix
    # TODO: Don't assume it's within a scheme
    "scheme/" + first_scheme().first_label() + "/" + first_label()
  end

  property :label, Ns.rdfs("label"), String # version number used in for all resources in change
  property :comment, Ns.rdfs("comment"), String
  property :trust_framework, Ns.ib1("trustFramework"), TrustFramework # optional
  property :scheme, Ns.ib1("scheme"), Scheme # optional

  property :references, Ns.dcterms("references"), RdfUri
  property :registry_snapshot, Ns.ib1("registrySnapshot"), RdfUri
  property :registry_snapshot_signature, Ns.ib1("registrySnapshotSignature"), String
end

# Add properties to all RegistryResources
class RegistryResource
  property :registry_change, Ns.ib1("registryChange"), RegistryChange
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
  rdf_class IB1::Scheme.uri

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

# Versioned resource within a scheme 
class VersionedSchemeResource < SchemeResource
  def generate_uri_suffix
    super + "/" + self.first_version.to_s
  end
  property :version, Ns.ib1("version"), String
  property :available_from, Ns.ib1("availableFrom"), Date # TODO: DateTime?
  property :deprecated_after, Ns.ib1("deprecatedAfter"), Date # TODO: DateTime?
  property :prohibited_after, Ns.ib1("prohibitedAfter"), VersionedSchemeResource
  property :has_current_version, Ns.ib1("hasCurrentVersion"), VersionedSchemeResource
  property :previous_version, Ns.ib1("previousVersion"), VersionedSchemeResource
end

# ---------------------------------------------------------------------------

class Role < SchemeResource
  rdf_class IB1::Role.uri
  type_name_for_url :role
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
end

# ---------------------------------------------------------------------------

class SchemeEnum < SchemeResource
  def self.inherited(subclass)
    subclass.rdf_class RDFS::Class.uri
  end
  def init(uri)
    super
    self.sub_class_of RDFS::Resource
  end
  property :sub_class_of, Ns.rdfs("subClassOf"), RdfClass
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String

  def enum_descriptive_name(class_name)
    @class_name = class_name
  end

  def name(symbol, description)
    class_name = @class_name
    enum_class = self
    @klass ||= Class.new(SchemeResource) do |c|
      c.define_singleton_method(:class_human_readable_name) { class_name }
      c.rdf_class enum_class.uri
      c.type_name_for_url "#{enum_class.type_name_for_url}/#{enum_class.first_label}"
      property :label, Ns.rdfs("label"), String
      property :comment, Ns.rdfs("comment"), String
    end
    @klass.new do |n|
      n.label symbol
      n.comment description
    end
  end
end

# ---------------------------------------------------------------------------

class Licence < VersionedSchemeResource
  rdf_class IB1::Licence.uri
  type_name_for_url :licence
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :licence_terms, Ns.ib1("licenceTerms"), LicenceTermsFile
  property :licence_duration, Ns.ib1("licenceDuration"), String
  property :permitted_use, Ns.ib1("permittedUse"), String
  property :additional_condition, Ns.ib1("additionalCondition"), String
  property :permission_text, Ns.ib1("permissionText"), LicencePermissionTextFile
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

class AssuranceEnum < SchemeEnum
  type_name_for_url :assurance
end

# ---------------------------------------------------------------------------

class SourceType < SchemeResource
  rdf_class IB1::SourceType.uri
  type_name_for_url "source-type".to_sym
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
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
  SensitivityClass.const_set(label.sub(/\-/,'_').to_sym, uri)
end

# ---------------------------------------------------------------------------

class ProcessDescription < VersionedSchemeResource # Not Process because name clashes with Ruby builtin
  def self.class_human_readable_name
    "Process"
  end
  rdf_class IB1::Process.uri
  type_name_for_url "process"
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  # TODO: Registry description of Processes
end

# ---------------------------------------------------------------------------

class Policy < VersionedSchemeResource
  rdf_class IB1::Policy.uri
  type_name_for_url "policy"
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :policy_text, Ns.dcat("policyText"), PolicyFile
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
  property :role_required_to_access, Ns.ib1("roleRequiredToAccess"), Role
  property :licence, Ns.dcterms("licence"), Licence
  property :sensitivity_class, Ns.ib1("sensitivityClass"), SensitivityClass
  property :dataset_assurance, Ns.ib1("datasetAssurance"), AssuranceLevel
end

class SchemeCatalogRequirements < VersionedSchemeResource
  rdf_class IB1::SchemeCatalogRequirements.uri
  type_name_for_url :standard
  property :label, Ns.rdfs("label"), String
  property :comment, Ns.rdfs("comment"), String
  property :required_type, Ns.ib1("requiredType"), RdfClass
  property :role_required_to_publish, Ns.ib1("roleRequiredToPublish"), Role
  bnode :required_metadata, Ns.ib1("requiredMetadata"), RequiredMetadata
  property :require_all_and_allow_additional, Ns.ib1("requireAllAndAllowAdditional"), RequiredMetadata::PropertyURI
  property :require_any_one_of, Ns.ib1("requireAnyOneOf"), RequiredMetadata::PropertyURI
  property :require_any_value, Ns.ib1("requireAnyValue"), RequiredMetadata::PropertyURI
  property :require_absence_of, Ns.ib1("requireAbsenceOf"), RequiredMetadata::PropertyURI
end
