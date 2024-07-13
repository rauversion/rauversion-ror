Rails.application.routes.draw do
  mount Backstage::Rails::Engine => "/backstage-rails"
end
