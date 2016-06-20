module Pronto
  module Formatter
    class GithubStatusFormatter
      class Inflector
        def self.underscore(camel_cased_word)
          return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
          word = camel_cased_word.to_s.gsub(/::/, '/')
          word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
          word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
          word.tr!('-', '_')
          word.downcase!
          word
        end
      end
    end
  end
end
