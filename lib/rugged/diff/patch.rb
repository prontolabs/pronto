module Rugged
  class Diff
    class Patch
      def added_lines
        lines.select(&:addition?)
      end

      def deleted_lines
        lines.select(&:deletion?)
      end

      private

      def lines
        map(&:lines).flatten.compact
      end
    end
  end
end
