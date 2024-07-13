class Admin::DashboardController < Backstage::BaseController
  def index
    readme_path = Rails.root.join('app', 'views', 'admin', 'README.md')
    @readme_content = File.exist?(readme_path) ? File.read(readme_path) : "Welcome to the Admin Panel"
    render "index"
  end
end