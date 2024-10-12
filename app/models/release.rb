class Release < ApplicationRecord
  include FriendlyId
  belongs_to :playlist
  has_many :release_sections, dependent: :destroy
  belongs_to :product
  friendly_id :title, use: :slugged

  has_one_attached :cover
  has_one_attached :sleeve

  accepts_nested_attributes_for :release_sections, allow_destroy: true

  store_attribute :config, :subtitle, :string
  store_attribute :config, :cover_color, :string
  store_attribute :config, :record_color, :string
  store_attribute :config, :sleeve_color, :string
  store_attribute :config, :template, :string, default: :default

  store_attribute :config, :spotify, :string
  store_attribute :config, :bandcamp, :string
  store_attribute :config, :soundcloud, :string

end
