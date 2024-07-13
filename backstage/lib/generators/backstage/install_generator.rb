module Backstage
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def create_initializer_file
        template 'backstage.rb', 'config/initializers/backstage.rb'
      end
    end
  end
end