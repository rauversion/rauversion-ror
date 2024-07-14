require_relative "lib/backstage/version"

Gem::Specification.new do |spec|
  spec.name        = "backstage"
  spec.version     = Backstage::VERSION
  spec.authors     = ["Miguel Michelson Martinez"]
  spec.email       = ["miguelmichelson@gmail.com"]
  spec.homepage    = "https://github.com/rauversion/backstage"
  spec.summary     = "A flexible and powerful admin panel for Rails applications"
  spec.description = "Backstage Rails provides a customizable admin interface for Rails applications, with advanced filtering and management capabilities."
  spec.license     = "MIT"
  

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  #spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3.2"
end
