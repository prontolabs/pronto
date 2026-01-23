# frozen_string_literal: true

module Pronto
  class Client
    def initialize(repo)
      @repo = repo
      @config = Config.new
      @comment_cache = {}
      @pull_id_cache = {}
    end

    def env_pull_id
      if (pull_request = ENV.fetch('PULL_REQUEST_ID', nil))
        warn '[DEPRECATION] `PULL_REQUEST_ID` is deprecated.  Please use `PRONTO_PULL_REQUEST_ID` instead.'
      end

      pull_request ||= ENV.fetch('PRONTO_PULL_REQUEST_ID', nil)
      pull_request&.to_i
    end
  end
end
