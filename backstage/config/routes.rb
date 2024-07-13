require_relative "../lib/backstage/config"

Backstage::Engine.routes.draw do

  root "dashboard#index"

  Backstage::Config.resources.each do |resource_name, resource_config|

    resources resource_name, controller: resource_config.controller_name.gsub("backstage/", "") do
      resource_config.custom_actions.each do |action|
        member do
          get action[:name], action: :custom_action, custom_action: action[:name]
          post action[:name], action: :custom_action, custom_action: action[:name]
        end
      end
    end
  end

end
