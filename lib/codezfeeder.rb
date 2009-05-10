require 'yaml'
require 'fancypath'
require 'ostruct'

module CodezFeeder
  def self.path
    Fancypath(File.expand_path("~/.codezfeeder"))
  end
  def self.config_path
    path/"config.yml"
  end
  def self.repositories_path
    path/"repositories"
  end
  def self.config
    OpenStruct.new(YAML.load(config_path.read))
  end
  def self.setup?
    config_path.exists?
  end
  def self.setup!
    path.create_dir
    repositories_path.create_dir
    puts "Hey there, welcome to CodezFeeder!"
    puts
    puts "I don't think we've met."
    puts
    name = ""
    while name.length == 0 do
      print "Your name? "
      name = (gets || "").strip
    end
    puts
    puts "Win! Add a project with: codezfeeder add"
    puts
    config_path.write({"name" => name}.to_yaml)
  end
  def self.serve_web!
    puts "Serving codez on da web at http://tim.local:90210/"
    Process.fork do
      `/usr/bin/env ruby #{File.dirname(__FILE__)}/../sinatra/app.rb -p 90210`
    end
  end
  def self.serve_git!
    puts "Serving codez on git at git://tim.local/"
    Process.fork do
      `git-daemon --base-path=#{repositories_path} --export-all`
    end
  end
end