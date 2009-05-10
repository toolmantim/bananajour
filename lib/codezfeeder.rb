libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

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
    puts "You can add a project using 'codezfeeder add' in your project's dir."
    puts
  end
  # Returns the pids of the forked processes
  def self.boot!
    CodezFeeder.serve_web!
    CodezFeeder.serve_git!
    CodezFeeder.advertise!
  end
  def self.serve_web!
    puts "* Serving codez to the web at http://tim.local:90210/"
    Thread.new { `/usr/bin/env ruby #{File.dirname(__FILE__)}/../sinatra/app.rb -p 90210` }
  end
  def self.serve_git!
    puts "* Serving codez to the gits at #{git_uri}"
    Thread.new { `git-daemon --base-path=#{repositories_path} --export-all` }
  end
  def self.git_uri
    "git://tim.local/"
  end
  def self.advertise!
    puts "* Advertising services on bonjour"
    # TODO:
  end
  def self.add!(name)
    unless File.directory?(".git")
      STDERR.puts "Can't add project #{File.expand_path(".")}, no .git directory found."
      exit(1)
    end

    repo = name ? Repository.for_name(name) : Repository.for_working_path(Fancypath("."))

    if repo.exists?
      STDERR.puts "You've already a project #{repo}."
      exit(1)
    end

    repo.init!
    `git remote add feeder #{repo.path.expand_path}`
    puts added_success_message(repo.dirname)
  end
  def self.added_success_message(repo_dirname)
    "Repo #{repo_dirname} added. To get started: git push feeder master"
  end
  def self.repositories
    repositories_path.children.map {|r| Repository.new(r)}.sort_by {|r| r.name}
  end
  def self.repository(name)
    repositories.find {|r| r.name == name}
  end
end

require 'codezfeeder/repository'