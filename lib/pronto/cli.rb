require 'thor'

module Pronto
  class CLI < Thor
    require 'pronto'
    require 'pronto/version'

    desc 'exec', 'Run Pronto'

    def exec
      ::Pronto.run
    end

    desc 'list', 'Lists pronto runners that are available to be used'

    def list
      puts ::Pronto.gem_names
    end

    desc 'version', 'Show the Pronto version'
    map %w(-v --version) => :version

    def version
      puts "Pronto version #{::Pronto::VERSION}"
    end
  end
end
