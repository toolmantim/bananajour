# Browsing for Bananajour instances via MacRuby

framework 'Cocoa'

NSApplication.sharedApplication

class BrowserDelegate
  def initialize
    @services = []
  end
  def netServiceBrowserWillSearch(browser)
    puts "Searching..."
  end
  def netServiceBrowser(browser, didFindService:service, moreComing:more)
    @services << service
    puts "Found service: #{service.name}"
  end
  def netServiceBrowser(browser, didRemoveService:service, moreComing:more)
    puts "Lost service: #{service.name}"
  end
  def netServiceBrowser(browser, didNotSearch:errorInfo)
    puts "Search error: #{errorInfo}"
  end
end

browser = NSNetServiceBrowser.new
browser.delegate = BrowserDelegate.new
browser.searchForServicesOfType("_http._tcp,_bananajour", inDomain:"")

NSApp.run
