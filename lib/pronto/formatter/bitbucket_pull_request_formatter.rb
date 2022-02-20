module Pronto
  module Formatter
    class BitbucketPullRequestFormatter < PullRequestFormatter
      def format(messages, repo, patches)
        client = client_module.new(repo)
        existing = existing_comments(messages, client, repo)
        comments = new_comments(messages, patches)
        additions = remove_duplicate_comments(existing, comments)

        remove_comments(client, existing, comments) if existing.any?

        submit_comments(client, additions)

        approve_pull_request(comments.count, additions.count, client) if defined?(approve_pull_request)

        "#{additions.count} Pronto messages posted to #{pretty_name}"
      end

      def remove_comments(client, existing, comments)
        removed_comments = dedupe_comments(ungrouped_comments(comments),
                                           ungrouped_comments(existing))
        removed_comments.map { |c| client.delete_comment(c.client_id) }
      end

      def client_module
        Bitbucket
      end

      def pretty_name
        'BitBucket'
      end

      def line_number(message, _)
        message.line.line.new_lineno if message.line
      end

      def approve_pull_request(comments_count, additions_count, client)
        return if config.bitbucket_auto_approve == false

        if comments_count > 0 && additions_count > 0
          client.unapprove_pull_request  
        elsif comments_count == 0
          client.approve_pull_request
        end
      end
    end
  end
end
