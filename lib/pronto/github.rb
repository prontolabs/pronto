module Pronto
  class Github
    def initialize
      @comment_cache = {}
      @pull_id_cache = {}
    end

    def pull_comments(repo, sha)
      pull_id = pull_id(repo)
      @comment_cache["#{repo.github_slug}/#{pull_id}/#{sha}"] ||= begin
        client.pull_comments(repo.github_slug, pull_id).map do |comment|
          Comment.new(repo, sha, comment.body, comment.path, comment.position)
        end
      end
    end

    def commit_comments(repo, sha)
      @comment_cache["#{repo.github_slug}/#{sha}"] ||= begin
        client.commit_comments(repo.github_slug, sha).map do |comment|
          Comment.new(repo, sha, comment.body, comment.path, comment.position)
        end
      end
    end

    def create_commit_comment(comment)
      client.create_commit_comment(comment.repo.github_slug, comment.sha,
                                   comment.body, comment.path, nil, comment.position)
    end

    def create_pull_comment(comment)
      pull_id = pull_id(comment.repo)
      client.create_pull_comment(comment.repo.github_slug, pull_id,
                                 comment.body, comment.sha, comment.path, comment.position)
    end

    private

    def client
      @client ||= Octokit::Client.new(access_token: access_token)
    end

    def pull_requests(repo)
      client.pull_requests(repo.github_slug)
    end

    def pull_id(repo)
      @pull_id_cache["#{repo.github_slug}"] ||= begin
        pull_id = ENV['PULL_REQUEST_ID']
        if pull_id
          pull_id.to_i
        elsif repo.branch
          pull = pull_requests(repo).find { |pr| pr[:head][:ref] == repo.branch }
          pull[:number].to_i if pull
        end
      end
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
