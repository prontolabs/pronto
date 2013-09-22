module Pronto
  module Formatter
    def self.get(name)
      formatter = FORMATTERS[name.to_s] || TextFormatter
      formatter.new
    end

    def self.names
      FORMATTERS.keys
    end

    FORMATTERS = {
      'github' => GithubFormatter,
      'json' => JsonFormatter,
      'text' => TextFormatter
    }
  end
end
