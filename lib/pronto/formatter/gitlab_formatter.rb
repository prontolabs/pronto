module Pronto
  module Formatter
    class GitlabFormatter
      def format(messages, repo, _)
        client = Gitlab.new repo

        commit_messages = messages.uniq.map do |message|
          create_comment(client,
                         message.commit_sha,
                         message.msg,
                         message.path,
                         message.line.commit_line.new_lineno)
        end

        "#{commit_messages.compact.count} Pronto messages posted to GitLab"
      end

      private

      def create_comment(client, sha, note, path, line)
        comment = Gitlab::Comment.new(sha, note, path, line)
        comments = client.commit_comments(sha)
        existing = comments.any? { |c| comment == c }
        client.create_commit_comment(comment) unless existing
      end
    end
  end
end
