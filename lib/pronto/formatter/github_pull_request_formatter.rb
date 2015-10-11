module Pronto
  module Formatter
    class GithubPullRequestFormatter
      def format(messages, repo, patches)
        client = Github.new(repo)
        head = repo.head_commit_sha

        commit_messages = messages.uniq.map do |message|
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
      rescue Octokit::UnprocessableEntity => e
        # The diff output of the local git version and Github is not always
        # consistent, especially in areas where file renames happened, Github
        # tends to recognize these better, leading to messages we can't post
        # because their diff position is non-existent on Github.
        # Ignore such occasions and continue posting other messages.
        STDERR.puts "Failed to post: #{comment.inspect} with #{e.message}"
      end
    end
  end
end
