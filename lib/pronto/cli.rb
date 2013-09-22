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

    method_option :formatter,
                  type: :string,
                  default: nil,
                  aliases: '-f',
                  banner: "Formatter, defaults to text. Available: #{::Pronto::Formatter.names.join(', ')}"

    def exec
      gem_names = options[:runner].any? ? options[:runner]
                                        : ::Pronto.gem_names
      gem_names.each do |gem_name|
        require "pronto/#{gem_name}"
      end

      formatter = if options[:formatter] == 'json'
                    ::Pronto::Formatter::JsonFormatter.new
                  else
                    ::Pronto::Formatter::TextFormatter.new
                  end

      puts ::Pronto.run(options[:commit], '.', formatter)
    rescue Rugged::RepositoryError
      puts '"pronto" should be run from a git repository'
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
