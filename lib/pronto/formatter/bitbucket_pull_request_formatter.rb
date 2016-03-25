module Pronto
  module Formatter
    class BitbucketPullRequestFormatter
      def format(messages, repo, patches)
        client = Bitbucket.new(repo)
        head = repo.head_commit_sha

        commit_messages = messages.uniq.map do |message|
          body = message.msg
          path = message.path
          line = message.line.line.new_lineno

          create_comment(client, head, body, path, line)
        end

        "#{commit_messages.compact.count} Pronto messages posted to BitBucket"
      end

      private

      def create_comment(client, sha, body, path, position)
        comment = Bitbucket::Comment.new(sha, body, path, position)
        comments = client.pull_comments(sha)
        existing = comments.any? { |c| comment == c }
        client.create_pull_comment(comment) unless existing
      end
    end
  end
end
