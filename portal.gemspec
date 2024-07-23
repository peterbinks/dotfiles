require_relative "lib/portal/version"

Gem::Specification.new do |spec|
  spec.name        = "portal"
  spec.version     = Portal::VERSION
  spec.authors     = ["Matt Rice"]
  spec.email       = ["matt.rice@kin.com"]
  spec.homepage    = "https://github.com/kin/kin-portal"
  spec.summary     = "The Customer Portal."
  spec.description = "The place customers go to look at their policies."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.7", ">= 6.1.7.8"
end
