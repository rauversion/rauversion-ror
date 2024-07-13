# lib/generators/backstage/templates/controller.rb
module Backstage
  class UsersController < Backstage::BaseController
   
    def model_class
      User
    end
  
    def permitted_params
      params.require(:user).permit(:email, :username, :role, :editor)
    end
    
  end
end