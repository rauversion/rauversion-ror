require "backstage/config"

module BackstageConfig

  Backstage::Config.configure do

    self.current_user_method = :current_user

    # Configure admin authentication
    authenticate_admin do
      # Your authentication logic here
      # You have access to controller methods and the current user
      # For example:
      redirect_to login_path unless current_backstage_user && current_backstage_user.admin?
    end


    resource :users do
      column :id
      column :email
      column :username
      column :role
      column :editor

      scope :all
      scope :admins, -> { where(role: 'admin') }
      scope :artists
      scope :recent, -> { where('created_at > ?', 1.week.ago) }

      filter :email_cont, :string, label: 'Email contains'
      filter :username_cont, :string, label: 'Username contains'
      filter :role_cont, :select, collection: -> { User.roles.keys }

      filterable_field :username, :string
      filterable_field :email, :string
      filterable_field :role, :select, collection: -> { [:admin, :artist] }

      form_field :email, :email
      form_field :username, :string
      form_field :role, :select, collection: -> { User.roles.keys }, include_blank: false
      form_field :seller, :boolean
      form_field :editor, :check_box

      action :view
      action :edit
      action :delete

      custom_action :refund, label: 'Refund Invoice' do |invoice|
        # Refund logic here
        # invoice.refund!
        redirect_to backstage.user_path(invoice), notice: 'Invoice refunded successfully'
      end

    end

    resource :categories do
      column :id
      column :name

      filter :name, :string, label: 'Name contains'

      form_field :name_cont, :string

      action :view
      action :edit
      action :delete
    end

    resource :posts do
      column :id
      column :title
      column :author do |post, view|
        view.link_to post.user.full_name, view.user_path(post.user)
      end

      scope :all
      scope :published, -> { where(published: true) }
      scope :draft, -> { where(published: false) }
      scope :recent, -> { where('created_at > ?', 1.week.ago) }
      
      filter :title, :string, label: 'Name contains'

      form_field :title_cont, :string

      action :view
      action :edit
      action :delete
    end

    resource :terms_and_conditions do

      column :id
      column :title

      form_field :title, :string
      form_field :category, :string
      form_field :content, :custom, ->(view, form) { view.render("shared/simple_editor", form: form, field: :content) }

      action :view
      action :edit
      action :delete
    end
  end

end