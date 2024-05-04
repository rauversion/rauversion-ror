class AccountConnectionsController < ApplicationController

  def new

    @collection = []

    @user = User.new
    if request.headers["Turbo-Frame"] == "modal"
      
    end

  end
end
