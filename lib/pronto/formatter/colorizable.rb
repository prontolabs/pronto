module Pronto
  module Formatter
    module Colorizable
      def colorize(string, color)
        rainbow.wrap(string).color(color)
      end

      private

      def rainbow
        @rainbow ||= Rainbow.new.tap do |rainbow|
          rainbow.enabled = $stdout.tty?
        end
      end
    end
  end
end
