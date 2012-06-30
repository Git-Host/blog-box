require "yaml"
require "forwardable"

class Settings
  extend Forwardable
  def_delegators :@settings, :[]
  
  def initialize(settings_path = nil)
    @settings_path = settings_path || File.join(ENV["HOME"], ".blog-box")
    
    if File.exists?(@settings_path)
      @settings = File.size?(@settings_path) ? YAML.load(File.read(settings_path)) : {}
    else
      File.open(@settings_path, "w").close
      @settings = {}
    end
  end
  
  def []=(key, value)
    @settings[key] = value
    
    File.open(@settings_path, "w") do |settings_file|
      settings_file << @settings.to_yaml
    end
  end
end
