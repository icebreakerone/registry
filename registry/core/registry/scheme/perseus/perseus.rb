
perseus = Scheme.new do |s|
  s.label 'perseus'
  s.comment "Perseus Scheme"
end

Context.within do |context|
  context.every_resource do |resource|
    resource.scheme perseus
  end

  context.files "#{File.dirname(__FILE__)}/files", "scheme/perseus"

  require "#{File.dirname(__FILE__)}/roles.rb"
  require "#{File.dirname(__FILE__)}/licences.rb"
  require "#{File.dirname(__FILE__)}/scheme-catalog-requirements.rb"
  require "#{File.dirname(__FILE__)}/assurance.rb"

end
