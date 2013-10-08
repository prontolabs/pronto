module Rugged
  class Commit
    def show
      # TODO: Rugged does not seem to support diffing against multiple parents
      return if parents.count != 1
      diff(parents.first, reverse: true)
    end
  end
end
