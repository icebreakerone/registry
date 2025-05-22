
IB1::POLICY_PURPOSES.each do |label, comment|
  PolicyPurpose.new(Ns.ib1(label)) do |l|
    l.label label
    l.comment comment
  end
end
