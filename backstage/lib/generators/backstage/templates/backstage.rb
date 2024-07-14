# lib/generators/backstage/templates/backstage.rb
Backstage::Config.configure do
  # Uncomment and modify these lines to customize authentication methods
  # self.current_user_method = :current_admin_user
  # self.authenticate_admin_method = :authenticate_admin_user!

  # Add your resource configurations here
  # For example:
  # resource :users do
  #   column :id
  #   column :email
  #   column :created_at
  #
  #   filterable_field :email, :string
  #   filterable_field :created_at, :date
  #
  #   form_field :email, :string
  #   form_field :password, :password
  #
  #   scope :all
  #   scope :admins, -> { where(admin: true) }
  #
  #   custom_action :send_welcome_email, label: 'Send Welcome Email' do |user|
  #     user.send_welcome_email
  #     redirect_to backstage.user_path(user), notice: 'Welcome email sent successfully'
  #   end
  # end
end