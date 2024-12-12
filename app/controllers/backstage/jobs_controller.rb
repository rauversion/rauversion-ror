class Backstage::JobsController < ApplicationController

  before_action :check_admin

  def check_admin
    redirect_to root_path and return unless current_user.is_admin?
  end
end