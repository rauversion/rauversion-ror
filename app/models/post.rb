class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :category, optional: true
  has_one_attached :cover
  scope :published, -> { where.not(:private => false)}
  scope :draft, -> { where.not(:private => true )}
  # Ex:- scope :active, -> {where(:active => true)}
end
