module Rugged
  class Diff
    class Line
      def patch
        hunk.owner
      end

      def position
        hunk.lines.find_index do |line|
          content == line.content &&
            line_origin == line.line_origin &&
            old_lineno == line.old_lineno &&
            new_lineno == line.new_lineno
        end
      end
    end
  end
end
