# frozen_string_literal: true

require 'erb'

module Templates
  TEMPLATES = {}
  begin
    layout = File.read("web/template/layout.html.erb")
    Dir.glob("web/template/*.html.erb").sort.each do |filename|
      TEMPLATES[File.basename(filename)] = ERB.new(
        # Slightly hacky way of having a common layout for all templates
        layout.sub('*CONTENT_TEMPLATE*', File.read(filename))
      )
    end
  end

  class Helper
    def self.url_name_for_class(klass)
      klass = Object.const_get(klass) unless klass.is_a?(Class)
      klass.name.gsub(/::/, '-').gsub(/([A-Z]+)([A-Z][a-z])/,'\1-\2').gsub(/([a-z\d])([A-Z])/,'\1-\2').downcase
    end
  end
end
