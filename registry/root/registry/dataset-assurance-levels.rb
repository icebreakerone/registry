
IB1::GENERIC_ASSURANCE_LEVELS.each do |label, comment|
  DatasetAssuranceLevel.new() do |l|
    l.label label
    l.comment comment
  end
end
