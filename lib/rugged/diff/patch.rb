module Rugged
  class Diff
    class Patch
      def added_lines
        lines.select(&:addition?)
      end

      def deleted_lines
        lines.select(&:deletion?)
      end

      def new_file_full_path
        delta.new_file_full_path
      end

      private

      def lines
        map(&:lines).flatten.compact
      end
    end
  end
end
