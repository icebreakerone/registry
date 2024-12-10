
AssuranceEnum.new do |e|
  e.enum_descriptive_name "PerseusAssuranceDataSource"
  e.label "data-source"
  e.comment "Assurance signal that describes how the data was collected or estimated"
  # ----
  e.name "SmartMeter", "Unchanged data from a single smart meter"
  e.name "VirtualMeter", "Data derived from partial or multiple meter readings"
end

AssuranceEnum.new do |e|
  e.enum_descriptive_name "PerseusAssuranceMissingData"
  e.label "missing-data"
  e.comment "Assurance signal that indicates whether the dataset has any missing data"
  # ----
  e.name "Complete", "Data is available for every measurement period"
  e.name "Missing", "Some measurement periods do not have data"
  e.name "Substituted", "Some measurement periods use data that has been substituted for actual readings, for example, estimates based on usage patterns to interpolate between available data"
end

AssuranceEnum.new do |e|
  e.enum_descriptive_name "PerseusAssuranceProcessing"
  e.label "processing"
  e.comment "Assurance signal that describes data processing and calculations"
  # ----
  e.name "SmartDCCOtherUser", "The values for consumption, tariff, export were passed through unchanged from those received from SmartDCC"
  e.name "VirtualMeter", "The values for consumption, tariff, export were derived from a shared meter reading"
end

AssuranceEnum.new do |e|
  e.enum_descriptive_name "PerseusAssuranceProcessingVirtualMeter"
  e.label "processing-virtual-meter"
  e.comment "Assurance signal that describes the method used to allocate consumption to a virtual meter"
  # ----
  e.name "AreaOccupied", "Proportional to the area occupied by this occupant within the area supplied by the meter"
  e.name "NumberOfOccupants", "Proportional to the number of people consuming the power"
  e.name "AdditionalMetering", "Measurement by a meter in addition to the supply meter"
  e.name "Other", "Another method"
end
