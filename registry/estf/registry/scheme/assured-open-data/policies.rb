
Policy.new do |p|
  p.label "allowed-licenses"
  p.comment "Assured Open Data Allowed Licences Policy"
  p.policy_purpose AssuredOpenData::PolicyPurpose::AllowedLicenses
  p.allowed_license RdfUri.new("https://creativecommons.org/licenses/by/4.0/", nil)
  p.allowed_license RdfUri.new("https://opendatacommons.org/licenses/odbl/", nil)
  p.allowed_license RdfUri.new("https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/", nil)
end
