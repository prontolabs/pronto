module Rugged
  class Commit
    def show
      # TODO: Rugged does not seem to support diffing against multiple parents
      diff(reverse: true) unless parents.count != 1
    end
  end
end
