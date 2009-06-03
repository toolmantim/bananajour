# Mocks for emulating lots of people on the network

# Mock out the repositories method
module Bananajour::Bonjour
class RepositoryBrowser
  def initialize
  end
  def repositories
    [
      ["bananajour", "Tim Lucas"],
      ["bananajour", "Myles Byrne"],
      ["bananajour", "Josh Bassett"],
      ["bananajour", "Ben Schwarz"],
      ["bananajour", "John Barton"],
      ["bananajour", "Dan Neighman"],
      ["bananajour", "Jason Crane"],
      ["bivouac", "Phil Oye"],
      ["bivouac", "Lachlan Hardy"],
      ["rubystein", "Dave Newman"],
      ["rubystein", "Tim Lucas"],
      ["rubystein", "Lachlan Hardy"],
      ["rubystein", "Grant Bissett"],
      ["tweeter", "Jason Crane"],
    ].map do |(repo_name, person_name)|
      person = BananajourBrowser.new.bananajours.find {|p| p.name == person_name}
      Repository.new(repo_name, "#{person.uri}##{repo_name}", person)
    end
  end
end
end

# Mock out the bananajours method
module Bananajour::Bonjour
class BananajourBrowser
  def initialize
  end
  def bananajours
    [
      ["Tim Lucas",     "http://gravatar.com/avatar/8b3a5fa50d63275c5c6e304f1a081bfb"],
      ["Myles Byrne",   "http://gravatar.com/avatar/080969c20d036124efa1cafcef29e8c6"],
      ["Phil Oye",      "http://gravatar.com/avatar/0891cd6569508d63a64557d287672815"],
      ["Josh Bassett",  "http://gravatar.com/avatar/128a23ed95e352275c88fcb39c888932"],
      ["Ben Schwarz",   "http://gravatar.com/avatar/42e2ec6a72627f8c15115e279a5f7d8e"],
      ["John Barton",   "http://gravatar.com/avatar/fddf4352c67c74b5fcadfdbefed7e7f1"],
      ["Dan Neighman",  "http://gravatar.com/avatar/9d1f5d2d9de70bd9a934f557dc95a406"],
      ["Dave Newman",   "http://gravatar.com/avatar/094e5cf16c5281ce8bd89952fcf9627c"],
      ["Grant Bissett", "http://gravatar.com/avatar/ce57bc53aa963491eb1e29a54ccb8872"],
      ["Lachlan Hardy", "http://gravatar.com/avatar/c21994a72009ac4d4278b5dc11617696"],
      ["Jason Crane",   "http://gravatar.com/avatar/f222a34258d55a40420ed8e987de4831"]
    ].map do |(name, gravatar)|
      Person.new(name, "blah@blah.com", "http://#{name.split.first.downcase}.local:4567/", gravatar)
    end
  end
end
end
