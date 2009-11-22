module Bananajour::Bonjour
class BananajourBrowser

  def initialize
    @browser = Browser.new("_http._tcp,#{Bananajour.service_id}")
  end

  def bananajours
    @browser.replies.map do |reply|
      Person.new(
        reply.text_record["name"],
        reply.text_record["email"],
        reply.target,
        reply.text_record["gravatar"]
      )
    end
  end
  
end
end
