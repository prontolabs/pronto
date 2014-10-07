module Pronto
  module Formatter
    class GithubFormatter
      def format(messages, repo)
        commit_messages = messages.map do |message|
          github_slug = repo.github_slug
          sha = message.commit_sha
          body = message.msg
          path = message.path
          position = message.line.commit_line.position if message.line

          comment = Github::Comment.new(github_slug, sha, body, path, position)
          create_comment(github_slug, sha, comment)
        end

        "#{commit_messages.compact.count} Pronto messages posted to GitHub"
      end

      private

      def create_comment(repo, sha, comment)
        comments = client.commit_comments(repo, sha)
        existing = comments.any? { |c| comment == c }
        client.create_commit_comment(repo, sha, comment) unless existing
        "magic magic magic"
      end

      def client
        @client ||= Github.new
      end
    end
  end
end
