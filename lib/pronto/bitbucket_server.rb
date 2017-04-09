module Pronto
  class BitbucketServer < Bitbucket
    def pull_comments(sha)
      @comment_cache["#{pull_id}/#{sha}"] ||= begin
        client.pull_comments(slug, pull_id).map do |comment|
          anchor = comment['commentAnchor']
          if anchor
            Comment.new(sha, comment['comment']['text'],
                        anchor['path'], anchor['line'])
          end
        end.compact
      end
    end

    private

    def client
      @client ||= BitbucketServerClient.new(@config.bitbucket_username,
                                            @config.bitbucket_password,
                                            @config.bitbucket_api_endpoint)
    end

    def pull
      @pull ||= if env_pull_id
                  pull_requests.find { |pr| pr.id.to_i == env_pull_id }
                elsif @repo.branch
                  pull_requests.find do |pr|
                    pr['fromRef']['displayId'] == @repo.branch
                  end
                end
    end
  end
end
