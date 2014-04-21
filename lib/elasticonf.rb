require 'elasticonf/version'
require 'elasticonf/config'

module ElastiConf
  extend Config

  module_function

  def root
    @root ||= Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
  end
end