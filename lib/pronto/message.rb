module Pronto
  class Message
    attr_reader :path, :line, :level, :msg

    LEVELS = [:info, :warning, :error, :fatal]

    def initialize(path, line, level, msg)
      unless LEVELS.include?(level)
        raise ::ArgumentError, "level should be set to one of #{LEVELS}"
      end

      @path, @line, @level, @msg = path, line, level, msg
    end

    def repo
      line.patch.delta.repo
    end
  end
end
