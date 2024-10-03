
core_trust_framework = TrustFramework.new do |tf|
  tf.label "core"
  tf.comment "Core Trust Framework"
end

Context.within do |context|
  context.every_resource do |resource|
    resource.trust_framework core_trust_framework
  end
  context.files("#{File.dirname(__FILE__)}/files", "")

  IncludeIn.environment('pilot', 'Persues Scheme') do
    require "#{File.dirname(__FILE__)}/scheme/perseus/perseus.rb"
  end
end
