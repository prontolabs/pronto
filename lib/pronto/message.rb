module Pronto
  class Message
    attr_reader :line, :level, :msg

    LEVELS = [:info, :warning, :error, :fatal]

    def initialize(line, level, msg)
      unless LEVELS.include?(level)
        raise ::ArgumentError, "level should be set to one of #{LEVELS}"
      end

      @line, @level, @msg = line, level, msg
    end
  end
end
