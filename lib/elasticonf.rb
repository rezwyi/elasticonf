require 'hashie'
require 'yaml'

require 'elasticonf/version'
require 'elasticonf/config'
require 'elasticonf/loader'

module ElastiConf
  extend Config

  module_function

  def root
    @root ||= Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
  end

  def load!(env = nil)
  	const_name = ElastiConf.const_name
  	config_file = ElastiConf.config_root.join(ElastiConf.config_file + '.yml')
    
    env_config_file = env ?
      ElastiConf.config_root.join(ElastiConf.config_file, "#{env}.yml") :
      nil
    
    raise("Config file #{config_file} not found. Cannot continue") unless File.exists?(config_file)
    
    config = Loader[YAML.load_file(config_file)]
    if env_config_file && File.exists?(env_config_file)
      config = config.deep_merge(Loader[YAML.load_file(env_config_file)])
    end
    
    Kernel.send(:remove_const, const_name) if Kernel.const_defined?(const_name)
    Kernel.const_set const_name, config
  end
end