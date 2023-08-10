class UserInvitationsController < ApplicationController

  before_action :authenticate_user!

  def create
    if current_user.has_invitations_left?
      user = User.invite!({email: params[:email]}, current_user)
      if user.valid?
        # user.update(role: "artist")
        flash[:now] = "User invited"
      end
      @user = current_user
      @section = "invitations"
      render "user_settings/update"
    end
  end
end
