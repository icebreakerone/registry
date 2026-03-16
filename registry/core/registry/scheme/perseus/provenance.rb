
SourceType.new do |t|
  t.label "Meter"
  t.comment "Data source is a meter"
end

SourceType.new do |t|
  t.label "VirtualMeter"
  t.comment "Data source is a virtual meter where zero or more energy meters and other data sources have been processed to provide an estimate of consumption"
end

SourceType.new do |t|
  t.label "GridCarbonIntensity"
  t.comment "Data source is grid carbon intensity data from NESO"
end

SourceType.new do |t|
  t.label "GasGreenhouseGasFactor"
  t.comment "Data source is greenhouse gas emissions factors from DEFRA"
end
