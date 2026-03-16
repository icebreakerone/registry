License.new do |l|
  l.label "energy-consumption-edp-cap"
  l.comment "Energy Consumption Data License"
  l.license_terms LicenseTermsFile.name("data-license", INITIAL_REGISTRY_VERSION)
  l.license_duration "1 year"
  l.permitted_use "Estimate a Resource Consumer's greenhouse gas emissions"
  l.permitted_use "Prepare estimates of projected greenhouse gas emissions by a Resource Consumer  following any proposed intervention(s) that could be financed: for each intervention a one-off estimate prior to the intervention, delivered once"
  l.permitted_use "Prepare annual updates to corroborate projected emissions savings using derived greenhouse gas  emissions at monthly resolution"
  l.permitted_use "Share emissions data with a financial institution of the Resource Consumer's choice, to facilitate that Resource Consumer's access to green finance products from that financial institution"
  l.permitted_use "Produce personalised recommendations of actions that the Resource Consumer  could take to decarbonise (either financed or non-financed)"
  l.permission_text LicensePermissionTextFile.name("energy-consumption-edp-cap", INITIAL_REGISTRY_VERSION)
end

License.new do |l|
  l.label "emissions-cap-fsp"
  l.comment "Emissions Report Data License"
  l.license_terms LicenseTermsFile.name("data-license", INITIAL_REGISTRY_VERSION)
  l.license_duration "1 year"
  l.permitted_use "In order to consider a Resource Consumer's eligibility for green finance products"
  l.permitted_use "If a Resource Consumer is offered any green finance products as a consequence of the receipt of emissions data to them,  in order to manage the Resource Consumer's use of that product, including monitoring their compliance with any conditions imposed by it"
  l.additional_condition "If the recipient of emissions data uses the data as the basis for the issuing of a financial instrument, the license duration shall be further limited to the duration of any compliance requirements related to that instrument"
  l.permission_text LicensePermissionTextFile.name("emissions-cap-fsp", INITIAL_REGISTRY_VERSION)
end

License.new do |l|
  l.label "energy-consumption-emissions-edp-cap-fsp"
  l.comment "Energy Consumption and Emissions Report Data License"
  l.license_terms LicenseTermsFile.name("data-license", INITIAL_REGISTRY_VERSION)
  l.license_duration "1 year"
  l.permitted_use "Estimate a Resource Consumer's greenhouse gas emissions"
  l.permitted_use "Prepare estimates of projected greenhouse gas emissions by a Resource Consumer  following any proposed intervention(s) that could be financed: for each intervention a one-off estimate prior to the intervention, delivered once"
  l.permitted_use "Prepare annual updates to corroborate projected emissions savings using derived greenhouse gas  emissions at monthly resolution"
  l.permitted_use "Share emissions data with a financial institution of the Resource Consumer's choice, to facilitate that Resource Consumer's access to green finance products from that financial institution"
  l.permitted_use "Produce personalised recommendations of actions that the Resource Consumer  could take to decarbonise (either financed or non-financed)"
  l.permitted_use "In order for the financial institution to consider a Resource Consumer's eligibility for green finance products"
  l.permitted_use "If a Resource Consumer is offered any green finance products as a consequence of the receipt of emissions data to them, in order to manage the Resource Consumer's use of that product, including monitoring their compliance with any conditions imposed by it"
  l.additional_condition "If the recipient of emissions data uses the data as the basis for the issuing of a financial instrument, the license duration shall be further limited to the duration of any compliance requirements related to that instrument"
  l.permission_text LicensePermissionTextFile.name("energy-consumption-emissions-edp-cap-fsp", INITIAL_REGISTRY_VERSION)
end

