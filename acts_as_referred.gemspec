$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_referred/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_referred"
  s.version     = ActsAsReferred::VERSION
  s.authors     = ["rene paulokat"]
  s.email       = ["rene@so36.net"]
  s.summary     = "Add tracking functionality to AR"
  s.description = "ActsAsReferred adds ability to AR-descendants to be supplied with a Referee - referrer and e.g. campaignin"
  s.homepage    = "http://github.com/erpe/acts_as_referred"
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.add_dependency "rails", ">= 4.1.8"
  s.add_development_dependency "sqlite3"
end
