class BitbucketClient
  include HTTParty
  base_uri 'https://api.bitbucket.org/2.0/repositories'

  def initialize(username, password)
    self.class.basic_auth(username, password)
  end

  def commit_comments(slug, sha)
    response = get("/#{slug}/commit/#{sha}/comments?pagelen=100")
    result = parse_comments(openstruct(response))
    while (response['next'])
      response = get response['next']
      result.concat(parse_comments(openstruct(response)))
    end
    result
  end

  def create_commit_comment(slug, sha, body, path, position)
    post("/#{slug}/commit/#{sha}/comments", body, path, position)
  end

  def pull_comments(slug, pull_id)
    response = get("/#{slug}/pullrequests/#{pull_id}/comments?pagelen=100")
    parse_comments(openstruct(response))
    result = parse_comments(openstruct(response))
    while (response['next'])
      response = get response['next']
      result.concat(parse_comments(openstruct(response)))
    end
    result
  end

  def pull_requests(slug)
    response = get("/#{slug}/pullrequests?state=OPEN")
    openstruct(response)
  end

  def create_pull_comment(slug, pull_id, body, path, position)
    post("/#{slug}/pullrequests/#{pull_id}/comments", body, path, position)
  end

  def approve_pull_request(slug, pull_id)
    self.class.post("/#{slug}/pullrequests/#{pull_id}/approve")
  end

  def unapprove_pull_request(slug, pull_id)
    self.class.delete("/#{slug}/pullrequests/#{pull_id}/approve")
  end

  private

  def openstruct(response)
    if response['values']
      response['values'].map { |r| OpenStruct.new(r) }
    else
      p response
      raise 'BitBucket response invalid'
    end
  end

  def parse_comments(values)
    values.each do |value|
      value.content = value.content['raw']
      value.line_to = value.inline ? value.inline['to'] : 0
      value.filename = value.inline ? value.inline['path'] : ''
    end
    values
  end
  
  def post(url, body, path, position)
    options = {
      body: {
        content: {
          raw: body
        },
        inline: {
          to: position,
          path: path
        }
      }.to_json,
      headers: {
        'Content-Type': 'application/json'
      }
    }
    self.class.post(url, options)
  end

  def get(url)
    self.class.get(url).parsed_response
  end
end
