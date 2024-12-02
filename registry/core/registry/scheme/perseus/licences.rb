
Licence.new do |l|
  l.label "energy-consumption-data"
  l.comment "Energy Consumption Data Licence"
  l.licence_terms LicenceTermsFile.name("data-licence", INITIAL_REGISTRY_VERSION)
  l.licence_duration "2 months"
  l.permitted_use "Estimate a Resource Consumer's greenhouse gas emissions"
  l.permitted_use "Prepare estimates of projected greenhouse gas emissions by a Resource Consumer  following any proposed intervention(s) that could be financed: for each intervention a one-off estimate prior to the intervention, delivered once"
  l.permitted_use "Prepare annual updates to corroborate projected emissions savings using derived greenhouse gas  emissions at monthly resolution"
  l.permitted_use "Share emissions data with a financial institution of the Resource Consumer's choice, to facilitate that Resource Consumer's access to green finance products from that financial institution"
  l.permitted_use "Produce personalised recommendations of actions that the Resource Consumer  could take to decarbonise (either financed or non-financed)"
  l.permission_text LicencePermissionTextFile.name("energy-consumption-data", INITIAL_REGISTRY_VERSION)
end

Licence.new do |l|
  l.label "emissions-report"
  l.comment "Emissions Report Data Licence"
  l.licence_terms LicenceTermsFile.name("data-licence", INITIAL_REGISTRY_VERSION)
  l.licence_duration "2 months"
  l.permitted_use "In order to consider a Resource Consumer's eligibility for green finance products"
  l.permitted_use "If a Resource Consumer is offered any green finance products as a consequence of the receipt of emissions data to them,  in order to manage the Resource Consumer's use of that product, including monitoring their compliance with any conditions imposed by it"
  l.additional_condition "If the recipient of this data uses the data as the basis for the issuing of a financial instrument, the licence duration shall be further limited to the duration of any compliance requirements related to that instrument"
  l.permission_text LicencePermissionTextFile.name("emissions-report", INITIAL_REGISTRY_VERSION)
end
