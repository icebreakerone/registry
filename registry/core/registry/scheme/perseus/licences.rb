
Licence.new do |l|
  l.label "energy-consumption-data"
  l.version "0.1"
  l.comment "Energy Consumption Data Licence"
  l.licence_terms RegistryFiles.licence_terms("data-licence", "0.1")
  l.licence_duration "2 months"
  l.permitted_use "Estimate a Resource Consumer's greenhouse gas emissions"
  l.permitted_use "Prepare estimates of projected greenhouse gas emissions by a Resource Consumer  following any proposed intervention(s) that could be financed: for each intervention a one-off estimate prior to the intervention, delivered once"
  l.permitted_use "Prepare annual updates to corroborate projected emissions savings using derived greenhouse gas  emissions at monthly resolution"
  l.permitted_use "Share emissions data with a financial institution of the Resource Consumer's choice, to facilitate that Resource Consumer's access to green finance products from that financial institution"
  l.permitted_use "Produce personalised recommendations of actions that the Resource Consumer  could take to decarbonise (either financed or non-financed)"
  l.permission_text <<__E
[Carbon accounting provider] ("we") need your consent to access the following data provided by [insert source of data]:

* Your electricity consumption (taken every 30 minutes) 
* Electricity tariff data

In order to compute the following ("emissions data"):

* An estimate of your current GHG emissions, sourced from the preceding 12 months of data where available
* An estimate of projected emissions following any proposed intervention(s) that could be financed: a one-off estimate prior to the intervention, delivered once.
* A periodic update to corroborate projected emissions savings: derived GHG emissions at monthly resolution, delivered annually

and then use the emissions data as follows:

* Share it with your chosen financial service provider(s) to facilitate your access to green finance products from that provider or providers.
* Produce personalised recommendations of actions that your business could take to decarbonise (either financed or non-financed)
__E
end

Licence.new do |l|
  l.label "emissions-report"
  l.version "0.1"
  l.comment "Emissions Report Data Licence"
  l.licence_terms RegistryFiles.licence_terms("data-licence", "0.1")
  l.licence_duration "2 months"
  l.permitted_use "In order to consider a Resource Consumer's eligibility for green finance products"
  l.permitted_use "If a Resource Consumer is offered any green finance products as a consequence of the receipt of emissions data to them,  in order to manage the Resource Consumer's use of that product, including monitoring their compliance with any conditions imposed by it"
  l.additional_condition "If the recipient of this data uses the data as the basis for the issuing of a financial instrument, the licence duration shall be further limited to the duration of any compliance requirements related to that instrument"
  l.permission_text <<__E
As a reminder, ([Carbon accounting provider]) (“we”) need to have your consent to access the following data provided by [insert source of data]:

Your electricity consumption (taken every 30 minutes) 
Electricity tariff data

In order to compute the following (“emissions data”):

An estimate of your current GHG emissions, sourced from the preceding 12 months of data where available
An estimate of projected emissions following any proposed intervention(s) that could be financed: a one-off estimate prior to the intervention, delivered once.
A periodic update to corroborate projected emissions savings: derived GHG emissions at monthly resolution, delivered annually

and then use the emissions data as follows:

Share it with your chosen financial service provider(s) to facilitate your access to green finance products from that provider or providers.
Produce personalised recommendations of actions that your business could take to decarbonise (either financed or non-financed)

Now, on behalf of [insert specific name of financial services provider], we seek your consent for them to process the emissions data:
In order to consider your eligibility for green finance products
If you are offered any green finance products as a consequence of our providing emissions data to them,  in order to allow them to manage your use of that product, including monitoring your compliance with any conditions imposed by it.
__E
end
