module Rugged
  class Diff
    class Line
      def patch
        hunk.owner
      end
    end
  end
end
