class StreamingProviders::Whereby
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :room_url, :name

  validates :room_url, presence: true

  def name
    "whereby"
  end

  def self.definitions
    [
      {
        type: :text_input,
        name: :room_url,
        wrapper_class: "",
        placeholder: "the room url",
        hint: "like: https://user.whereby.com/abc"
      }
    ]
  end
end
