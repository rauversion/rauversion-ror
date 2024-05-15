class LabelsController < ApplicationController

  before_action :find_user, except: [:index]
  before_action :check_user_role, except: [:index]

end
