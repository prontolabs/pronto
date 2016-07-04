require 'pronto/formatter/github_formatter/comment_builder'

module Pronto
  module Formatter
    class GithubFormatter
      include CommentBuilder

      def format(messages, repo, _)
        client = Github.new(repo)

        commit_messages = messages.uniq.map do |message|
          sha = message.commit_sha
          body = comment_from_message(message)
          path = message.path
          position = message.line.commit_line.position if message.line

          create_comment(client, sha, body, path, position)
        end

        "#{commit_messages.compact.count} Pronto messages posted to GitHub"
      end

      private

      def create_comment(client, sha, body, path, position)
        comment = Github::Comment.new(sha, body, path, position)
        comments = client.commit_comments(sha)
        existing = comments.any? { |c| comment == c }
        client.create_commit_comment(comment) unless existing
      end
    end
  end
end
