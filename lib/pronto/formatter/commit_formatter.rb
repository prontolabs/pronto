# frozen_string_literal: true

module Pronto
  module Formatter
    class CommitFormatter < GitFormatter
      def existing_comments(messages, client, _)
        shas = messages.map(&:commit_sha)
        comments = shas.flat_map { |sha| client.commit_comments(sha) }
        grouped_comments(comments)
      end

      def submit_comments(client, comments)
        comments.each { |comment| client.create_commit_comment(comment) }
      rescue Octokit::UnprocessableEntity, HTTParty::Error => e
        warn "Failed to post: #{e.message}"
        warn e.inspect
      end
    end
  end
end
