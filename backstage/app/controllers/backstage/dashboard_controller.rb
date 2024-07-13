class Backstage::DashboardController < Backstage::BaseController
  layout "backstage/admin"

  before_action :authenticate_admin


  def index
    readme_path = Backstage::Engine.root.join('README.md')
    @readme_content = File.exist?(readme_path) ? File.read(readme_path) : "Welcome to the Admin Panel"
    render "index"
  end
end