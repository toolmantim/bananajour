module Bananajour::Bonjour
class RepositoryBrowser

  def initialize
    @browser = Browser.new('_bananajour._git._tcp')
  end
  
  def repositories
    @browser.replies.map do |reply|
      Repository.new(
        reply.text_record["name"],
        reply.text_record["uri"],
        Person.new(
          reply.text_record["bjour-name"],
          reply.text_record["bjour-email"],
          reply.text_record["bjour-uri"]
        )
      )
    end
  end
  
  def repositories_similar_to(repository)
    repositories.select {|r| r.name == repository.name}
  end
  
end
end
