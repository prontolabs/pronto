module Pronto
  class Message < Struct.new(:line, :level, :msg)
    LEVELS = [:info, :warning, :error, :fatal]
  end
end
