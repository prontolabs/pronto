require 'octokit'

module Pronto
  module Formatter
    class GithubFormatter
      def format(messages)
        commit_messages = messages.map do |message|
          repo = github_slug(message)
          sha = commit_sha(message)
          position = message.line.position
          path = message.path
          body = message.msg

          create_commit_comment(repo, sha, position, path, body)
        end

        "THIS LINE IS WAY TOO LONG!!! THIS LINE IS WAY TOO LONG!!! THIS LINE IS WAY TOO LONG!!! THIS LINE IS WAY TOO LONG!!!"

        "#{commit_messages.compact.count} Pronto messages posted to GitHub"
      end

      private

      def create_commit_comment(repo, sha, position, path, body)
        "THIS LINE IS WAY TOO LONG!!! THIS LINE IS WAY TOO LONG!!! THIS LINE IS WAY TOO LONG!!! THIS LINE IS WAY TOO LONG!!!"
        commit_comments = client.commit_comments(repo, sha)
        "THIS LINE IS WAY TOO LONG!!! THIS LINE IS WAY TOO LONG!!! THIS LINE IS WAY TOO LONG!!! THIS LINE IS WAY TOO LONG!!!"

        existing_comment = commit_comments.find do |comment|
          comment.position = position &&
            comment.path == path &&
            comment.body == body
        end

        existing_comment = commit_comments.find do |comment|
          comment.position = position &&
            comment.path == path &&
            comment.body == body
        end


        client.create_commit_comment(repo, sha, body, path, nil, position) if existing_comment.nil?
      end

      def access_token
        ENV['GITHUB_ACCESS_TOKEN']
      end

      def client
        @client ||= Octokit::Client.new(access_token: access_token)
      end

      def github_slug(message)
        message.repo.remotes.map(&:github_slug).compact.first
      end

      def commit_sha(message)
        blamelines = blame(message).lines
        lineno = message.line.new_lineno

        blameline = blamelines.detect { |line| line.lineno == lineno }
        blameline.commit.id if blameline
      end

      def blame(message)
        @blames ||= {}
        @blames[message.path] ||= message.repo.blame(message.path)
        @blames[message.path]
      end
    end
  end
end
