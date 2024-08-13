# frozen_string_literal: true

class RegistryFiles
  @@all_files = []
  def initialize(source, destination)
    @source = File.expand_path(source)
    @destination = destination
    raise "#{source} doesn't exist" unless File.directory?(@source)
    validate_all_files()
    @@all_files << self
  end

  def self.openapi(api_name, version)
    raise "Bad API name" unless api_name =~ /\A[a-z0-9-]+\z/
    raise "Bad version" unless version =~ /\A([0-9]+\.)*[0-9]+\z/
    Context._current_files.file("api/#{api_name}/#{version}.json")
  end

  def file(name)
    # Check file exists - if it does, it will have been validated when the files were declared
    raise "File #{name} does not exist" unless File.exist?("#{@source}/#{name}")
    Ns.registry("#{@destination}/#{name}")
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
      if filename =~ /\Aapi\/([a-z0-9-]+)\/(([0-9]+\.)*[0-9]+)\.json\z/
        validate_openapi(contents, $1, $2)
      else
        raise "Filename doesn't match known pattern for validation: #{filename}"
      end
    end
  end

  def validate_openapi(contents, api_name, api_version)
    e = "OpenAPI validation of #{@source}/api/#{api_name}/#{api_version}.json:"
    openapi = begin
      JSON.parse(contents)
    rescue
      raise "#{e} invalid JSON"
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

end
