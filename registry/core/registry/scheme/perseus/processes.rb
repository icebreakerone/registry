
ProcessDescription.new do |p|
  p.label "electricity-emissions-calculation"
  p.comment "The Perseus electricity consumption emissions calculation"
  p.process_description "The sum of the products of the half-hourly consumption and the corresponding grid intensity at the meter postcode."
end

ProcessDescription.new do |p|
  p.label "gas-emissions-calculation"
  p.comment "The Perseus gas consumption emissions calculation"
  p.process_description "The sum of the products of the half-hourly consumption in cubic meters and the most recent published greenhouse gas conversion factor for natural gas covering the time of consumption."
end
