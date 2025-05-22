
IB1::SENSITIVITY_CLASS_REQUIREMENTS.each do |label, comment|
  SensitivityClassRequirement.new() do |c|
    c.label label
    c.comment comment
  end
end

IB1::GENERIC_SENSITIVITY_CLASSES.each do |label, comment, *requirements|
  SensitivityClass.new() do |c|
    c.label label
    c.comment "#{comment} (#{label})"
    requirements.each do |req|
      c.sensitivity_class_requirement SensitivityClassRequirement.const_get(req)
    end
  end
end
