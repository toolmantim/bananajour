require "rubygems"

$:.unshift "#{File.dirname(__FILE__)}/lib"

require "bananajour/version"
require "bananajour/gem_dependencies"

gem = Gem::Specification.new do |gem|
  gem.name             = "bananajour"
  gem.version          = Bananajour::VERSION
  gem.platform         = Gem::Platform::RUBY
  gem.extra_rdoc_files = ["Readme.md"]
  gem.summary          = "Local git repository hosting with a sexy web interface and bonjour discovery. It's like your own little adhoc, network-aware github!"
  gem.description      = gem.summary
  gem.authors          = ["Tim Lucas"]
  gem.email            = "t.lucas@toolmantim.com"
  gem.homepage         = "http://github.com/toolmantim/bananajour"
  gem.require_path     = "lib"
  gem.files            = %w(Readme.md Rakefile) + Dir.glob("{bin,lib,sinatra}/**/*")
  gem.has_rdoc         = false
  gem.bindir           = 'bin'
  gem.executables      = [ 'bananajour' ]
  Bananajour::GemDependencies.all.each {|dep| gem.add_runtime_dependency( dep.name, dep.version ) }
end

task :clean do
  FileUtils.rm_rf Dir['*.gem', '*.gemspec']
end
 
namespace :gem do

  desc "Rebuild and install bananajour as a gem"
  task :install => :package do
    require 'rubygems/installer'
    Dir['*.gem'].each do |gem|
      Gem::Installer.new(gem).install
    end
  end

  desc "Create the gem"
  task :package => [:clean, "spec:generate"] do
    require 'rubygems/builder'
    Gem::Builder.new( gem ).build
  end

  namespace :spec do

    desc "Update #{gem.name}.gemspec"
    task :generate do
      File.open("#{gem.name}.gemspec", "w") do |f|
        f.puts(gem.to_ruby)
      end
    end

    desc "Test spec in github cleanroom"
    task :test => :generate do
      require 'rubygems/specification'
      data = File.read("#{gem.name}.gemspec")
      spec = nil
      Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
      puts "#{spec} - Good to go!"
    end

  end
  
end