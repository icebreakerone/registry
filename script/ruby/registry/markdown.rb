require 'java'

class MarkdownRenderer
  Parser = com.vladsch.flexmark.parser.Parser
  HtmlRenderer = com.vladsch.flexmark.html.HtmlRenderer
  MutableDataSet = com.vladsch.flexmark.util.data.MutableDataSet
  DefinitionExtension = com.vladsch.flexmark.ext.definition.DefinitionExtension
  TablesExtension = com.vladsch.flexmark.ext.tables.TablesExtension

  def initialize
    options = MutableDataSet.new

    # Enable the Definition List and Tables extensions
    options.set(Parser::EXTENSIONS, java.util.Arrays.as_list(
      DefinitionExtension.create,
      TablesExtension.create
    ))

    @parser = Parser.builder(options).build
    @renderer = HtmlRenderer.builder(options).build
  end

  def render(markdown_text)
    document = @parser.parse(markdown_text)
    @renderer.render(document)
  end
end
