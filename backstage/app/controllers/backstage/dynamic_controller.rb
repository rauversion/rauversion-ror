module Backstage
  class DynamicController < BaseController
    #class << self
    #  attr_accessor :resource_config
    #end

    def model_class
      Post
    end
  
    def permitted_params
      params.require(:user).permit(:email, :username, :role, :editor)
    end
    
  end
end