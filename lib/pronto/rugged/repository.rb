require 'grit'

module Rugged
  class Repository
    def blame(filepath)
      # TODO: Using grit blame implementation for now.
      # Replace it with rugged implementation when it's available.
      ::Grit::Repo.new(path).blame(filepath)
    end
  end
end
