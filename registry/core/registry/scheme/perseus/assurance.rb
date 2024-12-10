
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
  e.enum_descriptive_name "PerseusAssuranceOriginMethod"
  e.label "origin-method"
  e.comment "Assurance signal that describes data processing for data which originates outside the Scheme"
  # ----
  e.name "SmartDCCOtherUser", "The values for consumption, tariff, export were passed through unchanged from those received from SmartDCC"
  e.name "Exact", "The values for consumption, tariff, export have been processed to provide accurate half-hourly readings"
  e.name "Derived", "The values for consumption, tariff, export were derived from another data source which may involve estimation"
end

AssuranceEnum.new do |e|
  e.enum_descriptive_name "PerseusAssuranceOriginMethodDerived"
  e.label "origin-method-derived"
  e.comment "Assurance signal that describes the method used to derive data"
  # ----
  e.name "AreaOccupied", "Proportional to the area occupied by this occupant within the area supplied by the meter"
  e.name "NumberOfOccupants", "Proportional to the number of people consuming the power"
  e.name "AdditionalMetering", "Measurement by a meter in addition to the supply meter"
  e.name "Other", "Another method"
end
