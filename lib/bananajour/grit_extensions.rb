require 'md5'

Grit::Commit.class_eval do
  def ==(other)
    self.id == other.id
  end
end

Grit::Actor.class_eval do
  def gravatar_uri
    Bananajour.gravatar_uri(email)
  end
end
