module Pronto
  class Config
    def initialize(config_hash = ConfigFile.new.to_h)
      @config_hash = config_hash
    end

    def excluded_files
      @excluded_files ||= exclude.flat_map { |path| Dir[path] }
    end

    def github_slug
      @config_file['github']['slug']
    end

    private

    def exclude
      @config_file['all']['exclude']
    end
  end
end
