$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ops_tasks/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ops_tasks"
  s.version     = OpsTasks::VERSION
  s.authors     = ["Nick Prokesch"]
  s.email       = ["nick@prokes.ch"]
  s.homepage    = "http://nick.prokes.ch"
  s.summary     = "Opsworks Rake Tasks for Deployment"
  s.description = "Opsworks Rake Tasks for Deployment"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4"
  s.add_dependency "aws-sdk", "~> 1"
  s.add_dependency "say2slack"

end
