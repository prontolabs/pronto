module Pronto
  module Formatter
    class << self
      def register(formatter_klass)
        unless formatter_klass.method_defined?(:format)
          raise NoMethodError, "format method is not declared in the #{formatter_klass.name} class."
        end

        base = Pronto::Formatter::Base
        raise "#{formatter_klass.name} is not a #{base}" unless formatter_klass.ancestors.include?(base)

        @formatters ||= {}
        @formatters[formatter_klass.name] = formatter_klass
      end

      def get(names)
        names ||= 'text'
        Array(names).map { |name| @formatters[name.to_s] || TextFormatter }
          .uniq.map(&:new)
      end

      def names
        @formatters.keys
      end
    end
  end
end
