require 'hashie'
require 'yaml'

require 'elasticonf/version'
require 'elasticonf/config'
require 'elasticonf/loader'

module Elasticonf
  module_function

  def root
    @root ||= Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
  end

  def config
    @config ||= Config.new
  end

  def configure
    yield config
  end

  def load!(env = nil)
  	config_file = config.config_root.join(config.config_file + '.yml')
    config.env = env if env

    unless File.exists?(config_file)
      raise "Config file #{config_file} not found. Cannot continue"
    end

    loader = Loader[YAML.load_file(config_file)]

    env_config_file = config.config_root.join(config.config_file, "#{config.env}.yml")
    if File.exists?(env_config_file)
      loader = loader.deep_merge(Loader[YAML.load_file(env_config_file)])
    end

    local_config_file = config.config_root.join(config.config_file + '.local.yml')
    if File.exists?(local_config_file)
      loader = loader.deep_merge(Loader[YAML.load_file(local_config_file)])
    end

    if Kernel.const_defined?(config.const_name)
      config.raise_if_already_initialized_constant ?
        raise("Cannot set constant #{config.const_name} because it is already initialized") :
        Kernel.send(:remove_const, config.const_name)
    end

    Kernel.const_set config.const_name, loader
  end

  def reload!
    if Kernel.const_defined?(config.const_name)
      Kernel.send :remove_const, config.const_name
    end
    load!
  end

  def configure_and_load!
    configure { |config| yield(config) }
    load!
  end
end
