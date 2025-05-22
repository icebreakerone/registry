
IB1::POLICY_PURPOSES.each do |label, comment|
  PolicyPurpose.new() do |l|
    l.label label
    l.comment comment
  end
end
