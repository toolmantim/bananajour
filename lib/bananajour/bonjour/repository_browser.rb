module Bananajour::Bonjour
class RepositoryBrowser

  def initialize
    @browser = Browser.new("_git._tcp,#{Bananajour.service_id}")
  end

  def repositories
    @browser.replies.map do |reply|
      
      Repository.new(
        reply.text_record["name"],
        Person.new(
          reply.text_record["bjour-name"],
          reply.text_record["bjour-email"],
          reply.target,
          reply.text_record["bjour-gravatar"]
        )
      )
    end
  end
  
  def other_repositories
    repositories.reject {|r| Bananajour.repositories.any? {|my_rep| my_rep.name == r.name}}
  end
  
  def repositories_similar_to(repository)
    repositories.select {|r| r.name == repository.name}
  end
  
  def repositories_for(person)
    repositories.select {|r| r.person == person}
  end
  
end
end
