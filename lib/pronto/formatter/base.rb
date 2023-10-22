module Pronto
  module Formatter
    class Base
      def self.name
        Formatter::formatters.invert[self]
      end

      def config
        @config ||= Config.new
      end
    end
  end
end
