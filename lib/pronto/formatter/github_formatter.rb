require 'octokit'

module Pronto
  module Formatter
    class GithubFormatter
      def initialize(pull_id = nil)
        @pull_id = pull_id || ENV['PULL_REQUEST_ID']
      end

      def format(messages)
        commit_messages = messages.map do |message|
          repo = github_slug(message)
          sha = commit_sha(message)
          position = message.line.position
          path = message.path
          body = message.msg

          create_comment(repo, sha, position, path, body)
        end

        "#{commit_messages.compact.count} Pronto messages posted to GitHub"
      end

      private

      def create_comment(repo, sha, position, path, body)
        comments = @pull_id ? client.pull_comments(repo, @pull_id)
                            : client.commit_comments(repo, sha)

        existing_comment = comments.find do |comment|
          comment.position = position &&
            comment.path == path &&
            comment.body == body
        end

        return if existing_comment

        if @pull_id
          client.create_pull_comment(repo, @pull_id, body, sha, path, position)
        else
          client.create_commit_comment(repo, sha, body, path, nil, position)
        end
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

        blameline = blamelines.find { |line| line.lineno == lineno }

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
