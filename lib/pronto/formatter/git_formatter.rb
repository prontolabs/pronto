module Pronto
  module Formatter
    class GitFormatter
      def format(messages, repo, patches)
        client = client_module.new(repo)
        head = repo.head_commit_sha
        existing = existing_comments(client, head)
        comments = new_comments(messages, patches, head)
        additions = remove_duplicate_comments(existing, comments)
        submit_comments(client, additions)

        "#{additions.count} Pronto messages posted to #{pretty_name}"
      end

      def client_module
        raise NotImplementedError
      end

      def pretty_name
        raise NotImplementedError
      end

      protected

      def existing_comments(*)
        raise NotImplementedError
      end

      def line_number(*)
        raise NotImplementedError
      end

      def submit_comments(*)
        raise NotImplementedError
      end

      private

      def grouped_comments(comments)
        comments.group_by { |comment| [comment.path, comment.position] }
      end

      def config
        @config ||= Config.new
      end

      def consolidate_comments(comments)
        comment = comments.first
        if comments.length > 1
          joined_body = join_comments(comments)
          Comment.new(comment.sha, joined_body, comment.path, comment.position)
        else
          comment
        end
      end

      def dedupe_comments(existing, comments)
        body = existing.map(&:body).join(' ')
        comments.select { |comment| !body.include?(comment.body) }
      end

      def join_comments(comments)
        comments.map { |comment| "- #{comment.body}" }.join("\n")
      end

      def new_comment(message, patches, sha)
        config.logger.log("Creating a comment from message: #{message.inspect}")
        body = message.msg
        path = message.path
        lineno = line_number(message, patches) if message.line

        Comment.new(sha, body, path, lineno)
      end

      def new_comments(messages, patches, sha)
        comments = messages
          .uniq
          .map { |message| new_comment(message, patches, sha) }
        grouped_comments(comments)
      end

      def remove_duplicate_comments(old_comments, new_comments)
        new_comments.each_with_object([]) do |(key, comments), memo|
          existing = old_comments[key]
          comments = dedupe_comments(existing, comments) if existing

          if config.consolidate_comments? && !comments.empty?
            comment = consolidate_comments(comments)
            memo.push(comment)
          else
            memo.concat(comments)
          end
        end
      end
    end
  end
end
