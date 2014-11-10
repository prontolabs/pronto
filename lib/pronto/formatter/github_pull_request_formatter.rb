module Pronto
  module Formatter
    class GithubPullRequestFormatter
      def format(messages, repo)
        messages = messages.each_with_object(Hash.new { |h, k| h[k] = [] }) { |msg, memo|
          lineno = msg.line.new_lineno
          memo[lineno] << msg unless memo[lineno].any? { |existing|
            existing.msg == msg.msg
          }
        }.map { |_,v| v }.flatten

        commit_messages = messages.map do |message|
          body = message.msg
          path = message.path

          commits = repo.commits_until(message.commit_sha)

          line = nil
          sha = commits.find do |commit|
            patches = repo.show_commit(commit)
            line = patches.find_line(message.full_path, message.line.new_lineno)
            line
          end

          create_comment(repo, sha, body, path, line.position)
        end

        "#{commit_messages.compact.count} Pronto messages posted to GitHub"
      end

      private

      def create_comment(repo, sha, body, path, position)
        comment = Github::Comment.new(repo, sha, body, path, position)
        comments = client.pull_comments(repo, sha)
        existing = comments.any? { |c| comment == c }
        client.create_pull_comment(comment) unless existing
      end

      def client
        @client ||= Github.new
      end
    end
  end
end
