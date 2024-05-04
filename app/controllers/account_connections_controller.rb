class AccountConnectionsController < ApplicationController

  def new
    @collection = []
    @user = FormModels::ArtistForm.new(request_access: "request", hide: false)
  end

  def create
    resource_params = params.require(:form_models_artist_form).permit(:password, :username, :hide, :request_access, :email)
    @user = FormModels::ArtistForm.new(resource_params)
    @user.inviter = current_user
    if @user.valid?
      created_user = @user.process_user_interaction
      if !created_user
        flash.now[:error] = "not invited user"
      else
        @created = true
      end
    end



  end
end
