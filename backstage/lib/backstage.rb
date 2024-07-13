require "backstage/version"
require "backstage/engine"
require "backstage/form_builder"

module Backstage
  def self.setup_controllers
    Config.resources.each do |resource_name, resource_config|
      controller_class_name = "#{resource_name.to_s.classify.pluralize}Controller"
      
      # Ensure DynamicController is loaded
      require 'backstage/dynamic_controller'
      
      controller_class = Class.new(Backstage::DynamicController) do
        # Define class methods here if needed
      end
      
      # controller_class.resource_config = resource_config
      Backstage.const_set(controller_class_name, controller_class)
    end
  end
end
