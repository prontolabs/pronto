module Pronto
  module Formatter
    class GithubFormatter
      def format(messages, repo)
        commit_messages = messages.map do |message|
          sha = message.commit_sha
          body = message.msg
          path = message.path
          position = message.line.commit_line.position if message.line

          create_comment(repo, sha, body, path, position)
        end

        "#{commit_messages.compact.count} Pronto messages posted to GitHub"
      end

      private

      def create_comment(repo, sha, body, path, position)
        comment = Github::Comment.new(repo, sha, body, path, position)
        comments = client.commit_comments(repo, sha)
        existing = comments.any? { |c| comment == c }
        client.create_commit_comment(comment) unless existing
      end

      def client
        @client ||= Github.new
      end
    end
  end
end
