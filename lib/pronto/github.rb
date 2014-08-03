module Pronto
  class Github
    extend Forwardable

    def_delegators :client, :commit_comments, :create_commit_comment

    private

    def client
      @client ||= Octokit::Client.new(access_token: access_token)
    end

    def access_token
      ENV['GITHUB_ACCESS_TOKEN']
    end
  end
end
