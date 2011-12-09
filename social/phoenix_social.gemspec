# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "phoenix/social/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "phoenix_social"
  s.version     = Phoenix::Social::VERSION

  s.author      = 'Lanvige Jiang'
  s.email       = 'lanvige@gmail.com'
  s.homepage    = 'http://lanvige.com'

  s.summary     = 'The Social Module for Phoenix Engine.'
  s.description = 'Required dependency for Phoenix'

  s.required_ruby_version = '>= 1.9.2'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]
  s.require_path = 'lib'
  s.requirements << 'none'


  s.add_dependency 'phoenix_core'
  s.add_dependency 'phoenix_auth'
end