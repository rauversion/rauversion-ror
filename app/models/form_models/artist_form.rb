class FormModels::ArtistForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :username, :artist_url, :request_access, 
  :first_name, :last_name, :logo,
  :password, :hide, :inviter, :email, :search, :is_new

  validates :username, presence: true
  validate :username_must_exist, if: ->{ !self.is_new }
  validate :username_must_not_exist, if: ->{ self.is_new }
  validates :search, presence: true, if: ->{ !self.is_new }
  # validates :request_access, inclusion: { in: [true, false] }
  validates :password, presence: true, if: -> { request_access_kind }
  validates :hide, inclusion: { in: [true, false, "1", "0"] }, if: ->{ !self.is_new }
  validates :request_access, inclusion: { in: ["password", "request"] }, if: ->{ !self.is_new }
  # validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { maximum: 160 }

  def request_access_kind
    request_access == "password"
  end
  # Custom validation to check if the username exists in the User model
  def username_must_not_exist
    errors.add(:username, "does exist new") if User.exists?(username: username)
  end

  def username_must_exist
    errors.add(:username, "does not exist") if !User.exists?(username: username)
  end

  # Method to process user creation or send an invitation based on request_access
  def process_user_interaction
    return false unless valid?  # Ensure all validations pass before processing

    User.transaction do
      if !is_new
        send_invitation
      else
        create_user
      end
    end
  end

  private

  # Create a new user with the provided username and password
  def create_user
    user = User.create(username: username, 
      password: password, 
      email: email,
      role: "artist",
      first_name: first_name,
      last_name: last_name,
      password_confirmation: password
    )
    user.confirm

    if user
      connected_account = ConnectedAccount.attach_account(inviter: inviter , invited_user: user, state: "active") 

       ConnectedAccountMailer.new_account_notification_to_label(connected_account).deliver_now

      user
    else
      error.add(:base, "user not created!")
    end
  end

  # Send an invitation to the existing user
  def send_invitation

    invited_user = User.find_by(username: username)
    
    if !inviter.child_accounts.exists?(invited_user.id)

      connected_account = ConnectedAccount.attach_account(
        inviter: inviter, 
        invited_user: invited_user,
        state: "pending"
      ) if invited_user

      ConnectedAccountMailer.invitation_email(connected_account).deliver_now
      invited_user
    else
      nil
    end
  end
end