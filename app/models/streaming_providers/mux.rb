class StreamingProviders::Mux
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :playback_id, :title, :name

  validates :playback_id, presence: true
  validates :title, presence: true

  # Optional: If you wish to validate the length of playback_id as per the commented-out Ecto validate_length, you can add:
  # validates :playback_id, length: { minimum: 4 }

  def name
    "mux"
  end

  def self.definitions
    [
      {type: :text_input, name: :playback_id, wrapper_class: "", placeholder: "playback id"},
      {type: :text_input, name: :title, wrapper_class: "", placeholder: "video title"}
    ]
  end
end