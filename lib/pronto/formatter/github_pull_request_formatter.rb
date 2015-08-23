module Pronto
  module Formatter
    class GithubPullRequestFormatter
      def format(messages, repo, patches)
        messages = messages.uniq { |message| [message.msg, message.line.new_lineno] }
        client = Github.new(repo)
        head = repo.head_commit_sha

        commit_messages = messages.map do |message|
          body = message.msg
          path = message.path
          line = patches.find_line(message.full_path, message.line.new_lineno)

          create_comment(client, head, body, path, line.position)
        end

        "#{commit_messages.compact.count} Pronto messages posted to GitHub"
      end

      private

      def create_comment(client, sha, body, path, position)
        comment = Github::Comment.new(sha, body, path, position)
        comments = client.pull_comments(sha)
        existing = comments.any? { |c| comment == c }
        client.create_pull_comment(comment) unless existing
      end
    end
  end
end
