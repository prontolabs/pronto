module Pronto
  class Config
    def initialize(config_hash = ConfigFile.new.to_h)
      @config_hash = config_hash
    end

    def excluded_files
      @excluded_files ||= exclude.flat_map { |path| Dir[path] }
    end

    def github_access_token
      ENV['GITHUB_ACCESS_TOKEN'] || @config_hash['github']['access_token']
    end

    def github_slug
      ENV['GITHUB_SLUG'] || @config_hash['github']['slug']
    end

    def github_web_endpoint
      ENV['GITHUB_WEB_ENDPOINT'] ||
        @config_hash['github']['web_endpoint'] ||
        'https://github.com/'
    end

    def github_api_endpoint
      ENV['GITHUB_API_ENDPOINT'] ||
        @config_hash['github']['api_endpoint'] ||
        'https://api.github.com/'
    end

    def github_hostname
      URI.parse(github_web_endpoint).host
    end

    def gitlab_private_token
      ENV['GITLAB_API_PRIVATE_TOKEN'] || @config_hash['gitlab']['private_token']
    end

    def gitlab_endpoint
      ENV['GITLAB_API_ENDPOINT'] || @config_hash['gitlab']['endpoint']
    end

    def gitlab_slug
      ENV['GITLAB_SLUG'] || @config_hash['gitlab']['slug']
    end

    private

    def exclude
      @config_hash['all']['exclude']
    end
  end
end
