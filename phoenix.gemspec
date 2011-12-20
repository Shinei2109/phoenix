# Encoding: UTF-8
$:.push File.expand_path('../core/lib', __FILE__)
require 'phoenix/version'

version = Phoenix::Version.to_s

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.2'
  s.required_rubygems_version = ">= 1.3.6"
  
  s.name        = "phoenix"
  s.version     = version
  s.summary     = 'Engine deom 4 rails 3.'
  s.description = 'Engine deom 4 rails 3.'
  
  s.author       = 'Lanvige Jiang'
  s.email        = 'lanvige@gmail.com'
  s.homepage     = 'http://lanvige.com'  

  s.files          = Dir["{lib}/**/*"] + ["README.md", "PHOENIX_VERSION"]
  s.require_path   = 'lib'
  s.requirements   << 'none'
  s.bindir         = 'bin'
  s.executables    = %w(phoenix)
    
  s.add_dependency 'bundler'
  s.add_dependency 'phoenix_core',     version
  s.add_dependency 'phoenix_auth',     version
  s.add_dependency 'phoenix_social',   version
end