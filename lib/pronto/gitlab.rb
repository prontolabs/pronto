module Pronto
  class Gitlab
    def initialize(repo)
      @repo = repo
      @config = Config.new
      @comment_cache = {}
    end

    def commit_comments(sha)
      @comment_cache[sha.to_s] ||= begin
        client.commit_comments(slug, sha, per_page: 500).map do |comment|
          Comment.new(sha, comment.body, comment.path, comment.position)
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
        slug = @repo.remote_urls.map do |url|
          match = if url =~ %r{^ssh:\/\/}
                    %r{.*#{host}(:[0-9]+)?(:|\/)(?<slug>.*).git}.match(url)
                  else
                    %r{.*#{host}(:|\/)(?<slug>.*).git}.match(url)
                  end
          match[:slug] if match
        end.compact.first
        URI.escape(slug, '/') if slug
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

    Comment = Struct.new(:sha, :body, :path, :position) do
      def ==(other)
        position == other.position &&
          path == other.path &&
          body == other.body
      end
    end
  end
end
