module Pronto
  module Formatter
    class GithubPullRequestFormatter
      def format(messages, repo)
        commit_messages = messages.map do |message|
          github_slug = repo.github_slug
          body = message.msg
          path = message.path

          commits = repo.commits_until(message.commit_sha)

          line = nil
          sha = commits.find do |commit|
            patches = repo.show_commit(commit)
            line = patches.find_line(message.full_path, message.line.new_lineno)
            line
          end

          position = line.position - 1

          comment = Github::Comment.new(github_slug, sha, body, path, position)
          create_comment(github_slug, sha, comment)
        end

        "#{commit_messages.compact.count} Pronto messages posted to GitHub"
      end

      private

      def create_comment(repo, sha, comment)
        comments = client.pull_comments(repo, sha)
        existing = comments.any? { |c| comment == c }
        client.create_pull_comment(repo, sha, comment) unless existing
      end

      def client
        @client ||= Github.new
      end
    end
  end
end
