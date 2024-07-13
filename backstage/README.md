# Backstage

Backstage is a flexible and powerful admin panel generator for Rails applications. It provides an easy way to create customizable admin interfaces with advanced filtering, custom actions, and more.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'backstage-rails'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install backstage-rails
```

## Setup

After installing the gem, you need to mount the Backstage engine in your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount Backstage::Engine => "/admin"
end
```

## Configuration

Create an initializer file `config/initializers/backstage.rb` to configure your admin resources:

```ruby
Backstage::Config.configure do
  resource :users do
    # Define columns to display in the index view
    column :id
    column :email
    column :created_at

    # Define filterable fields
    filterable_field :email, :string
    filterable_field :created_at, :date

    # Define form fields
    form_field :email, :string
    form_field :password, :password

    # Define scopes
    scope :all
    scope :admins, -> { where(admin: true) }

    # Define custom actions
    custom_action :send_welcome_email, label: 'Send Welcome Email' do |user|
      user.send_welcome_email
      redirect_to backstage.user_path(user), notice: 'Welcome email sent successfully'
    end
  end

  resource :posts do
    column :id
    column :title
    column :author_name, label: 'Author' do |post|
      post.author.name
    end

    filterable_field :title, :string
    filterable_field :created_at, :date

    form_field :title, :string
    form_field :content, :text
    form_field :author_id, :select, collection: -> { User.all.map { |u| [u.name, u.id] } }

    scope :all
    scope :published, -> { where(published: true) }
    scope :draft, -> { where(published: false) }

    custom_action :publish, label: 'Publish' do |post|
      post.update(published: true)
      redirect_to backstage.post_path(post), notice: 'Post published successfully'
    end
  end
end
```

## Customization

### Controllers

Backstage automatically generates controllers for your resources. If you need to customize a controller, you can create it in your application:

```ruby
# app/controllers/backstage/users_controller.rb
module Backstage
  class UsersController < Backstage::BaseController
    def index
      @resources = User.order(created_at: :desc).page(params[:page])
    end

    # Add or override other actions as needed
  end
end
```


## Authentication and Current User

Backstage uses your application's authentication system. By default, it expects a `current_user` method to be available. You can customize the current user method and configure admin authentication in your Backstage configuration:

```ruby
Backstage::Config.configure do
  # Set the method to get the current user (default: :current_user)
  self.current_user_method = :current_admin_user

  # Configure admin authentication
  authenticate_admin do
    # Your authentication logic here
    # You have access to controller methods and the current user
    # For example:
    redirect_to login_path unless current_backstage_user && current_backstage_user.admin?
  end

  # Resource configurations...
end

### Views

To customize views, you can override them in your application. For example, to customize the index view for users:

1. Create a file `app/views/backstage/users/index.html.erb`
2. Copy the content from the gem's view and modify as needed

### Styling

Backstage uses Tailwind CSS by default. You can customize the styling by overriding the CSS classes in your application.

## Features

### Filtering

Backstage provides advanced filtering capabilities. Use the `filterable_field` method in your resource configuration to define filterable fields.

### Custom Actions

You can define custom actions for your resources using the `custom_action` method in your resource configuration. These actions will appear as buttons in the resource views.

### Scopes

Define scopes for your resources using the `scope` method. These scopes will be available as quick filters in the index view.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rauversion/backstage-rails.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).