module Bananajour::Bonjour
  
  # methods that call Bonjour, and little model wrappers for the response packets
  
  class Repo
    attr_accessor :name, :email, :uri, :person 
    def initialize(hsh)
      hsh.each { |k,v| self.send("#{k}=", v) }
    end
    
    def html_friendly_name
      Bananajour::Repository.html_friendly_name(name)
    end

    def person=(hsh)
      @person = Person.new(hsh)
    end
    
    def ==(other)
      self.uri == other.uri
    end
    
    def hash
      to_hash.hash
    end
    
    def json_uri
      "#{person.uri}#{name}.json"
    end
    
    def web_uri
      "#{person.uri}"
    end
    
    def to_hash
      {
        "name" => name,
        "email" => email,
        "uri" => uri,
        "json_uri" => json_uri,
        "web_uri" => web_uri,
        "person" => person.to_hash
      }
    end
  end
  
  class Person
    attr_accessor :name, :email, :uri 
    def initialize(hsh)
      hsh.each { |k,v| self.send("#{k}=", v) }
    end
    
    def ==(other)
      self.uri == other.uri
    end
    
    def hash
      to_hash.hash
    end

    def to_hash
      {"name" => name, "email" => email, "uri" => uri}
    end
  end
  
  def advertise!
    puts "* Advertising on bonjour"
    tr = DNSSD::TextRecord.new
    tr["uri"] = web_uri
    tr["name"] = Bananajour.config.name
    tr["email"] = Bananajour.config.email
    DNSSD.register("#{config.name}'s bananajour", "_http._tcp,_bananajour", nil, web_port, tr) {}
  end
  
  def all_network_repositories
    @all_network_repositories ||= begin
      yaml = `#{Fancypath(__FILE__).dirname/'../../bin/bananajour'} network_repositories`
      YAML.load(yaml).map { |hsh| Repo.new(hsh) }
    end
  end
  
  def other_network_repositories
    @other_network_repositories ||= all_network_repositories.reject { |r| r.person.name == Bananajour.config.name }
  end

  def network_repositories_similar_to(repo)
    all_network_repositories.select { |nr| nr.name == repo.name }.uniq.sort_by { |nr| nr.person.name }
  end

  def all_people
    @all_people ||= begin
      yaml = `#{Fancypath(__FILE__).dirname/'../../bin/bananajour'} people`
      YAML.load(yaml).map { |hsh| Person.new(hsh) }
    end
  end
  
  def other_people
    @other_people ||= all_people.reject { |p| p.uri == self.web_uri }
  end
  
end