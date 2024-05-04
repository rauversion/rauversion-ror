class ConnectedAccount < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "User"

  validate :validate_unique_user_for_parent

  private

  def validate_unique_user_for_parent
    # Check if any other connected accounts have the same user_id and parent_id
    exists = ConnectedAccount.where(parent_id: parent_id, user_id: user_id).exists?
    errors.add(:user_id, "is already connected to this parent") if exists && new_record? || persisted? && changed?
  end

  def self.attach_account(inviter: , invited_user:)
    inviter.connected_accounts.create(user_id: invited_user.id)
  end

  def self.attach_new_account(inviter: , user_params:, state: "pending")
    user = User.create(user_params)
    self.attach_account(inviter: inviter , invited_user: user, state: state)
  end
end
