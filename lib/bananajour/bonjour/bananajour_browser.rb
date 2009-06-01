module Bananajour::Bonjour
class BananajourBrowser

  def initialize
    @browser = Browser.new('_bananajour._http._tcp')
  end
  
  def bananajours
    @browser.replies.map do |reply|
      Person.new(
        reply.text_record["name"],
        reply.text_record["email"],
        reply.text_record["uri"]
      )
    end
  end
  
end
end
