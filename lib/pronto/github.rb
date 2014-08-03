module Pronto
  class Github
    def commit_comments(repo, sha)
      client.commit_comments(repo, sha).map do |comment|
        Comment.new(repo, sha, comment.body, comment.path, comment.body)
      end
    end

    def create_commit_comment(repo, sha, comment)
      client.create_commit_comment(repo, sha, comment.body, comment.path,
                                   nil, comment.position)
    end

    private

    def client
      @client ||= Octokit::Client.new(access_token: access_token)
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
