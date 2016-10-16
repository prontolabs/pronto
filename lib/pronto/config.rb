module Pronto
  class Config
    def initialize(config_hash = ConfigFile.new.to_h)
      @config_hash = config_hash
    end

    %w(github gitlab bitbucket).each do |service|
      ConfigFile::EMPTY[service].each do |key, _|
        name = "#{service}_#{key}"
        define_method(name) { ENV["PRONTO_#{name.upcase}"] || @config_hash[service][key] }
      end
    end

    def consolidate_comments?
      consolidated = ENV['PRONTO_CONSOLIDATE_COMMENTS'] || @config_hash['consolidate_comments']
      !(consolidated).nil?
    end

    def excluded_files
      @excluded_files ||= Array(exclude)
        .flat_map { |path| Dir[path.to_s] }
        .map { |path| File.expand_path(path) }
    end

    def github_hostname
      URI.parse(github_web_endpoint).host
    end

    def bitbucket_hostname
      URI.parse(bitbucket_web_endpoint).host
    end

    def max_warnings
      ENV['PRONTO_MAX_WARNINGS'] || @config_hash['max_warnings']
    end

    def logger
      @logger ||= begin
        verbose = ENV['PRONTO_VERBOSE'] || @config_hash['verbose']
        verbose ? Logger.new($stdout) : Logger.silent
      end
    end

    private

    def exclude
      ENV['PRONTO_EXCLUDE'] || @config_hash['all']['exclude']
    end
  end
end
