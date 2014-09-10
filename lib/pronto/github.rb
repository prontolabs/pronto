module Pronto
  class Github
    def initialize
      @comment_cache = {}
    end

    def pull_comments(repo, sha)
      @comment_cache["#{repo}/#{pull_id}/#{sha}"] ||= begin
        client.pull_comments(repo, pull_id).map do |comment|
          Comment.new(repo, sha, comment.body, comment.path, comment.position)
        end
      end
    end

    def commit_comments(repo, sha)
      @comment_cache["#{repo}/#{sha}"] ||= begin
        client.commit_comments(repo, sha).map do |comment|
          Comment.new(repo, sha, comment.body, comment.path, comment.position)
        end
      end
    end

    def create_commit_comment(repo, sha, comment)
      client.create_commit_comment(repo, sha, comment.body, comment.path,
                                   nil, comment.position)
    end

    def create_pull_comment(repo, sha, comment)
      client.create_pull_comment(repo, pull_id, comment.body, sha, comment.path,
                                 comment.position)
    end

    private

    def client
      @client ||= Octokit::Client.new(access_token: access_token)
    end

    def pull_id
      ENV['PULL_REQUEST_ID'].to_i
    end

    def access_token
      ENV['GITHUB_ACCESS_TOKEN']
    end

    class Comment < Struct.new(:repo, :sha, :body, :path, :position)
      def ==(other)
        position == other.position &&
          path == other.path &&
          body == other.body
      end
    end
  end
end
