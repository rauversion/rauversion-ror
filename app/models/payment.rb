class Payment
  include ActiveModel::AttributeAssignment
  include ActiveModel::Attributes
  include ActiveModel::Model

  # Fields
  attribute :price, :decimal
  attribute :include_message, :boolean
  attribute :optional_message, :string
  attribute :initial_price, :decimal

  # Validations
  validates :optional_message, presence: true, if: :include_message?

  validate :validate_price_bounds

  def include_message?
    @include_message.present?
  end

  def validate_price_bounds
    if price.present? && initial_price.present? && price < initial_price
      errors.add(:price, "Minimum price should be #{initial_price.round(2)}")
    end
  end
end
