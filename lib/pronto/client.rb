module Pronto
  class Client
    def initialize(repo)
      @repo = repo
      @config = Config.new
      @comment_cache = {}
      @pull_id_cache = {}
    end

    def env_pull_id
      ENV['PULL_REQUEST_ID']
    end
  end
end
