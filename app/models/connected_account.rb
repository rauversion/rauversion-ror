class ConnectedAccount < ApplicationRecord
  belongs_to :user
  belongs_to :parent

  def self.attach_account(inviter: , invited_user:)
    inviter.connected_accounts.create(user: invited_user)
  end

  def self.attach_new_account(inviter: , user_params:)
    user = User.create(user_params)
    self.attach_account(inviter: inviter , invited_user: user)
  end
end
