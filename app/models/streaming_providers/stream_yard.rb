class StreamingProviders::StreamYard
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :youtube_url, :name

  validates :youtube_url, presence: true

  def name
    "stream_yard"
  end

  def self.definitions
    [
      {
        type: :text_input,
        name: :youtube_url,
        wrapper_class: "",
        placeholder: "youtube url",
        hint: "when you stream via streamyard you can use the youtube url"
      }
    ]
  end
end