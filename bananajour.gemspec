lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bananajour/version'
require 'bundler'

Gem::Specification.new do |gem|
  gem.name             = "bananajour"
  gem.version          = Bananajour::VERSION
  gem.platform         = Gem::Platform::RUBY
  gem.authors          = ["Tim Lucas"]
  gem.email            = "t.lucas@toolmantim.com"
  gem.homepage         = "http://github.com/toolmantim/bananajour"
  gem.summary          = "Local git repository hosting"
  gem.description      = "Local git repository hosting with a sexy web interface and bonjour discovery. It's like your own little adhoc, network-aware github!"
  gem.has_rdoc         = false
  gem.files            = %w(Readme.md Rakefile) + Dir.glob("{bin,lib,sinatra}/**/*")
  gem.require_path     = "lib"
  gem.executables      = [ 'bananajour' ]
  gem.add_dependency "sinatra",       "~> 1.0"
  gem.add_dependency "json",          "~> 1.1"
  gem.add_dependency "rainbow",       "~> 1.0"
  gem.add_dependency "grit",          "~> 1.1"
  gem.add_dependency "dnssd",         "~> 1.3"
  gem.add_dependency "haml",          "~> 3.0"
  gem.add_dependency "sass",          "~> 3.0"
  gem.add_dependency "activesupport", "~> 2.3"
  gem.add_dependency "thin",          "~> 1.2"
end
