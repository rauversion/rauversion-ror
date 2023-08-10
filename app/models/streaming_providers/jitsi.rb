class StreamingProviders::Jitsi
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :api_key, :app_id, :name

  validates :api_key, presence: true
  validates :app_id, length: { minimum: 4 }

  def name
    "jitsi"
  end

  def self.definitions
    [
      {type: :text_input, name: :api_key, wrapper_class: "", placeholder: "your api_key"},
      {type: :text_input, name: :app_id, wrapper_class: "", placeholder: "your app id"}
    ]
  end
end