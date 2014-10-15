module Pronto
  class Github
    def initialize(repo)
      @repo = repo
      @comment_cache = {}
      @pull_id_cache = {}
    end

    def pull_comments(sha)
      @comment_cache["#{pull_id}/#{sha}"] ||= begin
        client.pull_comments(slug, pull_id).map do |comment|
          Comment.new(sha, comment.body, comment.path, comment.position)
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
                                 comment.sha, comment.path, comment.position)
    end

    private

    def slug
      @slug ||= begin
        @repo.remote_urls.map do |url|
          match = /.*github.com(:|\/)(?<slug>.*).git/.match(url)
          match[:slug] if match
        end.compact.first
      end
    end

    def client
      @client ||= Octokit::Client.new(access_token: access_token)
    end

    def pull_requests
      @pull_requests ||= client.pull_requests(slug)
    end

    def pull_id
      @pull_id ||= begin
        pull_id = ENV['PULL_REQUEST_ID']
        if pull_id
          pull_id.to_i
        elsif @repo.branch
          pull = pull_requests.find { |pr| pr[:head][:ref] == @repo.branch }
          pull[:number].to_i if pull
        end
      end
    end

    def access_token
      ENV['GITHUB_ACCESS_TOKEN']
    end

    class Comment < Struct.new(:sha, :body, :path, :position)
      def ==(other)
        position == other.position &&
          path == other.path &&
          body == other.body
      end
    end
  end
end
