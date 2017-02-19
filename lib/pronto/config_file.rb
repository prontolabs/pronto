module Pronto
  class ConfigFile
    EMPTY = {
      'all' => {
        'exclude' => [],
        'include' => []
      },
      'github' => {
        'slug' => nil,
        'access_token' => nil,
        'api_endpoint' => 'https://api.github.com/',
        'web_endpoint' => 'https://github.com/'
      },
      'gitlab' => {
        'slug' => nil,
        'api_private_token' => nil,
        'api_endpoint' => 'https://gitlab.com/api/v3'
      },
      'bitbucket' => {
        'slug' => nil,
        'username' => nil,
        'password' => nil,
        'web_endpoint' => 'https://bitbucket.org/'
      },
      'runners' => [],
      'formatters' => [],
      'max_warnings' => nil,
      'verbose' => false
    }.freeze

    def initialize(path = '.pronto.yml')
      @path = path
    end

    def to_h
      hash = File.exist?(@path) ? YAML.load_file(@path) : {}
      deep_merge(hash)
    end

    private

    def deep_merge(hash)
      merger = proc do |_, oldval, newval|
        if oldval.is_a?(Hash) && newval.is_a?(Hash)
          oldval.merge(newval, &merger)
        else
          oldval || newval
        end
      end

      hash.merge(EMPTY, &merger)
    end
  end
end
