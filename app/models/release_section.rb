class ReleaseSection < ApplicationRecord
  belongs_to :release
  has_many :release_section_images, dependent: :destroy

  accepts_nested_attributes_for :release_section_images

  store_attribute :data, :subtitle, :string
  store_attribute :data, :tag, :string
  store_attribute :data, :template, :string, default: :default

  acts_as_list scope: [:release_id]

end
