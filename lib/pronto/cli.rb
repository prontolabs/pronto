require 'thor'

module Pronto
  class CLI < Thor
    require 'pronto'
    require 'pronto/version'

    desc 'exec', 'Run Pronto'

    method_option :commit,
                  type: :string,
                  default: nil,
                  aliases: '-c',
                  banner: 'Commit for the diff, defaults to master'

    method_option :runner,
                  type: :array,
                  default: [],
                  aliases: '-r',
                  banner: 'Run only the passed runners'

    def exec
      gem_names = options[:runner].any? ? options[:runner]
                                        : ::Pronto.gem_names
      gem_names.each do |gem_name|
        require "pronto/#{gem_name}"
      end
      puts ::Pronto.run(options[:commit])
    rescue Rugged::RepositoryError
      puts '"pronto" should be run from a git repository'
    rescue => e
      puts e.message
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
