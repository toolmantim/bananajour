libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'yaml'
require 'ostruct'

gem 'rainbow', '1.0.1'
require 'rainbow'

require 'socket'

gem 'dnssd', '0.7.1'
require 'dnssd'

require 'bananajour/repository'
require 'bananajour/grit_extensions'
require 'bananajour/version'
require 'bananajour/bonjour'
require 'bananajour/commands'

module Bananajour
  
  class << self
    
    include Bonjour
    include Commands
    
    def path
      Fancypath("~/.bananajour").expand_path
    end
    
    def env
      ENV['BANANA_ENV'] || 'production'
    end
    
    def config_path
      path/"config.yml"
    end
    
    def repositories_path
      path/"repositories"
    end
    
    def config
      OpenStruct.new(YAML.load(config_path.read))
    end
    
    def web_port
      env == 'production' ? 9331 : 1339
    end
    
    def web_uri
      "http://#{host_name}:#{web_port}/"
    end
    
    def host_name
      Socket.gethostname
    end
    
    def git_uri
      "git://#{host_name}/"
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
        "uri"  => web_uri,
        "git-uri" => git_uri,
        "repositories" => repositories.collect do |r|
          {"name" => r.name, "uri" => r.uri}
        end
      }
    end
    
  end
  
end