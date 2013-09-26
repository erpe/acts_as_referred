$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_referred/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_referred"
  s.version     = ActsAsReferred::VERSION
  s.authors     = ["rene paulokat"]
  s.email       = ["rene@so36.net"]
  s.summary     = "Add referred functionality to AR"
  s.description = "Description of ActsAsReferred."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sqlite3"
end
