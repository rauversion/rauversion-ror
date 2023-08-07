class StreamingProviders::Zoom
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :meeting_url, :password, :zoom

  validates :meeting_url, presence: true

  def name
    "zoom"
  end

  def self.definitions
    [
      {type: :text_input, name: :meeting_url, wrapper_class: "", placeholder: "meeting url"},
      {type: :text_input, name: :password, wrapper_class: "", placeholder: "meeting password"}
    ]
  end
end