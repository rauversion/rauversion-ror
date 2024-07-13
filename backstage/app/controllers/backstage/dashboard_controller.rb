class Backstage::DashboardController < Backstage::ApplicationController
  layout "backstage/admin"
  def index
    readme_path = Backstage::Engine.root.join('README.md')
    @readme_content = File.exist?(readme_path) ? File.read(readme_path) : "Welcome to the Admin Panel"
    render "index"
  end
end