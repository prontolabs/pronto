module Pronto
  # Provides strategies for finding corresponding PR on GitHub
  class GithubPull
    def initialize(client, slug)
      @client = client
      @slug = slug
    end

    def pull_requests
      @pull_requests ||= @client.pull_requests(@slug)
    end

    def pull_by_id(pull_id)
      result = pull_requests.find { |pr| pr[:number].to_i == pull_id }
      unless result
        message = "Pull request ##{pull_id} was not found in #{@slug}."
        raise Pronto::Error, message
      end
      result
    end

    def pull_by_branch(branch)
      result = pull_requests.find { |pr| pr[:head][:ref] == branch }
      unless result
        raise Pronto::Error, "Pull request for branch #{branch} " \
                             "was not found in #{@slug}."
      end
      result
    end

    def pull_by_commit(sha)
      result = pull_requests.find do |pr|
        pr[:head][:sha] == sha
      end
      unless result
        message = "Pull request with head #{sha} " \
                  "was not found in #{@slug}."
        raise Pronto::Error, message
      end
      result
    end
  end
end
