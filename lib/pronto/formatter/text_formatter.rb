module Pronto
  module Formatter
    class TextFormatter
      def format(messages)
        messages.map do |message|
          level = message.level[0].upcase
          line = message.line
          lineno = line.new_lineno if line
          "#{message.path}:#{lineno} #{level}: #{message.msg}"
        end
      end
    end
  end
end
