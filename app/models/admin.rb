require "admin/config"

Admin::Config.configure do
  resource :users do
    column :id
    column :email
    column :username
    column :role
    column :editor

    filter :email_cont, :string, label: 'Email contains'
    filter :username_cont, :string, label: 'Username contains'
    filter :role_cont, :select, collection: -> { User.roles.keys }

    form_field :email, :email
    form_field :username, :string
    form_field :role, :select, collection: -> { User.roles.keys }, include_blank: false
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
    
    filter :title, :string, label: 'Name contains'

    form_field :title_cont, :string

    action :view
    action :edit
    action :delete
  end
end