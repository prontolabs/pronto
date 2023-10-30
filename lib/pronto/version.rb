module Pronto
  module Version
    STRING = '0.11.2'.freeze

    MSG = '%s (running on %s %s %s)'.freeze

    module_function

    def verbose
      format(MSG, STRING, RUBY_ENGINE, RUBY_VERSION, RUBY_PLATFORM)
    end
  end
end
