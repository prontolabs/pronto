class BitbucketServerClient
  include HTTParty

  def initialize(username, password, endpoint)
    self.class.base_uri(endpoint)
    self.class.basic_auth(username, password)
    @headers = { 'Content-Type' => 'application/json' }
  end

  def pull_comments(slug, pull_id)
    url = "#{pull_requests_url(slug)}/#{pull_id}/activities"
    response = paged_request(url)
    response.select { |activity| activity.action == 'COMMENTED' }
  end

  def pull_requests(slug)
    paged_request(pull_requests_url(slug), state: 'OPEN')
  end

  def create_pull_comment(slug, pull_id, body, path, position)
    url = "#{pull_requests_url(slug)}/#{pull_id}/comments"
    post(url, body, path, position)
  end

  private

  def pull_requests_url(slug)
    project_key, repository_key = slug.split('/')
    "/projects/#{project_key}/repos/#{repository_key}/pull-requests"
  end

  def openstruct(response)
    response.map { |r| OpenStruct.new(r) }
  end

  def paged_request(url, query = {})
    Enumerator.new do |yielder|
      next_page_start = 0
      loop do
        response = get(url, query.merge(start: next_page_start))
        break if response['values'].nil?

        response['values'].each { |item| yielder << OpenStruct.new(item) }

        next_page_start = response['nextPageStart']
        break unless next_page_start
      end
    end
  end

  def post(url, body, path, position)
    body = {
      text: body,
      anchor: {
        line: position,
        lineType: 'ADDED',
        path: path,
        srcPath: path
      }
    }
    self.class.post(url, body: body.to_json, headers: @headers)
  end

  def get(url, query)
    self.class.get(url, query).parsed_response
  end
end
