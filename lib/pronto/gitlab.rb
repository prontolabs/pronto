module Pronto
  class Gitlab
    def initialize(repo)
      @repo = repo
      @comment_cache = {}
    end

    def commit_comments(sha)
      @comment_cache["#{sha}"] ||= begin
        client.commit_comments(slug, sha).map do |comment|
          Comment.new(sha, comment.note, comment.path, comment.line)
        end
      end
    end

    def create_commit_comment(comment)
      client.create_commit_comment(slug, comment.sha, comment.note,
                                   path: comment.path, line: comment.line,
                                   line_type: 'new')
    end

    private

    def slug
      @slug ||= begin
        host = URI.split(endpoint)[2, 2].compact.join(':')
        slug = @repo.remote_urls.map do |url|
          match = /.*#{host}(:|\/)(?<slug>.*).git/.match(url)
          match[:slug] if match
        end.compact.first
        URI.escape(slug, '/') if slug
      end
    end

    def client
      @client ||= ::Gitlab.client(endpoint: endpoint, private_token: private_token)
    end

    def private_token
      ENV['GITLAB_API_PRIVATE_TOKEN']
    end

    def endpoint
      ENV['GITLAB_API_ENDPOINT']
    end

    class Comment < Struct.new(:sha, :note, :path, :line)
      def ==(other)
        line == other.line &&
          path == other.path &&
          note == other.note
      end
    end
  end
end
