# frozen_string_literal: true

require 'digest'


class OpenAPIFile < RdfUri
  def self.name(api_name, version)
    raise "Bad API name" unless api_name =~ /\A[a-z0-9-]+\z/
    raise "Bad version" unless version =~ /\A([0-9]+-)*[0-9]+\z/
    name = "api/#{api_name}@#{version}.json"
    RegistryFiles.find_in_context_stack(name, OpenAPIFile)
  end
end

class MarkdownFile < RdfUri
  @@allow_directory_names = {}
  def self.allowed_directory?(directory_name)
    @@allow_directory_names[directory_name]
  end
  def self.make_class(directory_name)
    @@allow_directory_names[directory_name] = true
    Class.new(MarkdownFile) do |c|
      c.define_singleton_method(:name) do |text_name, version|
        raise "Bad markdown filename" unless text_name =~ /\A[a-z0-9-]+\z/
        raise "Bad version" unless version =~ /\A([0-9]+-)*[0-9]+\z/
        name = "#{directory_name}/#{text_name}@#{version}.txt"
        RegistryFiles.find_in_context_stack(name, c)
      end
    end
  end
end

LicenseTermsFile = MarkdownFile.make_class("terms")
LicensePermissionTextFile = MarkdownFile.make_class("permission-text")
PolicyFile = MarkdownFile.make_class("policy")

class PdfFile < RdfUri
  def self.name(api_name, version)
    raise "Bad PDF name" unless api_name =~ /\A[A-Za-z0-9-]+\z/
    raise "Bad version" unless version =~ /\A([0-9]+-)*[0-9]+\z/
    name = "pdf/#{api_name}@#{version}.pdf"
    RegistryFiles.find_in_context_stack(name, PdfFile)
  end
end

# ---------------------------------------------------------------------------

class RegistryFiles
  @@all_files = []
  def initialize(source, destination)
    @source = File.expand_path(source)
    @destination = destination
    raise "#{source} doesn't exist" unless File.directory?(@source)
    validate_all_files()
    @@all_files << self
  end

  def self.find_in_context_stack(name, klass)
    Context._current_files.each do |rf|
      file = rf._maybe_file(name)
      return file.as(klass) if file
    end
    raise "File #{name} does not exist in any RegistryFiles available within the Context stack -- check name and version exists"
  end

  def _maybe_file(name)
    pathname = "#{@source}/#{name}"
    return nil unless File.exist?(pathname)
    suffix = "#{@destination}#{@destination.empty? ? '' : '/'}#{name}\#"
    suffix += Digest::SHA256.file(pathname).hexdigest
    Ns.registry(suffix)
  end

  # -------------------------------------------------------------------------

  def self._copy_to_output
    @@all_files.each { |files| files._copy_to_output }
  end
  def _copy_to_output
    dest = "#{OUTPUT_DIR}/#{@destination}"
    FileUtils.mkdir_p(dest)
    FileUtils.cp_r("#{@source}/.", dest)
  end

  def validate_all_files
    Dir.glob("**/*", base:@source) do |filename|
      pathname = "#{@source}/#{filename}"
      next if File.directory? pathname
      contents = File.read(pathname)
      unless filename =~ /\A([a-z0-9-]+)\/([A-Za-z0-9-]+)\@(([0-9]+-?)+)\.([a-z]+)\z/
        raise "Filename doesn't match known pattern for validation: #{filename}"
      end
      directory, name, version, extension = $1, $2, $3, $5
      if directory == "api" && extension == "json"
        validate_openapi(contents, name, version)
      elsif MarkdownFile.allowed_directory?(directory) && extension == "txt"
        validate_markdown(contents)
      elsif directory == "pdf" && extension == "pdf"
        validate_pdf(contents)
      else
        raise "Unknown file type for validation: #{filename}"
      end
    end
  end

  def validate_openapi(contents, api_name, api_version)
    e = "OpenAPI validation of #{@source}/api/#{api_name}@#{api_version}.json:"
    openapi = begin
      JSON.parse(contents)
    rescue => exception
      raise "#{e} invalid JSON: #{exception}"
    end
    raise "#{e} not OpenAPI file" unless openapi["openapi"]
    raise "#{e} no info section" unless openapi["info"]
    raise "#{e} info.version is not #{api_version} implied by filename" unless openapi["info"]["version"] == api_version
    raise "#{e} info.x-ib1-registry-label is not #{api_name} implied by filename" unless openapi["info"]["x-ib1-registry-label"] == api_name
    raise "#{e} servers section is not the required definition (see docs)" unless openapi["servers"] == MODEL_OPENAPI_SERVERS
  end

  MODEL_OPENAPI_SERVERS = [{
    "url" => "{endpointURL}",
    "variables" => {
      "endpointURL" => { "default" => "https://endpointurl-not-specified.ib1.org" }
    }
  }]
  
  def validate_markdown(contents)
    # No validation needed
  end

  def validate_pdf(contents)
    # TODO: Validation
  end

end
