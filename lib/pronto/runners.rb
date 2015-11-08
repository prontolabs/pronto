module Pronto
  class Runners
    def initialize(runners = Runner.runners)
      @runners = runners
    end

    def run(patches)
      @runners.map { |runner| runner.new.run(patches, patches.commit) }
        .flatten.compact
    end
  end
end
