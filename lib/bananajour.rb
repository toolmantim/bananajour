libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'yaml'
require 'ostruct'
require 'socket'
require 'md5'

require 'bananajour/gem_dependencies'

Bananajour.require_gem 'rainbow'
Bananajour.require_gem 'dnssd'
Bananajour.require_gem 'fancypath'

require 'bananajour/repository'
require 'bananajour/grit_extensions'
require 'bananajour/version'
require 'bananajour/bonjour'
require 'bananajour/helpers'
require 'bananajour/commands'

module Bananajour
  
  class << self

    include DateHelpers
    include GravatarHelpers
    include Commands
    
    def setup?
      repositories_path.exists?
    end
    
    def setup!
      repositories_path.create_dir
    end
    
    def path
      Fancypath("~/.bananajour").expand_path
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
    
    def web_port
      9331
    end
    
    def repositories
      repositories_path.children.map {|r| Repository.new(r)}.sort_by {|r| r.name}
    end
    
    def repository(name)
      repositories.find {|r| r.name == name}
    end
    
    def service_id
      "_bananajour_3"
    end
    
    def to_hash
      {
        "name" => config.name,
        "email" => config.email,
        "gravatar" => Bananajour.gravatar,
        "version" => Bananajour::VERSION,
        "repositories" => repositories.collect do |r|
          {"name" => r.name}
        end
      }
    end
    
  end
  
end
