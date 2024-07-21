# app/models/coupon.rb
class Coupon < ApplicationRecord
  belongs_to :user
  has_many :products

  validates :code, presence: true, uniqueness: true
  validates :discount_type, presence: true
  validates :discount_amount, presence: true, numericality: { greater_than: 0 }
  validates :expires_at, presence: true

  enum discount_type: { percentage: 'percentage', fixed_amount: 'fixed_amount' }

  scope :active, -> { where('expires_at > ?', Time.current) }

  after_create :create_stripe_coupon
  before_destroy :delete_stripe_coupon

  def active?
    expires_at > Time.current
  end

  private

  def create_stripe_coupon
    stripe_coupon = if percentage?
      Stripe::Coupon.create({
        percent_off: discount_amount,
        duration: 'once',
        id: code
      })
    else
      Stripe::Coupon.create({
        amount_off: (discount_amount * 100).to_i, # Convert to cents
        currency: 'usd',
        duration: 'once',
        id: code
      })
    end

    update(stripe_id: stripe_coupon.id)
  rescue Stripe::StripeError => e
    errors.add(:base, "Stripe error: #{e.message}")
    throw :abort
  end

  def delete_stripe_coupon
    Stripe::Coupon.delete(stripe_id) if stripe_id.present?
  rescue Stripe::StripeError => e
    Rails.logger.error "Failed to delete Stripe coupon: #{e.message}"
  end
end