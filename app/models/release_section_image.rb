class ReleaseSectionImage < ApplicationRecord
  belongs_to :release_section
  has_one_attached :image
end
