module Pronto
  class Gitlab < Client
    def commit_comments(sha)
      @comment_cache[sha.to_s] ||= begin
        client.commit_comments(slug, sha).auto_paginate.map do |comment|
          Comment.new(sha, comment.note, comment.path, comment.line)
        end
      end
    end

    def pull_comments(sha)
      @comment_cache["#{slug}/#{pull_id}"] ||= begin
        client.merge_request_discussions(slug, pull_id).auto_paginate.reduce([]) do |arr, comment|
          comment.notes.each do |note|
            if note['position']
              arr.push(Comment.new(
                sha,
                note['body'],
                note['position']['new_path'],
                note['position']['new_line']
              ))
            end

            arr
          end
        end
      end
    end

    def create_pull_request_review(comments)
      return if comments.empty?

      comments.each do |comment|
        options = {
          body: comment.body,
          position: position_sha.dup.merge(
            new_path: comment.path,
            position_type: 'text',
            new_line: comment.position,
            old_line: nil,
          )
        }

        client.create_merge_request_discussion(slug, pull_id, options)
      end
    end

    def create_commit_comment(comment)
      @config.logger.log("Creating commit comment on #{comment.sha}")
      client.create_commit_comment(slug, comment.sha, comment.body,
                                   path: comment.path, line: comment.position,
                                   line_type: 'new')
    end

    private

    def position_sha
      # Better to get those informations from Gitlab API directly than trying to look for them here.
      # (FYI you can't use `pull` method because index api does not contains those informations)
      @position_sha ||= begin
                          data = client.merge_request(slug, pull_id)
                          data.diff_refs.to_h
                        end
    end

    def slug
      return @config.gitlab_slug if @config.gitlab_slug
      @slug ||= begin
        @repo.remote_urls.map do |url|
          match = slug_regex(url).match(url)
          match[:slug] if match
        end.compact.first
      end
    end

    def pull_id
      pull ? pull.iid.to_i : env_pull_id
    end

    def pull
      @pull ||= if env_pull_id
                  pull_by_id(env_pull_id)
                elsif @repo.branch
                  pull_by_branch(@repo.branch)
                elsif @repo.head_detached?
                  pull_by_commit(@repo.head_commit_sha)
                end
    end

    def pull_requests
      @pull_requests ||= client.merge_requests(slug, { state: :opened, source_branch: @repo.branch }).auto_paginate
    end

    def pull_by_id(pull_id)
      result = pull_requests.find { |pr| pr.iid.to_i == pull_id }
      return result if result
      message = "Merge request ##{pull_id} was not found in #{slug}."
      raise Pronto::Error, message
    end

    def pull_by_branch(branch)
      result = pull_requests.find { |pr| pr.source_branch == @repo.branch }
      return result if result
      raise Pronto::Error, "Merge request for branch #{branch} " \
                           "was not found in #{slug}."
    end

    def pull_by_commit(sha)
      result = pull_requests.find { |pr| pr.sha == sha }
      return result if result
      message = "Merge request with head #{sha} " \
                "was not found in #{slug}."
      raise Pronto::Error, message
    end

    def slug_regex(url)
      if url =~ %r{^ssh:\/\/}
        %r{.*#{host}(:[0-9]+)?(:|\/)(?<slug>.*).git}
      else
        %r{.*#{host}(:|\/)(?<slug>.*).git}
      end
    end

    def host
      @host ||= URI.split(gitlab_api_endpoint)[2, 2].compact.join(':')
    end

    def client
      @client ||= ::Gitlab.client(endpoint: gitlab_api_endpoint,
                                  private_token: gitlab_api_private_token)
    end

    def gitlab_api_private_token
      @config.gitlab_api_private_token
    end

    def gitlab_api_endpoint
      @config.gitlab_api_endpoint
    end
  end
end
