module Rugged
  class Diff
    attr_reader :owner
    alias_method :tree, :owner
  end
end
