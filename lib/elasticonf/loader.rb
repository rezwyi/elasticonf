module ElastiConf
  class Loader < Hashie::Mash
    def get(key)
      unless [String, Symbol].include?(key.class)
        raise ArgumentError, "String or Symbol expected #{key.class} given"
      end
      
      hash, items = self, key.split('.')
      
      while (item = items.shift)
        (hash = hash[item.to_sym]) || break
      end

      hash
    end
  end
end