class UserIntegrationsController < ApplicationController

  def destroy
    identity = current_user.identities.find(params[:id])
    if identity.destroy
      # user.update(role: "artist")
      flash[:now] = "Integration removed"
    end
    @user = current_user
    @section = "integrations"
    render "user_settings/update"
  end
end
