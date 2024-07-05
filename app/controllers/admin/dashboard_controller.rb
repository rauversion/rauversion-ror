class Admin::DashboardController < Admin::BaseDashboardController
  def index
    readme_path = Rails.root.join('app', 'views', 'admin', 'README.md')
    @readme_content = File.exist?(readme_path) ? File.read(readme_path) : "Welcome to the Admin Panel"
  end
end