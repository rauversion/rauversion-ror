class ProductOption < ApplicationRecord
  belongs_to :product

  validates :name, presence: true
  validates :sku, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end