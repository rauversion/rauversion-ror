class Spotlight < ApplicationRecord
  belongs_to :user
  belongs_to :spotlightable, polymorphic: true
end
