module Pronto
  module Formatter
    class TextFormatter
      include Colorizable

      LOCATION_COLOR = :cyan

      LEVEL_COLORS = {
        info: :yellow,
        warning: :magenta,
        error: :red,
        fatal: :red
      }.freeze

      def format(messages, _, _)
        messages.map do |message|
          "#{format_location(message)} #{format_level(message)}: #{message.msg}".strip
        end
      end

      private

      def format_location(message)
        line = message.line
        lineno = line.new_lineno if line
        path = message.path
        commit_sha = message.commit_sha

        if path || lineno
          path = colorize(path, LOCATION_COLOR) if path
          "#{path}:#{lineno}"
        elsif commit_sha
          colorize(commit_sha[0..6], LOCATION_COLOR)
        end
      end

      def format_level(message)
        level = message.level
        color = LEVEL_COLORS.fetch(level)

        colorize(level[0].upcase, color)
      end
    end
  end
end
