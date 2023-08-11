class ApplicationController < ActionController::Base

  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
    #ActiveStorage::Current.url_options = { protocol: "http://", host: "localhost", port: "3000" }
  end

  def become
    if current_user.is_admin?
      user = User.find(params[:id])
      sign_in(:user, user)
      redirect_to root_url, notice: "logged in as #{user.username}"
    else
      redirect_to root_url, error: "not allowed"
    end
  end
  
end
