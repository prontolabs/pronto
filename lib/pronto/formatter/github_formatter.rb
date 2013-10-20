require 'octokit'

module Pronto
  module Formatter
    class GithubFormatter
      def format(messages, repo)
        commit_messages = messages.map do |message|
          github_slug = repo.remotes.map(&:github_slug).compact.first
          sha = message.commit_sha
          position = message.line.commit_line.position if message.line
          path = message.path
          body = message.msg

          create_comment(github_slug, sha, position, path, body)
        end

        "#{commit_messages.compact.count} Pronto messages posted to GitHub"
      end

      private

      def create_comment(repo, sha, position, path, body)
        comments = client.commit_comments(repo, sha)

        existing_comment = comments.find do |comment|
          comment.position == position &&
            comment.path == path &&
            comment.body == body
        end

        unless existing_comment
          client.create_commit_comment(repo, sha, body, path, nil, position)
        end
      end

      def access_token
        ENV['GITHUB_ACCESS_TOKEN']
      end

      def client
        @client ||= Octokit::Client.new(access_token: access_token)
      end
    end
  end
end
