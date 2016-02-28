module Pronto
  class Logger
    def self.silent
      null = File.open(File::NULL, 'w')
      new(null)
    end

    def initialize(out)
      @out = out
    end

    def log(*args)
      @out.puts(*args)
    end
  end
end
