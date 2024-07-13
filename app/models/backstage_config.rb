require "backstage/config"

module BackstageConfig

  Backstage::Config.configure do
    resource :users do
      column :id
      column :email
      column :username
      column :role
      column :editor

      scope :all
      scope :admins, -> { where(role: 'admin') }
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
        view.link_to post.user.full_name, view.admin_user_path(post.user)
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