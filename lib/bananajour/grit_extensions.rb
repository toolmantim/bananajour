require 'md5'

Grit::Actor.class_eval do
  def gravatar_image
    "http://www.gravatar.com/avatar/#{MD5.md5(email.downcase)}"
  end
end
