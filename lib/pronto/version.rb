module Pronto
  module Version
    STRING = '0.5.3'

    MSG = '%s (running on %s %s %s)'

    module_function

    def verbose
      format(MSG, STRING, RUBY_ENGINE, RUBY_VERSION, RUBY_PLATFORM)
    end
  end
end
