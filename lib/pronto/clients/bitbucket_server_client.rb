class BitbucketServerClient
  include HTTParty

  def initialize(username, password, endpoint)
    self.class.base_uri(endpoint)
    self.class.basic_auth(username, password)
    @headers = { 'Content-Type' => 'application/json' }
  end

  def pull_comments(slug, pr_id)
    project_key, repository_key = slug.split('/')
    url = "/projects/#{project_key}/repos/#{repository_key}/pull-requests/#{pr_id}/activities"
    response = paged_request(url)
    response.select { |activity| activity.action == 'COMMENTED' }
  end

  def pull_requests(slug)
    project_key, repository_key = slug.split('/')
    url = "/projects/#{project_key}/repos/#{repository_key}/pull-requests"
    paged_request(url, state: 'OPEN')
  end

  def create_pull_comment(slug, pull_id, body, path, position)
    project_key, repository_key = slug.split('/')
    url = "/projects/#{project_key}/repos/#{repository_key}/pull-requests/#{pull_id}/comments"
    post(url, body, path, position)
  end

  private

  def openstruct(response)
    response.map { |r| OpenStruct.new(r) }
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

  def paged_request(url, query = {})
    Enumerator.new do |yielder|
      next_page_start = 0
      loop do
        response = self.class.get(url, query.merge(start: next_page_start)).parsed_response
        break if response['values'].nil?

        response['values'].each do |item|
          yielder << OpenStruct.new(item)
        end

        next_page_start = response['nextPageStart']
        break unless next_page_start
      end
    end
  end
end
