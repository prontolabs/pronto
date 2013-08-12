module Pronto
  module Formatter
    class TextFormatter
      def format(messages)
        messages.map do |message|
          level = message.level[0].upcase
          line = message.line
          "#{message.path}:#{line.new_lineno} #{level}: #{message.msg}"
        end
      end
    end
  end
end
