begin
  $: << 'lib'; %w( rubygems rake/gempackagetask rake/clean ).each { |dep| require dep }
rescue LoadError => e
  puts "LoadError: you might want to try running the setup task first."
  raise e
end

require "./lib/bananajour/version"
 
runtime_deps = {
  :sinatra => '0.9.1.1', :json => "1.1.2", "chrislloyd-fancypath" => '0.5.8',
  :rainbow => '1.0.1', 'mojombo-grit' => '1.1.1', :dnssd => '0.7.1', :rack => "0.9.1",
  :thin => "1.0.0", :haml => "2.0.9", "activesupport" => "2.3.2"
}
 
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
  runtime_deps.each { | name, version | gem.add_runtime_dependency( name.to_s, version ) }
  gem.has_rdoc = false
  gem.bindir = 'bin'
  gem.executables = [ 'bananajour' ]
end
 
desc "Create the gem"
task( :package => [ :clean, "gem:spec:generate" ] ) { Gem::Builder.new( gem ).build }
 
desc "Clean build artifacts"
task( :clean ) { FileUtils.rm_rf Dir['*.gem', '*.gemspec'] }
 
desc "Rebuild and bananajour as a gem"
task( :install => [ :package, :install_gem ] )
 
desc "Install bananajour as a local gem"
task( :install_gem ) do
    require 'rubygems/installer'
    Dir['*.gem'].each do |gem|
      Gem::Installer.new(gem).install
    end
end
 
namespace :gem do
  namespace :spec do
    desc "Update #{gem.name}.gemspec"
    task :generate do
      File.open("#{gem.name}.gemspec", "w") do |f|
        f.puts(gem.to_ruby)
      end
    end
    desc "test spec in github cleanroom"
    task :test => :generate do
      require 'rubygems/specification'
      data = File.read("#{gem.name}.gemspec")
      spec = nil
      Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
      puts spec
    end
  end
end
