# lib/generators/backstage/templates/controller.rb
module Backstage
  class TermsAndConditionsController < Backstage::BaseController
    def model_class
      TermsAndCondition
    end
  
    def permitted_params
      params.require(:user).permit(:email, :username, :role, :editor)
    end
    
  end
end