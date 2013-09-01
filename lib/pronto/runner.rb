module Pronto
  class Runner
    include Plugin

    def self.runners
      repository
    end
  end
end
