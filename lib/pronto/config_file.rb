module Pronto
  class ConfigFile
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

      hash.merge(empty_config, &merger)
    end

    def empty_config
      {
        'all' => { 'exclude' => [], 'include' => [] },
        'github' => {
          'slug' => nil,
          'access_token' => nil,
          'api_endpoint' => nil,
          'web_endpoint' => nil
        },
        'gitlab' => {
          'slug' => nil,
          'private_token' => nil,
          'endpoint' => nil
        },
        'runners' => [],
        'formatters' => []
      }
    end
  end
end
