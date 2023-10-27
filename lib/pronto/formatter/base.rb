module Pronto
  module Formatter
    class Base
      def self.name
        raise NoMethodError, 'Must be implemented in subclasses.'
      end

      def config
        @config ||= Config.new
      end
    end
  end
end
