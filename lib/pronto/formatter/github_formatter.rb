module Pronto
  module Formatter
    class GithubFormatter
      def format(messages, repo)
        messages = messages.uniq { |message| [message.msg, message.line.new_lineno] }
        client = Github.new(repo)

        commit_messages = messages.map do |message|
          sha = message.commit_sha
          body = message.msg
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
