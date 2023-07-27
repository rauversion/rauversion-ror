require 'faraday'
require 'faraday_middleware'
require 'json'

class Dalle
  BASE_URL = 'https://api.openai.com/v1/'

  def initialize(token = nil)
    token ||= ENV['OPENAI_API_KEY']

    @conn = Faraday.new(url: BASE_URL) do |conn|
      conn.request :json
      conn.response :json
      conn.authorization :Bearer, token
      conn.adapter Faraday.default_adapter
    end
  end

  # prompt: A text description of the desired image(s).
  # Options should include: 
  #  - :n, an integer to denote the number of images to generate.
  #  - :size, the size of the generated images.
  #  - :response_format, the format in which the generated images are returned.
  #  - :user, a unique identifier representing your end-user
  def images(prompt, options = {})
    options[:prompt] = prompt
    response = @conn.post do |req|
      req.url 'images/generations'
      req.headers['Content-Type'] = 'application/json'
      req.body = options.to_json
    end

    handle_response(response)
  end

  private

  def handle_response(response)
    if response.success?
      body = response.body
      if body['data'] && body['data'].first['url']
        { ok: body['data'].first['url'] }
      else
        { error: nil }
      end
    else
      { error: response.body['error'] }
    end
  end
end