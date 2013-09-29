module Rugged
  class Diff
    class Line
      def patch
        hunk.owner
      end

      def position
        hunk_index = patch.hunks.find_index { |h| h.header == hunk.header }
        line_index = patch.lines.find_index(self)

        line_index + hunk_index + 1
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
