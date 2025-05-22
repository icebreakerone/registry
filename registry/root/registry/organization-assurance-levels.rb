
IB1::GENERIC_ORGANIZATION_ASSURANCE_LEVELS.each do |label, comment|
  OrganizationAssuranceLevel.new() do |l|
    l.label label
    l.comment comment
  end
end
