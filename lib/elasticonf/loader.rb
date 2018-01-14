require 'semantic'

module Elasticonf
  class Loader < Hashie::Mash
    def get(key)
      unless [String, Symbol].include?(key.class)
        raise ArgumentError, "String or Symbol expected #{key.class} given"
      end

      ruby_version = Semantic::Version.new(RUBY_VERSION)

      if ruby_version.major == 2 && ruby_version.minor >= 3
        dig *key.split('.')
      else
        result, items = self.dup, key.split('.')

        while (item = items.shift)
          (result = result[item.to_sym]) || break
        end

        result
      end
    end
  end
end
