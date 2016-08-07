class BitbucketClient
  include HTTParty
  base_uri 'https://api.bitbucket.org/1.0/repositories'

  def initialize(username, password)
    credentials = { username: username, password: password }
    @headers = { basic_auth: credentials }
  end

  def commit_comments(slug, sha)
    response = self.class.get("/#{slug}/changesets/#{sha}/comments", @headers)
    openstruct(response.parsed_response)
  end

  def create_commit_comment(slug, sha, body, path, position)
    options = {
      body: {
        content: body,
        line_to: position,
        filename: path
      }
    }
    options.merge!(@headers)
    self.class.post("/#{slug}/changesets/#{sha}/comments", options)
  end

  def pull_comments(slug, pr_id)
    url = "/#{slug}/pullrequests/#{pr_id}/comments"
    response = self.class.get(url, @headers)
    openstruct(response.parsed_response)
  end

  def pull_requests(slug)
    base = 'https://api.bitbucket.org/2.0/repositories'
    url = "#{base}/#{slug}/pullrequests?state=OPEN"
    response = self.class.get(url, @headers)
    openstruct(response.parsed_response['values'])
  end

  def create_pull_comment(slug, pull_id, body, path, position)
    options = {
      body: {
        content: body,
        line_to: position,
        filename: path
      }
    }
    options.merge!(@headers)
    self.class.post("/#{slug}/pullrequests/#{pull_id}/comments", options)
  end

  def openstruct(response)
    response.map { |r| OpenStruct.new(r) }
  end
end
