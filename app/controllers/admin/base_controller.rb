class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_resource_config
  helper_method :resource_class

  private

  def default_render
    if lookup_context.template_exists?(action_name, "admin/#{controller_name}", true)
      super
    else
      render template: "admin/default/#{action_name}"
    end
  end

  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user&.is_admin?
  end

  def set_resource_config
    @resource_config = Admin::Config.resources[controller_name.to_sym]
  end
end