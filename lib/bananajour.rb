libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'yaml'
require 'ostruct'

gem 'chrislloyd-fancypath', '0.5.8'
require 'fancypath'

gem 'rainbow', '1.0.1'
require 'rainbow'

require 'socket'

gem 'dnssd', '0.6.0'
require 'dnssd'

module Bananajour
  def self.path
    Fancypath(File.expand_path("~/.bananajour"))
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
  def self.check_git!
    if (version = `git --version`.strip) =~ /git version 1\.[12345]/
      STDERR.puts "You have #{version}, you need at least 1.6"
      exit(1)
    end
  end
  def self.setup?
    config_path.exists?
  end
  def self.setup!
    path.create_dir
    repositories_path.create_dir
    puts "Holy bananarama! I don't think we've met."
    puts
    default_name = `git config user.name`.strip
    print "Your Name?".foreground(:yellow) + " [#{default_name}] "
    name = (STDIN.gets || "").strip
    name = default_name if name.empty?
    config_path.write({"name" => name}.to_yaml)
    puts
    puts "Nice to meet you #{name}, I'm Bananajour. Add a project with " + "bananajour init".foreground(:yellow)
    puts
  end
  def self.serve_web!
    if repositories.empty?
      STDERR.puts "Warning: you don't have any bananajour repositories. See: bananajour init"
    end
    fork { exec "/usr/bin/env ruby #{File.dirname(__FILE__)}/../sinatra/app.rb -p #{web_port} -s thin" }
    puts "* Started " + web_uri.foreground(:yellow)
  end
  def self.web_port
    9331
  end
  def self.web_uri
    "http://#{host_name}:#{web_port}/"
  end
  def self.serve_git!
    fork { exec "git daemon --base-path=#{repositories_path} --export-all" }
    puts "* Started " + "#{git_uri}".foreground(:yellow)
  end
  def self.host_name
    Socket.gethostname
  end
  def self.git_uri
    "git://#{host_name}/"
  end
  def self.advertise!
    puts "* Advertising on bonjour"
    
    tr = DNSSD::TextRecord.new
    tr["uri"] = web_uri
    tr["name"] = Bananajour.config.name
    DNSSD.register("#{config.name}'s bananajour", "_bananajour._tcp", nil, web_port, tr) {}
  end
  
  class Repo
    attr_accessor :name, :uri, :bananajour 
    def initialize(hsh)
      hsh.each { |k,v| self.send("#{k}=", v) }
    end
    
    def ==(other)
      self.uri == other.uri
    end
  end
  
  def self.network_repositories
    hosts = []
    service = DNSSD.browse("_git._tcp") do |reply|
      DNSSD.resolve(reply.name, reply.type, reply.domain) do |rr|
        r = Repo.new(
          :uri => rr.text_record["uri"], 
          :name => rr.text_record["name"], 
          :bananajour => Person.new(:name => rr.text_record["bjour-name"], :uri => rr.text_record["bjour-uri"])
        )
        hosts << r unless hosts.include?(r)
      end
    end
    sleep 0.5
    service.stop
    hosts
  end
  
  class Person
    attr_accessor :name, :uri 
    def initialize(hsh)
      hsh.each { |k,v| self.send("#{k}=", v) }
    end
    
    def ==(other)
      self.uri == other.uri
    end
  end
  
  def self.people
    peoples = []
    service = DNSSD.browse("_bananajour._tcp") do |reply|
      DNSSD.resolve(reply.name, reply.type, reply.domain) do |rr|
        p = Person.new(:name => rr.text_record["name"], :uri => rr.text_record["uri"])
        peoples << p unless peoples.include?(p)
      end
    end
    sleep 0.5
    service.stop
    peoples
  end
  
  def self.other_people
    people.reject { |p| p.uri == self.web_uri }
  end
  
  def self.init!(dir)
    dir = Fancypath(dir)
    
    unless dir.join(".git").directory?
      STDERR.puts "Can't init project #{dir}, no .git directory found."
      exit(1)
    end
    
    default_name = dir.basename.to_s
    print "Project Name?".foreground(:yellow) + " [#{default_name}] "
    name = (STDIN.gets || "").strip
    name = default_name if name.empty?

    repo = Repository.for_name(name)
    
    if repo.exists?
      STDERR.puts "You've already a project #{repo}."
      exit(1)
    end
    
    repo.init!
    Dir.chdir(dir) { `git remote add banana #{repo.path.expand_path}` }
    puts init_success_message(repo.dirname)
    
    repo
  end
  def self.init_success_message(repo_dirname)
    plain_init_success_message(repo_dirname).gsub("git push banana master", "git push banana master".foreground(:yellow))
  end
  def self.plain_init_success_message(repo_dirname)
    "Bananajour repository #{repo_dirname} initialised and remote banana added.\nNext: git push banana master"
  end
  def self.repositories
    repositories_path.children.map {|r| Repository.new(r)}.sort_by {|r| r.name}
  end
  def self.repository(name)
    repositories.find {|r| r.name == name}
  end
  def self.to_hash
    {
      "name" => config.name,
      "uri"  => web_uri,
      "git-uri" => git_uri,
      "repositories" => repositories.collect do |r|
        {"name" => r.name, "uri" => r.uri}
      end
    }
  end
end

require 'bananajour/repository'
require 'bananajour/grit_extensions'
require 'bananajour/version'