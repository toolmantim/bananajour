class Bananajour::Bonjour::Repository

  attr_accessor :name, :uri, :person

  def initialize(name, uri, person)
    @name, @uri, @person = name, uri, person
  end

  def html_id
    Bananajour::Repository.html_id(name)
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
    "#{person.uri}##{html_id}"
  end

  def to_hash
    {
      "name" => name,
      "uri" => uri,
      "json_uri" => json_uri,
      "web_uri" => web_uri,
      "person" => person.to_hash
    }
  end

end