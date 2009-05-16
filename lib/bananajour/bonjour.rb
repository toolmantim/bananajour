module Bananajour::Bonjour
  
  # methods that call Bonjour, and little model wrappers for the response packets
  
  class Repo
    attr_accessor :name, :uri, :person 
    def initialize(hsh)
      hsh.each { |k,v| self.send("#{k}=", v) }
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
  
  def network_repositories
    hosts = []
    service = DNSSD.browse("_git._tcp") do |reply|
      DNSSD.resolve(reply.name, reply.type, reply.domain) do |rr|
        r = Repo.new(
          :uri => rr.text_record["uri"], 
          :name => rr.text_record["name"], 
          :person => Person.new(:name => rr.text_record["bjour-name"], :uri => rr.text_record["bjour-uri"])
        )
        hosts << r unless hosts.include?(r)
      end
    end
    sleep 0.5
    service.stop
    hosts
  end
  
  def people
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

  def other_people
    people.reject { |p| p.uri == self.web_uri }
  end
  
end