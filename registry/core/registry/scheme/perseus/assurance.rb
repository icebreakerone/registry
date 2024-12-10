
AssuranceEnum.new do |e|
  e.label "data-source"
  e.comment "Perseus assurance signal that describes how the data was collected or estimated, as an indicator of overall reliability and accuracy of patterns of usage."
  # ----
  e.name "SmartMeter", "Unchanged data from a single smart meter"
  e.name "VirtualMeter", "Data derived from partial or multiple meter readings"
end

AssuranceEnum.new do |e|
  e.label "missing-data"
  e.comment "Perseus assurance signal that indicates whether the dataset has any missing data."
  # ----
  e.name "Complete", "Data is available for every measurement period"
  e.name "Missing", "Some measurement periods do not have data"
  e.name "Substituted", "Some measurement periods use data that has been substituted for actual readings, for example, estimates based on usage patterns to interpolate between available data"
end

AssuranceEnum.new do |e|
  e.label "processing"
  e.comment "Perseus assurance signal that describes data processing and calculations."
  # ----
  e.name "SmartDCCOtherUser", "The values for consumption, tariff, export were passed through unchanged from those received from SmartDCC."
  e.name "VirtualMeter", "The values for consumption, tariff, export were derived from a shared meter reading."
end

AssuranceEnum.new do |e|
  e.label "processing-virtual-meter"
  e.comment "VirtualMeter additional assurance signal to describe the method used to allocate consumption to the virtual meter."
  # ----
  e.name "AreaOccupied", "Proportional to the area occupied by this occupant within the area supplied by the meter."
  e.name "NumberOfOccupants", "Proportional to the number of people using the area."
  e.name "AdditionalMetering", "Measurement by an meter in addition to the supply meter."
  e.name "Other", "Another method."
end
