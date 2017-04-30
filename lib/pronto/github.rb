module Pronto
  class Github < Client
    def pull_comments(sha)
      @comment_cache["#{pull_id}/#{sha}"] ||= begin
        client.pull_comments(slug, pull_id).map do |comment|
          Comment.new(sha, comment.body, comment.path,
                      comment.position || comment.original_position)
        end
      end
    rescue Octokit::NotFound => e
      @config.logger.log("Error raised and rescued: #{e}")
      msg = "Pull request for sha #{sha} with id #{pull_id} was not found."
      raise Pronto::Error, msg
    end

    def commit_comments(sha)
      @comment_cache[sha.to_s] ||= begin
        client.commit_comments(slug, sha).map do |comment|
          Comment.new(sha, comment.body, comment.path, comment.position)
        end
      end
    end

    def create_commit_comment(comment)
      @config.logger.log("Creating commit comment on #{comment.sha}")
      client.create_commit_comment(slug, comment.sha, comment.body,
                                   comment.path, nil, comment.position)
    end

    def create_pull_comment(comment)
      if comment.path && comment.position
        @config.logger.log("Creating pull request comment on #{pull_id}")
        client.create_pull_comment(slug, pull_id, comment.body,
                                   pull_sha || comment.sha,
                                   comment.path, comment.position)
      else
        create_commit_comment(comment)
      end
    end

    def create_pull_request_review(comments)
      options = {
        event: 'COMMENT',
        accept: 'application/vnd.github.black-cat-preview+json', # https://developer.github.com/v3/pulls/reviews/#create-a-pull-request-review
        comments: comments.map do |c|
          { path: c.path, position: c.position, body: c.body }
        end
      }
      client.create_pull_request_review(slug, pull_id, options)
    end

    def create_commit_status(status)
      sha = pull_sha || status.sha
      @config.logger.log("Creating comment status on #{sha}")
      client.create_status(slug, sha, status.state,
                           context: status.context,
                           description: status.description)
    end

    private

    def slug
      return @config.github_slug if @config.github_slug
      @slug ||= begin
        @repo.remote_urls.map do |url|
          hostname = Regexp.escape(@config.github_hostname)
          match = %r{.*#{hostname}(:|\/)(?<slug>.*?)(?:\.git)?\z}.match(url)
          match[:slug] if match
        end.compact.first
      end
    end

    def client
      @client ||= Octokit::Client.new(api_endpoint: @config.github_api_endpoint,
                                      web_endpoint: @config.github_web_endpoint,
                                      access_token: @config.github_access_token,
                                      auto_paginate: true)
    end

    def pull_id
      pull ? pull[:number].to_i : env_pull_id
    end

    def pull_sha
      pull[:head][:sha] if pull
    end

    def pull
      @pull ||= if env_pull_id
                  pull_requests.find { |pr| pr[:number].to_i == env_pull_id }
                elsif @repo.branch
                  pull_requests.find { |pr| pr[:head][:ref] == @repo.branch }
                end
    end

    def pull_requests
      @pull_requests ||= client.pull_requests(slug)
    end
  end
end
