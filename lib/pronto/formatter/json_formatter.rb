require 'json'

module Pronto
  module Formatter
    class JsonFormatter < Base
      def format(messages, _repo, _patches)
        messages.map do |message|
          lineno = message.line.new_lineno if message.line

          result = { level: message.level[0].upcase, message: message.msg }
          result[:path] = message.path if message.path
          result[:line] = lineno if lineno
          result[:commit_sha] = message.commit_sha if message.commit_sha
          result[:runner] = message.runner if message.runner
          result
        end.to_json
      end
    end
  end
end
