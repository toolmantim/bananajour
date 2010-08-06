require 'dnssd'

require 'thread'
require 'timeout'

Thread.abort_on_exception = true

# Generic bonjour browser
#
# Example use:
#
#   browser = BonjourBrowser.new("_git._tcp,_bananajour")
#   loop do
#     sleep(1)
#     pp browser.replies.map {|r| r.name}
#   end
#
# Probably gem-worthy
class Bananajour::Bonjour::Browser
  def initialize(service)
    @service = service
    @mutex = Mutex.new
    @replies = {}
    watch!
  end
  def replies
    @mutex.synchronize { @replies.values }
  end
  private
    def watch!
      Thread.new(@service, @mutex, @replies) do |service, mutex, replies|
        begin
          DNSSD.browse!(service) do |reply|
            Thread.new(reply, replies, mutex) do |reply, replies, mutex|
              begin
                DNSSD.resolve!(reply.name, reply.type, reply.domain) do |resolve_reply|
                  mutex.synchronize do
                    if reply.flags.add?
                      replies[reply.fullname] = resolve_reply
                    else
                      replies.delete(reply.fullname)
                    end
                  end
                  resolve_reply.service.stop unless resolve_reply.service.stopped?
                end
              rescue DNSSD::BadParamError
                # Ignore em
              end
            end
          end
        rescue DNSSD::BadParamError
          # Ignore em
        end
      end
    end
end