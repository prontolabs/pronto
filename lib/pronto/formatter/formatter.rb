module Pronto
  module Formatter
    class << self
      def add(label, formatter_klass = nil)
        unless formatter_klass.method_defined?(:format)
          raise NoMethodError, "format method is not declared in the #{label} class."
        end

        base = Pronto::Formatter::Base
        raise "#{label.inspect} is not a #{base}" unless formatter_klass.ancestors.include?(base)

        raise ArgumentError, "formatter #{label.inspect} has already been added." if formatters.key?(label)

        formatters[label] = formatter_klass
      end

      def get(names)
        names ||= 'text'
        Array(names).map { |name| formatters[name.to_s] || TextFormatter }
          .uniq.map(&:new)
      end

      def names
        formatters.keys
      end

      def formatters
        @formatters ||= {}
      end
    end
  end
end
