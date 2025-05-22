
module AssuredOpenData
  module PolicyPurpose
    AllowedLicenses = Ns.ib1root("assured-open-data/policy-purpose/AllowedLicenses")
  end
end

class Policy
  property :allowed_license, Ns.ib1("allowedLicense"), RdfUri
end
