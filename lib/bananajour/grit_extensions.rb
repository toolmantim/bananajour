require 'md5'

Grit::Commit.class_eval do
  def ==(other)
    self.id == other.id
  end
  def head(repo)
    repo.heads.find {|h| h.commit == self}
  end
end

Grit::Actor.class_eval do
  def gravatar_image
    "http://www.gravatar.com/avatar/#{MD5.md5(email.downcase)}"
  end
end
