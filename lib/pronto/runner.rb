module Pronto
  class Runner
    include Plugin

    def self.runners
      repository
    end

    def ruby_file?(path)
      rb_file?(path) || rake_file?(path) || ruby_executable?(path)
    end

    private

    def rb_file?(path)
      File.extname(path) == '.rb'
    end

    def rake_file?(path)
      File.extname(path) == '.rake'
    end

    def ruby_executable?(path)
      line = File.open(path, &:readline)
      line =~ /#!.*ruby/
    rescue ArgumentError, EOFError
      false
    end
  end
end
