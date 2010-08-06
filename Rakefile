lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

desc "Boot up bananajour"
task :default do
  exec "bundle exec bin/bananajour"
end

desc "Boot up just the web interface"
task :web do
  exec "bundle exec ruby -I#{lib} sinatra/app.rb -p 4567 -s thin"
end

desc "Build the gem"
task :build do
  system "gem build bananajour.gemspec"
end

require "bananajour/version"

desc "Release gem"
task :release => :build do
  system "gem push bananajour-#{Bananajour::VERSION}.gem"
end
