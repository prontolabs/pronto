module Pronto
  class Runner
    include Plugin

    def self.runners
      repository
    end

    def ruby_file?(path)
      File.extname(path) == '.rb' || ruby_executable?(path)
    end

    private

    def ruby_executable?(path)
      line = File.open(path) { |file| file.readline }
      line =~ /#!.*ruby/
    rescue ArgumentError, EOFError
      false
    end
  end
end
