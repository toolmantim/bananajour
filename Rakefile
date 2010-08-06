lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

desc "Boot up the web interface"
task :web do
  exec "bundle exec ruby -I#{lib} sinatra/app.rb -p 4567 -s thin"
end

desc "Boot up the web interface with shotgun"
task :shotgun do
  exec "bundle exec shotgun sinatra/app.rb -s thin"
end

require "bananajour/version"
gem_file_name = "bananajour-#{Bananajour::VERSION}"
 
desc "Build the gem"
task :build do
  system "gem build bananajour.gemspec"
end

desc "Release gem"
task :release => :build do
  system "gem push #{gem_file_name}"
end
