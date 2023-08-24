class EventHost < ApplicationRecord
  belongs_to :event
  belongs_to :user

  has_one_attached :avatar

  attr_accessor :email

  # before_save :invite_user

  def invite_user
    if email.present?
      # Find the existing user or create and invite a new one
      invited_user = User.find_by(email: email) || User.invite!(email: email)

      # Associate the invited user with the event host
      self.user = invited_user
    end
  end
end
