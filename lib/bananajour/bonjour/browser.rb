Bananajour.require_gem 'dnssd'

require 'thread'

# Generic bonjour browser
#
# Example use:
# 
#   browser = BonjourBrowser.new("_bananajour._git._tcp")
#   loop do
#     sleep(1)
#     pp browser.replies.map {|r| r.name}
#   end
#
# Probably gem-worthy
class Bananajour::Bonjour::Browser
  attr_reader :replies
  def initialize(service)
    @service = service
    @mutex = Mutex.new
    @replies = []
    watch!
  end
  private
    def watch!
      DNSSD.browse(@service) do |br|
        DNSSD.resolve(br.name, br.type, br.domain) do |rr|
          @mutex.synchronize do
            if (DNSSD::Flags::Add & br.flags.to_i) != 0
              @replies << rr
            else
              @replies.delete_if do |existing_rr|
                existing_rr.target == rr.target && existing_rr.fullname == rr.fullname
              end
            end
          end
        end
      end
    end
end
