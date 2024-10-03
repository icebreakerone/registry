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
end
