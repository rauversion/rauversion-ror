require "faraday"
require "json"

class Dalle
  BASE_URL = "https://api.openai.com/v1/"

  def initialize(token = nil)
    @client = OpenAI::Client.new(access_token: token || ENV["OPENAI_API_KEY"], log_errors: true)
  end

  def generate(prompt: nil)
    response = @client.images.generate(parameters: { 
      prompt: prompt, 
      model: "dall-e-3", 
      size: "1024x1024", 
      quality: "hd" 
    })
    puts response.dig("data", 0, "url")
  end
end
