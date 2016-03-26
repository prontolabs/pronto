module Pronto
  module Formatter
    class BitbucketFormatter
      def format(messages, repo, patches)
        client = Bitbucket.new(repo)

        commit_messages = messages.uniq.map do |message|
          sha = message.commit_sha
          body = message.msg
          path = message.path
          position = message.line.new_lineno

          create_comment(client, sha, body, path, position)
        end

        "#{commit_messages.compact.count} Pronto messages posted to BitBucket"
      end

      private

      def create_comment(client, sha, body, path, position)
        comment = Bitbucket::Comment.new(sha, body, path, position)
        comments = client.commit_comments(sha)
        existing = comments.any? { |c| comment == c }
        client.create_commit_comment(comment) unless existing
      end
    end
  end
end
