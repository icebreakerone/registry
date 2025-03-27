
estf = TrustFramework.new do |tf|
  tf.label "estf"
  tf.comment "Energy Sector Trust Framework"
end

Context.within do |context|
  context.every_resource do |resource|
    resource.trust_framework estf
  end
  context.files("#{File.dirname(__FILE__)}/files", "")

  IncludeIn.environment('sandbow', 'Assured Open Data') do
    require "#{File.dirname(__FILE__)}/scheme/assured-open-data/assured-open-data.rb"
  end
end
