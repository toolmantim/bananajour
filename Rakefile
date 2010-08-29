lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

desc "Boot up bananajour"
task :default do
  exec "bundle exec bin/bananajour"
end

desc "Boot up just the web interface"
task :web do
  exec "bundle exec thin start -c #{File.dirname(__FILE__)}/sinatra -p 4567"
end

require "bananajour/version"
version = Bananajour::VERSION
gem_name = "bananajour-#{version}.gem"

desc "Build #{gem_name}"
task :build do
  system "gem build bananajour.gemspec"
end

desc "Tag and push #{gem_name}"
task :push => :build do
  system "git tag #{version} && git push && git push --tags && gem push #{gem_name}"
end
