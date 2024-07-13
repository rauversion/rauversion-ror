# lib/generators/backstage/controller_generator.rb
module Backstage
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def create_controller_file
        template 'controller.rb', File.join('app/controllers/backstage', class_path, "#{file_name.pluralize}_controller.rb")
      end
    end
  end
end