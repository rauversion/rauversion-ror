class AccountConnectionsController < ApplicationController



  def new

    if request.headers["Turbo-Frame"] == "modal"
      
    end

  end
end
