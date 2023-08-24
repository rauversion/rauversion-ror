class ListeningEvent < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :playlist, optional: true
  belongs_to :track, optional: true
end
