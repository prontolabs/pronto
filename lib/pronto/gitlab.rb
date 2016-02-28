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
          Comment.new(sha, comment.note, comment.path, comment.line)
        end
      end
    end

    def create_commit_comment(comment)
      @config.logger.log("Creating commit comment on #{comment.sha}")
      client.create_commit_comment(slug, comment.sha, comment.note,
                                   path: comment.path, line: comment.line,
                                   line_type: 'new')
    end

    private

    def slug
      return @config.gitlab_slug if @config.gitlab_slug
      @slug ||= begin
        slug = @repo.remote_urls.map do |url|
          match = if url =~ /^ssh:\/\//
                    /.*#{host}(:[0-9]+)?(:|\/)(?<slug>.*).git/.match(url)
                  else
                    /.*#{host}(:|\/)(?<slug>.*).git/.match(url)
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

    Comment = Struct.new(:sha, :note, :path, :line) do
      def ==(other)
        line == other.line &&
          path == other.path &&
          note == other.note
      end
    end
  end
end
