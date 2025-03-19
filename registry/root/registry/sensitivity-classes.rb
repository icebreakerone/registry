
IB1::GENERIC_SENSITIVITY_CLASSES.each do |label, comment|
  SensitivityClass.new(Ns.ib1(label)) do |c|
    c.label label
    c.comment "#{comment} (#{label})"
  end
end
