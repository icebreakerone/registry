
# TODO: Persues licences, uncomment inclusion in perseus.rb

LicenceInterpretation.new do |l|
  l.label "cc-by"
  l.version "4.0"
  l.comment "Creative Commons Attribution"
  l.licence_url RdfUri.new("https://creativecommons.org/licenses/by/4.0/", nil)
  l.grant Grant::UseAny
  l.grant Grant::AdaptAny
  l.grant Grant::CombineAny
  l.grant Grant::RedistributeCombined
  l.obligation Obligation::Attribution
end
