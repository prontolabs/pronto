require 'json'

module Pronto
  module Formatter
    class JsonFormatter
      def format(messages, _)
        messages.map do |message|
          lineno = message.line.new_lineno if message.line

          result = { level: message.level[0].upcase, message: message.msg }
          result[:path] = message.path if message.path
          result[:line] = lineno if lineno
          result[:commit_sha] = message.commit_sha if message.commit_sha
          result
        end.to_json
      end
    end
  end
end
