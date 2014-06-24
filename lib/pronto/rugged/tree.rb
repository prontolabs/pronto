module Rugged
  class Tree
    attr_reader :owner
    alias_method :repo, :owner
  end
end
