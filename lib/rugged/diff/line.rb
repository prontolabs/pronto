module Rugged
  class Diff
    class Line
      def patch
        hunk.owner
      end

      def position
        patch.lines.find_index(self)
      end

      def ==(other)
        content == other.content &&
          line_origin == other.line_origin &&
          old_lineno == other.old_lineno &&
          new_lineno == other.new_lineno
      end
    end
  end
end
