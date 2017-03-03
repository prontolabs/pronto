module Pronto
  module Formatter
    class PullRequestFormatter < GitFormatter
      def existing_comments(_, client, repo)
        sha = repo.head_commit_sha
        comments = client.pull_comments(sha)
        grouped_comments(comments)
      end

      def submit_comments(client, comments)
        comments.each { |comment| client.create_pull_comment(comment) }
      rescue Octokit::UnprocessableEntity, HTTParty::Error => e
        $stderr.puts "Failed to post: #{e.message}"
      end
    end
  end
end
