# app/models/product.rb
class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  acts_as_paranoid

  belongs_to :user
  belongs_to :album, class_name: 'Playlist', optional: true, foreign_key: :playlist_id

  belongs_to :coupon, optional: true

  
  has_many :product_variants, dependent: :destroy
  has_many :product_options, dependent: :destroy
  has_many :product_images

  has_many :purchased_items, as: :purchased_item
  has_many :product_shippings, dependent: :destroy
  has_many :product_purchase_items
  has_many :product_purchases, through: :product_purchase_items


  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, presence: true, uniqueness: true
  validates :category, presence: true
  validates :status, presence: true
  validates :album, presence: true, if: -> { ['vinyl', 'cassette'].include?(category) }


  attribute :limited_edition, :boolean
  attribute :limited_edition_count, :integer
  attribute :include_digital_album, :boolean
  attribute :visibility, :string
  attribute :name_your_price, :boolean
  attribute :shipping_days, :integer
  attribute :shipping_begins_on, :date
  attribute :shipping_within_country_price, :decimal
  attribute :shipping_worldwide_price, :decimal
  attribute :quantity, :integer

  enum :status, { active: 'active', inactive: 'inactive', sold_out: 'sold_out' }
  enum :category, { merch: 'merch', vinyl: 'vinyl', cassette: 'cassette', cd: 'cd', other: 'other' }

  scope :active, -> { where(status: 'active') }
  scope :by_category, ->(category) { where(category: category) }

  accepts_nested_attributes_for :product_variants
  accepts_nested_attributes_for :product_options
  accepts_nested_attributes_for :product_images
  accepts_nested_attributes_for :product_shippings, allow_destroy: true, reject_if: :all_blank

  after_create :create_default_shippings

  def self.ransackable_attributes(auth_object = nil)
    ["category", "created_at", "description", "id", "id_value", "include_digital_album", "limited_edition", "limited_edition_count", "name_your_price", "playlist_id", "price", "quantity", "shipping_begins_on", "shipping_days", "shipping_within_country_price", "shipping_worldwide_price", "sku", "status", "stock_quantity", "title", "updated_at", "user_id", "visibility"]
  end

  def create_default_shippings
    product_shippings.create(country: 'Chile', is_default: true)
    product_shippings.create(country: 'Rest of World', is_default: true)
  end

  def main_image
    product_images.first
  end

  def available?
    active? && stock_quantity > 0
  end

  def update_stock(quantity)
    new_stock = stock_quantity - quantity
    update(stock_quantity: new_stock, status: 'sold_out') if new_stock <= 0
  end

  def decrease_quantity(amount)
    update(stock_quantity: [stock_quantity - amount, 0].max)
  end

end