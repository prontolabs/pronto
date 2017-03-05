module Pronto
  module Formatter
    class TextMessageDecorator < SimpleDelegator
      include Colorizable

      LOCATION_COLOR = :cyan

      LEVEL_COLORS = {
        info: :yellow,
        warning: :magenta,
        error: :red,
        fatal: :red
      }.freeze

      def to_h
        original = __getobj__.to_h
        original[:color_level] = format_level(__getobj__)
        original[:color_location] = format_location(__getobj__)
        original
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
