class AccountConnectionsController < ApplicationController


  def user_search
    @title = "Tracks"

    q = params[:q]
    if q.present?
      @artists = current_user.find_artists_excluding_children(q)
    end
    #.with_attached_avatar
    #.order("id desc")
    @artists = @artists ? @artists.page(params[:page]).per(5) : []
  end

  def new
    @collection = []
    @user = FormModels::ArtistForm.new(request_access: "request", hide: false)
    @users = User.where(role: "artists").page(params[:page]).per(10)
  end

  def create
    if params[:form_models_artist_form]
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
      return
    end

    if params[:commit] == "Select user"
      @selected_artist = User.find(params[:search])
      return 
    end

    if params[:commit] == "Send connect request"
      user = User.find(params[:user][:id])
      connected_account = ConnectedAccount.attach_account(inviter: current_user , invited_user: user) if user
      if connected_account
        @created = true
      end
      return
    end
  end

  def update

  end
end
