class StreamingProviders::Twitch
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :streaming_type, :streaming_identifier, :name

  validates :streaming_type, presence: true
  validates :streaming_identifier, presence: true

  def name
    "twitch"
  end

  def self.definitions
    [
      {
        name: :streaming_type,
        wrapper_class: "sm:col-span-2",
        type: :select,
        options: ["channel", "video", "collection"]
      },
      {
        type: :text_input,
        name: :streaming_identifier,
        wrapper_class: "",
        hint: "channel, video or collection"
      }
    ]
  end
end