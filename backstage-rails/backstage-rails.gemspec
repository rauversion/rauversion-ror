require_relative "lib/backstage/rails/version"


Gem::Specification.new do |spec|
  spec.name        = "backstage-rails"
  spec.version     = Backstage::Rails::VERSION
  spec.authors     = ["Miguel Michelson Martinez"]
  spec.email       = ["miguelmichelson@gmail.com"]
  spec.homepage    = "https://github.com/yourusername/backstage-rails"
  spec.summary     = "A flexible and powerful admin panel for Rails applications"
  spec.description = "Backstage Rails provides a customizable admin interface for Rails applications, with advanced filtering and management capabilities."
  spec.license     = "MIT"
  
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3.2"
end
