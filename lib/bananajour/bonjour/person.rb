class Bananajour::Bonjour::Person

  attr_accessor :name, :email, :uri 

  def initialize(name, email, uri)
    @name, @email, @uri = name, email, uri
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
