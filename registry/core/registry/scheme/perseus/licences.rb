
Licence.new do |l|
  l.label "energy-consumption-data"
  l.version "1.0"
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
