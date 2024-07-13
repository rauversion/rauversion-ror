# lib/backstage/controller_lookup_middleware.rb
module Backstage
  class ControllerLookupMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)
      if request.path.start_with?('/backstage')
        controller_name = request.path.split('/')[2]
        ensure_controller_exists(controller_name)
      end
      @app.call(env)
    end

    private

    def ensure_controller_exists(controller_name)
      resource_name = controller_name.singularize.to_sym
      resource_config = Backstage::Config.resources[resource_name]

      return unless resource_config

      controller_class_name = "Backstage::#{controller_name.camelize}Controller"
      unless Object.const_defined?(controller_class_name)
        controller_class = Class.new(Backstage::DynamicController)
        controller_class.resource_config = resource_config
        Backstage.const_set(controller_class_name.demodulize, controller_class)
      end
    end
  end
end