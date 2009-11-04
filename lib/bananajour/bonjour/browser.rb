Bananajour.require_gem 'dnssd'

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
    @replies = []
    watch!
  end
  def replies
    @mutex.synchronize do
      @replies.clone
    end
  end
  private
    def watch!
      Thread.new do
        while true do
          begin
            DNSSD.browse!(@service) do |br|
              begin
                DNSSD.resolve!(br) do |rr|
                  begin
                    @mutex.synchronize do
                      rr_exists = Proc.new {|existing_rr| existing_rr.target == rr.target && existing_rr.fullname == rr.fullname}
                      if (DNSSD::Flags::Add & br.flags.to_i) != 0
                        @replies << rr unless @replies.any?(&rr_exists)
                      else
                        @replies.delete_if(&rr_exists)
                      end
                    end
                  ensure
                    rr.service.stop unless rr.service.stopped?
                  end
                end
              end
            end
          rescue DNSSD::UnknownError
            $stderr.puts "unknown error in DNSSD: '#{$!.message}'"
          end
          sleep 5
        end
      end
    end
end
