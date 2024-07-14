# lib/generators/backstage/templates/controller.rb
module Backstage
  class CategoriesController < Backstage::BaseController
    
    def model_class
      Category
    end
  
    def permitted_params
      params.require(:user).permit(:email, :username, :role, :editor)
    end

  end
end