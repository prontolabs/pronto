# frozen_string_literal: true

module Pronto
  module Version
    STRING = '0.11.5'

    MSG = '%s (running on %s %s %s)'

    module_function

    def verbose
      format(MSG, STRING, RUBY_ENGINE, RUBY_VERSION, RUBY_PLATFORM)
    end
  end
end
