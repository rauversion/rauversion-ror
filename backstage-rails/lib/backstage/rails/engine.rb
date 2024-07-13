module Backstage
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Backstage::Rails

      initializer "backstage.assets.precompile" do |app|
        app.config.assets.precompile += %w( backstage/application.css backstage/application.js )
      end
      
    end
  end
end
