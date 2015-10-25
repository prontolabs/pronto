module Pronto
  module Formatter
    class TextFormatter
      def format(messages, _, _)
        messages.map do |message|
          level = message.level[0].upcase
          "#{location(message)} #{level}: #{message.msg}"
        end
      end

      private

      def location(message)
        line = message.line
        lineno = line.new_lineno if line
        path = message.path
        commit_sha = message.commit_sha[0..6] if message.commit_sha

        (path.nil? && lineno.nil?) ? commit_sha : "#{path}:#{lineno}"
      end
    end
  end
end
