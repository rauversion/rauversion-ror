class TrackComment < ApplicationRecord
  belongs_to :track
  belongs_to :user
  acts_as_mentioner
end
