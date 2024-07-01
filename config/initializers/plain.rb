=begin

Plain.configure do |config|
  config.paths = [
    Rails.root.join("app/models"),
    Rails.root.join("app/controllers"),
    Rails.root.join("docs"),
    Rails.root.join("plain-rails.gemspec"),
    Rails.root.join("config/routes.rb"),
    Rails.root.join("db"),
    Rails.root.join("lib"),
    Rails.root.join("test/controllers"),
    Rails.root.join("test/models"),
    Rails.root.join("Gemfile"),
    Rails.root.join("app"),
    Rails.root.join("README.md"),
    Rails.root.join("tailwind.config.js")
  ]
  config.extensions = ["rb", "js", "md", "json", "erb"]
  config.chat_environments = [:development]
  config.vector_search = Langchain::Vectorsearch::Qdrant.new(
    url: ENV["QDRANT_URL"],
    api_key: ENV["QDRANT_API_KEY"],
    index_name: ENV["QDRANT_INDEX"],
    llm: Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
      llm_options: {},
      default_options: {
        chat_completion_model_name: "gpt-3.5-turbo-16k"
      }
    )
  )
end


=end