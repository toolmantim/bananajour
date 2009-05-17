module Bananajour::Bonjour
  
  # methods that call Bonjour, and little model wrappers for the response packets
  
  class Repo
    attr_accessor :name, :uri, :person 
    def initialize(hsh)
      hsh.each { |k,v| self.send("#{k}=", v) }
    end
    
    def html_friendly_name
      name.gsub(/^[A-Za-z]+/, '')
    end

    def person=(hsh)
      @person = Person.new(hsh)
    end
    
    def ==(other)
      self.uri == other.uri
    end
    
    alias_method :bananajour, :person
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
  
  def advertise!
    puts "* Advertising on bonjour"

    tr = DNSSD::TextRecord.new
    tr["uri"] = web_uri
    tr["name"] = Bananajour.config.name
    DNSSD.register("#{config.name}'s bananajour", "_bananajour._tcp", nil, web_port, tr) {}
  end
  
  def network_repositories(include_local=true)
    yaml = `#{Fancypath(__FILE__).dirname/'../../bin/bananajour'} network_repositories`
    YAML.load(yaml).map { |hsh| Repo.new(hsh) }.reject { |r| !include_local && r.person.name == Bananajour.config.name }
  end

  def self.network_repositories_similar_to(repo)
    Bananajour.network_repositories.select { |nr| nr.name == repo.name && nr.uri != repo.uri }.uniq.sort_by { |nr| nr.person.name }
  end

  def self.yet_uncloned_network_repositories
    local_repo_names = Bananajour.repositories.map { |repo| repo.name }
    Bananajour.network_repositories.select { |remote| !local_repo_names.include? remote.name }.uniq.sort_by { |nr| nr.bananajour.name }
  end

  def people(include_local=true)
    yaml = `#{Fancypath(__FILE__).dirname/'../../bin/bananajour'} people`
    YAML.load(yaml).map { |hsh| Person.new(hsh) }.reject { |p| !include_local && p.name == Bananajour.config.name }
  end

  def other_people
    people.reject { |p| p.uri == self.web_uri }
  end
  
end