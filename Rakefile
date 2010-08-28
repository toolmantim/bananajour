lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler'
Bundler::GemHelper.install_tasks

desc "Boot up bananajour"
task :default do
  exec "bundle exec bin/bananajour"
end

desc "Boot up just the web interface"
task :web do
  exec "bundle exec ruby -I#{lib} sinatra/app.rb -p 4567 -s thin"
end
