module Bananajour::Bonjour
class BananajourBrowser

  def initialize
    @browser = Browser.new('_http._tcp,_bananajour')
  end

  def bananajours
    @browser.replies.map do |reply|
      Person.new(
        reply.text_record["name"],
        reply.text_record["email"],
        reply.text_record["uri"],
        reply.text_record["gravatar"]
      )
    end
  end

  def other_bananajours
    bananajours.reject {|b| b.uri == Bananajour.web_uri}
  end

end
end
