module Pronto
  class Gitlab < Client
    def commit_comments(sha)
      @comment_cache[sha.to_s] ||= begin
        client.commit_comments(slug, sha, per_page: 500).map do |comment|
          Comment.new(sha, comment.note, comment.path, comment.line)
        end
      end
    end

    def create_commit_comment(comment)
      @config.logger.log("Creating commit comment on #{comment.sha}")
      client.create_commit_comment(slug, comment.sha, comment.body,
                                   path: comment.path, line: comment.position,
                                   line_type: 'new')
    end

    private

    def slug
      return @config.gitlab_slug if @config.gitlab_slug
      @slug ||= begin
        @repo.remote_urls.map do |url|
          match = slug_regex(url).match(url)
          match[:slug] if match
        end.compact.first
      end
    end

    def slug_regex(url)
      if url =~ %r{^ssh:\/\/}
        %r{.*#{host}(:[0-9]+)?(:|\/)(?<slug>.*).git}
      else
        %r{.*#{host}(:|\/)(?<slug>.*).git}
      end
    end

    def host
      @host ||= URI.split(gitlab_api_endpoint)[2, 2].compact.join(':')
    end

    def client
      @client ||= ::Gitlab.client(endpoint: gitlab_api_endpoint,
                                  private_token: gitlab_api_private_token)
    end

    def gitlab_api_private_token
      @config.gitlab_api_private_token
    end

    def gitlab_api_endpoint
      @config.gitlab_api_endpoint
    end
  end
end
