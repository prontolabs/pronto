module Pronto
  class Config
    def initialize(config_hash = ConfigFile.new.to_h)
      @config_hash = config_hash
    end

    %w(github gitlab).each do |service|
      ConfigFile::EMPTY[service].each do |key, _|
        name = "#{service}_#{key}"
        define_method(name) { ENV[name.upcase] || @config_hash[service][key] }
      end
    end

    def excluded_files
      @excluded_files ||= Array(exclude)
        .flat_map { |path| Dir[path.to_s] }
        .map { |path| File.expand_path(path) }
    end

    def github_hostname
      URI.parse(github_web_endpoint).host
    end

    def max_warnings
      @config_hash['max_warnings']
    end

    def logger
      @logger ||= begin
        @config_hash['verbose'] ? Logger.new($stdout) : Logger.silent
      end
    end

    private

    def exclude
      @config_hash['all']['exclude']
    end
  end
end
