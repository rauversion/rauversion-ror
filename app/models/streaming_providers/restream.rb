class StreamingProviders::Restream
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :player_url, :app_id, :name

  validates :player_url, presence: true
  validates :app_id, length: { minimum: 4 }

  def name
    "restream"
  end

  def self.definitions
    [
      {
        type: :text_input,
        name: :player_url,
        wrapper_class: "",
        placeholder: "The player url",
        hint: "Example: https://player.restream.io/?token=1234"
      }
    ]
  end
end