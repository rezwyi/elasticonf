module ElastiConf
  module Config
    def configure
      yield self
    end

    def reset_config!
      %w(config_root const_name).each do |v|
        instance_variable_set "@#{v}", nil
      end
    end

    def config_root
      @config_root ||= raise(ArgumentError, 'You must first specify config root')
    end

    def config_root=(value)
      unless [String, Symbol, Pathname].include?(value.class)
        raise ArgumentError, "String or Pathname expected #{value.class} given"
      end
      @config_root = value.is_a?(String) ? Pathname.new(value.to_s) : value
    end

    def const_name
      @const_name ||= 'Settings'
    end

    def const_name=(value)
      unless [String, Symbol].include?(value.class)
        raise ArgumentError, "String or Symbol expected #{value.class} given"
      end
      @const_name = value.to_s
    end
  end
end