module Pronto
  class Message
    attr_reader :path, :line, :level, :msg, :commit_sha, :runner

    LEVELS = [:info, :warning, :error, :fatal].freeze

    def initialize(path, line, level, msg, commit_sha = nil, runner = nil)
      unless LEVELS.include?(level)
        raise ::ArgumentError, "level should be set to one of #{LEVELS}"
      end

      @path = path
      @line = line
      @level = level
      @msg = msg
      @runner = runner
      @commit_sha = commit_sha
      @commit_sha ||= line.commit_sha if line
    end

    def full_path
      repo.path.join(path) if repo
    end

    def repo
      line.patch.repo if line
    end

    def ==(other)
      comparison_attributes.all? do |attribute|
        send(attribute) == other.send(attribute)
      end
    end

    alias_method :eql?, :==

    def hash
      comparison_attributes.reduce(0) do |hash, attribute|
        hash ^ send(attribute).hash
      end
    end

    private

    def comparison_attributes
      line ? [:path, :msg, :level, :line] : [:path, :msg, :level, :commit_sha]
    end
  end
end
