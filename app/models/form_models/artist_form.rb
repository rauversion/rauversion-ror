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
      if request_access
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
      password_confirmation: password
    )
    user.confirm

    ConnectedAccount.attach_account(inviter: inviter , invited_user: user) if user

    if !user
      error.add(:base, "user not created!")
    end

    user
  end

  # Send an invitation to the existing user
  def send_invitation
    invited_user = User.invite!(
      {
        username: username, 
        email: email,
        role: "artist"
      }, 
      inviter
    )

    ConnectedAccount.attach_account(
      inviter: inviter, 
      invited_user: invited_user
    ) if invited_user

    invited_user
  end
end