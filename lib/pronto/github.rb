module Pronto
  class Github
    def initialize(repo)
      @repo = repo
      @config = Config.new
      @comment_cache = {}
      @pull_id_cache = {}
    end

    def pull_comments(sha)
      @comment_cache["#{pull_id}/#{sha}"] ||= begin
        client.pull_comments(slug, pull_id).map do |comment|
          Comment.new(sha, comment.body, comment.path,
                      comment.position || comment.original_position)
        end
      end
    end

    def commit_comments(sha)
      @comment_cache["#{sha}"] ||= begin
        client.commit_comments(slug, sha).map do |comment|
          Comment.new(sha, comment.body, comment.path, comment.position)
        end
      end
    end

    def create_commit_comment(comment)
      client.create_commit_comment(slug, comment.sha, comment.body,
                                   comment.path, nil, comment.position)
    end

    def create_pull_comment(comment)
      client.create_pull_comment(slug, pull_id, comment.body,
                                 pull_sha || comment.sha,
                                 comment.path, comment.position)
    end

    private

    def slug
      return @config.github_slug if @config.github_slug
      @slug ||= begin
        @repo.remote_urls.map do |url|
          hostname = Regexp.escape(@config.github_hostname)
          match = /.*#{hostname}(:|\/)(?<slug>.*?)(?:\.git)?\z/.match(url)
          match[:slug] if match
        end.compact.first
      end
    end

    def client
      @client ||= Octokit::Client.new(api_endpoint: @config.github_api_endpoint,
                                      web_endpoint: @config.github_web_endpoint,
                                      access_token: @config.github_access_token,
                                      auto_paginate: true)
    end

    def pull_id
      pull ? pull[:number].to_i : env_pull_id.to_i
    end

    def env_pull_id
      ENV['PULL_REQUEST_ID']
    end

    def pull_sha
      pull[:head][:sha] if pull
    end

    def pull
      return unless @repo.branch
      @pull ||= if env_pull_id
                  pull_requests.find { |pr| pr[:number].to_i == env_pull_id.to_i }
                else
                  pull_requests.find { |pr| pr[:head][:ref] == @repo.branch }
                end
    end

    def pull_requests
      @pull_requests ||= client.pull_requests(slug)
    end

    Comment = Struct.new(:sha, :body, :path, :position) do
      def ==(other)
        position == other.position &&
          path == other.path &&
          body == other.body
      end
    end
  end
end
