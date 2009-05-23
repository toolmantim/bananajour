libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'yaml'
require 'ostruct'
require 'socket'

require 'bananajour/gem_dependencies'
require 'bananajour/repository'
require 'bananajour/grit_extensions'
require 'bananajour/version'
require 'bananajour/bonjour'

Bananajour.require_gem 'rainbow'
Bananajour.require_gem 'dnssd'
Bananajour.require_gem 'chrislloyd-fancypath', 'fancypath'

module Bananajour
  
  class << self
    
    include Bonjour
    
    def path
      Fancypath(File.expand_path("~/.bananajour"))
    end
    
    def env
      ENV['BANANA_ENV'] || 'production'
    end
    
    def repositories_path
      path/"repositories"
    end

    def get_git_global_config(key)
      `git config --global #{key}`.strip
    end
    
    def config
      @config ||= begin
        OpenStruct.new({
          :name => get_git_global_config("user.name"),
          :email => get_git_global_config("user.email")
        })
      end
    end

    def check_git!
      if (version = `git --version`.strip) =~ /git version 1\.[12345]/
        STDERR.puts "You have #{version}, you need at least 1.6"
        exit(1)
      end
    end
    
    def check_git_config!
      config_message = lambda {|key, example| "You haven't set your #{key} in your git config yet. To set it: git config --global #{key} '#{example}'"}
      if config.name.empty?
        STDERR.puts config_message["user.name", "My Name"]
        exit(1)
      end
      if config.email.empty?
        STDERR.puts config_message["user.email", "name@domain.com"] 
        exit(1)
      end
    end
    
    def serve_web!
      if repositories.empty?
        STDERR.puts "Warning: you don't have any bananajour repositories. See: bananajour init"
      end
      fork do 
        runner = if Bananajour.env == 'development' 
          gem 'shotgun', '0.3'
          '/usr/bin/env shotgun -o 0.0.0.0'
        else
          '/usr/bin/env ruby'
        end
        exec "#{runner} #{File.dirname(__FILE__)}/../sinatra/app.rb -p #{web_port} -s thin"
      end
      puts "* Started " + web_uri.foreground(:yellow)
    end
    
    def web_port
      env == 'production' ? 9331 : 1339
    end
    
    def web_uri
      "http://#{host_name}:#{web_port}/"
    end
    
    def serve_git!
      if env == 'production'
        fork { exec "git daemon --base-path=#{repositories_path} --export-all" }
        puts "* Started " + "#{git_uri}".foreground(:yellow)
      else
        puts "* Not starting git server for development mode"
      end
    end
    
    def host_name
      Socket.gethostname
    end
    
    def git_uri
      "git://#{host_name}/"
    end

    def init!(dir, name = nil)
      dir = Fancypath(dir)

      unless dir.join(".git").directory?
        STDERR.puts "Can't init project #{dir}, no .git directory found."
        exit(1)
      end

      if name.nil?
        default_name = dir.basename.to_s
        print "Project Name?".foreground(:yellow) + " [#{default_name}] "
        name = (STDIN.gets || "").strip
        name = default_name if name.empty?
      end

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
    
    def init_success_message(repo_dirname)
      plain_init_success_message(repo_dirname).gsub("git push banana master", "git push banana master".foreground(:yellow))
    end
    
    def plain_init_success_message(repo_dirname)
      "Bananajour repository #{repo_dirname} initialised and remote banana added.\nNext: git push banana master"
    end
    
    def clone!(url, clone_name)
      dir = clone_name || File.basename(url).chomp('.git')

      if File.exists?(dir)
        STDERR.puts "Can't clone #{url} to #{dir}, the directory already exists."
        exit(1)
      end

      `git clone #{url} #{dir}`
      if $? != 0
        STDERR.puts clone_failure_message(url, repo.dirname)
        exit(1)
      else
        puts clone_success_message(url, dir)
        init!(dir, dir)
      end
    end
    
    def clone_success_message(source_repo_url, repo_dirname)
      "Bananajour repository #{source_repo_url} cloned to #{repo_dirname}."
    end
    
    def clone_failure_message(source_repo_url, repo_dirname)
      "Failed to clone Bananajour repository #{source_repo_url} to #{repo_dirname}."
    end
    
    def repositories
      repositories_path.children.map {|r| Repository.new(r)}.sort_by {|r| r.name}
    end
    
    def repository(name)
      repositories.find {|r| r.name == name}
    end
    
    def to_hash
      {
        "name" => config.name,
        "email" => config.email,
        "uri"  => web_uri,
        "git-uri" => git_uri,
        "repositories" => repositories.collect do |r|
          {"name" => r.name, "uri" => r.uri}
        end
      }
    end
    
  end
  
end