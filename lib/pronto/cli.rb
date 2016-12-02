require 'thor'

module Pronto
  class CLI < Thor
    require 'pronto'
    require 'pronto/version'

    class << self
      def is_thor_reserved_word?(word, type)
        return false if word == 'run'
        super
      end
    end

    desc 'run', 'Run Pronto'

    method_option :'exit-code',
                  type: :boolean,
                  desc: 'Exits with non-zero code if there were any warnings/errors.'

    method_option :commit,
                  type: :string,
                  default: 'master',
                  aliases: '-c',
                  desc: 'Commit for the diff'

    method_option :index,
                  type: :boolean,
                  aliases: '-i',
                  desc: 'Analyze changes in git index (staging area)'

    method_option :runner,
                  type: :array,
                  default: [],
                  aliases: '-r',
                  desc: 'Run only the passed runners'

    method_option :formatters,
                  type: :array,
                  default: ['text'],
                  aliases: ['formatter', '-f'],
                  desc: "Pick output formatters. Available: #{::Pronto::Formatter.names.join(', ')}"

    def run(path = nil)
      gem_names = options[:runner].any? ? options[:runner] : ::Pronto::GemNames.new.to_a
      gem_names.each do |gem_name|
        require "pronto/#{gem_name}"
      end

      formatters = ::Pronto::Formatter.get(options[:formatters])
      commit = options[:index] ? :index : options[:commit]
      repo_workdir = ::Rugged::Repository.discover('.').workdir
      messages = Dir.chdir(repo_workdir) do
        ::Pronto.run(commit, '.', formatters, path)
      end
      if options[:'exit-code']
        error_messages_count = messages.count { |m| m.level != :info }
        exit(error_messages_count)
      end
    rescue Rugged::RepositoryError
      puts '"pronto" should be run from a git repository'
    end

    desc 'list', 'Lists pronto runners that are available to be used'

    def list
      puts ::Pronto::GemNames.new.to_a
    end

    desc 'version', 'Display version'
    map %w(-v --version) => :version

    def version
      puts Version::STRING
    end

    desc 'verbose-version', 'Display verbose version'
    map %w(-V --verbose-version) => :verbose_version

    def verbose_version
      puts Version.verbose
    end
  end
end
