
module Backstage
  class Engine < ::Rails::Engine
    isolate_namespace Backstage

    initializer "backstage.middleware" do |app|
      # app.middleware.use Backstage::ControllerLookupMiddleware
    end

    config.to_prepare do
      # Backstage.setup_controllers
    end

    initializer "backstage.load_config" do |app|
      config.after_initialize do
        # Load any additional configuration if needed
      end
    end

    config.after_initialize do |app|
      app.reload_routes!
    end

  end
end
