class Bananajour::Bonjour::Person

  attr_accessor :name, :email, :host , :gravatar

  def initialize(name, email, host, gravatar)
    @name, @email, @host, @gravatar = name, email, host, gravatar
  end
  
  def uri
    "http://#{host}:#{Bananajour.web_port}/"
  end
  
  def ==(other)
    self.host == other.host
  end
  
  def hash
    to_hash.hash
  end
  
  def to_hash
    {"name" => name, "email" => email, "uri" => uri, "gravatar" => gravatar}
  end
  
end
