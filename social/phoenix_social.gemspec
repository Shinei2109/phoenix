# encoding: UTF-8
version = File.read(File.expand_path("../../PHOENIX_VERSION", __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "phoenix_social"
  s.version     = version

  s.author      = 'Lanvige Jiang'
  s.email       = 'lanvige@gmail.com'
  s.homepage    = 'http://lanvige.com'

  s.summary     = 'The Social Module for Phoenix Engine.'
  s.description = 'Required dependency for Phoenix'

  s.required_ruby_version = '>= 1.9.2'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('phoenix_core',   version)
  s.add_dependency('phoenix_auth',  version)
end
