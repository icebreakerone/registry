
IncludeIn.environment(['pilot'], 'Scheme Agreement: Perseus (pilot)') do
  Agreement.new do |p|
    p.label "perseus-scheme-agreement"
    p.comment "Scheme Agreement: Perseus (pilot)"
    p.agreement_text PdfFile.name("IB1-SA-PERSEUS-PILOT", '2024-12-16')
  end
end

IncludeIn.environment(['development', 'sandbox', 'production'], 'Scheme Agreement: Perseus') do
  Agreement.new do |p|
    p.label "perseus-scheme-agreement"
    p.comment "Scheme Agreement: Perseus"
    p.agreement_text PdfFile.name("IB1-SA-PERSEUS", '2026-03-12')
  end
end
