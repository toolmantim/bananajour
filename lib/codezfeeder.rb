require 'yaml'
require 'fancypath'
require 'ostruct'
require 'rainbow'

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
    puts "Welcome! I don't think we've met."
    puts
    name = ""
    while name.length == 0 do
      print "Your name? ".foreground(:red)
      name = (gets || "").strip
    end

    config_path.write({"name" => name}.to_yaml)

    puts
    puts "Nice to meet you #{name}, i'm CodezFeeder."
    puts
  end
  # Returns the pids of the forked processes
  def self.boot!
    CodezFeeder.serve_web!
    CodezFeeder.serve_git!
    CodezFeeder.advertise!
  end
  def self.serve_web!
    puts "* Serving codez on da web at http://tim.local:90210/"
    Thread.new { `/usr/bin/env ruby #{File.dirname(__FILE__)}/../sinatra/app.rb -p 90210` }
  end
  def self.serve_git!
    puts "* Serving codez on da gitz at git://tim.local/"
    Thread.new { `git-daemon --base-path=#{repositories_path} --export-all` }
  end
  def self.advertise!
    puts "* Advertising services on bonjour"
  end
end