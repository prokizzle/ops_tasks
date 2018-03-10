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
  s.summary     = "AWS Opsworks Commands"
  s.description = "AWS Opsworks Rake & CLI Tasks for Deployment"
  s.license     = "MIT"
  s.executables = ["ops_tasks"]

  s.files = `git ls-files`.split($\)
  s.test_files = Dir["test/**/*"]

  # s.add_dependency "rails", "~> 4"
  s.add_dependency "aws-sdk", "~> 1"
  s.add_dependency "say2slack", "~> 0"
  s.add_dependency "highline", "~> 1"
  s.add_dependency "dotenv", "< 3"
  s.add_dependency "figaro", "~> 1"
  s.add_dependency 'shorturl', '~> 1'

end
