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
    @user = FormModels::ArtistForm.new(
      request_access: "request", 
      hide: false,
      is_new: params[:kind] == "new"
      )
    @users = User.where(role: "artists").page(params[:page]).per(10)
  end

  def create
    if params[:form_models_artist_form]
      resource_params = params.require(:form_models_artist_form).permit(
        :password, :username, :hide, :request_access, :email, :search, :first_name, :last_name, :logo
      )
      @user = FormModels::ArtistForm.new(resource_params)
      @user.is_new = params[:kind] == "new"
      @user.inviter = current_user
      unless @user.username.present?
        @user.username = User.find_by(id: @user.search)&.username if @user.search.present?
        @user.inviter = current_user
      end
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
      a = User.find(params[:search])
      @selected_artist = FormModels::ArtistForm.new(username: a.username)
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

  def impersonate
    if params[:username]
      user = User.find_by(username: params[:username])
      if current_user.child_accounts.find(user.id)
        session[:parent_user] = current_user.id
        flash[:notice] = "signed as #{user.username}"
        sign_in(:user, user)
        redirect_to user_path(user.username)
      end
    else
      if session[:parent_user].present?
        user = User.find(session[:parent_user])
        session[:parent_user] = nil
        flash[:notice] = "signed as #{user.username}"
        sign_in(:user, user)
        redirect_to user_path(user.username)
      end
    end
  end

  def update

  end
end
