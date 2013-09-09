require 'json'

module Pronto
  module Formatter
    class JsonFormatter
      def format(messages)
        messages.map do |message|
          {
            path: message.path,
            line: message.line.new_lineno,
            level: message.level[0].upcase,
            message: message.msg
          }
        end.to_json
      end
    end
  end
end
