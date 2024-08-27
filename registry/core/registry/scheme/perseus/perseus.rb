
perseus = Scheme.new do |s|
  s.label 'perseus'
  s.comment "Perseus Scheme"
end

Context.within do |context|
  context.every_resource do |resource|
    resource.scheme perseus
  end
  context.files "#{File.dirname(__FILE__)}/files", "scheme/perseus"

  require "#{File.dirname(__FILE__)}/groups.rb"
  require "#{File.dirname(__FILE__)}/licence-interpretations.rb"
  require "#{File.dirname(__FILE__)}/scheme-catalog-requirements.rb"

end
