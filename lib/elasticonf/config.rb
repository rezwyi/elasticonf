module ElastiConf
  class Config
    def reset_config!
      %w(
        config_root
        config_file
        const_name
        raise_if_already_initialized_constant
      ).each do |v|
        instance_variable_set "@#{v}", nil
      end
    end

    def config_root
      @config_root ||= raise(ArgumentError, 'You must specify config_root option first')
    end

    def config_root=(value)
      unless [String, Symbol, Pathname].include?(value.class)
        raise ArgumentError, "String or Symbol or Pathname expected #{value.class} given"
      end
      @config_root = value.is_a?(Pathname) ? value : Pathname.new(value.to_s)
    end

    def config_file
      @config_file ||= 'config'
    end

    def config_file=(value)
      unless [String, Symbol].include?(value.class)
        raise ArgumentError, "String or Symbol expected #{value.class} given"
      end
      @config_file = value.to_s
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

    def raise_if_already_initialized_constant
      @raise_if_already_initialized_constant.nil? ? true : @raise_if_already_initialized_constant
    end

    def raise_if_already_initialized_constant=(value)
      unless [TrueClass, FalseClass].include?(value.class)
        raise ArgumentError, "TrueClass or FalseClass expected #{value.class} given"
      end
      @raise_if_already_initialized_constant = value
    end
  end
end