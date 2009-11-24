# Advertising a Bananajour instance via MacRuby

framework 'Cocoa'

NSApplication.sharedApplication

service = NSNetService.alloc.initWithDomain("",
  type:"_http._tcp,_bananajour",
  name:"Tim Lucas's Bananajour",
  port:9331
)

service.TXTRecordData = NSNetService.dataFromTXTRecordDictionary({
  "someKey" => "someValue"
})

service.publish

NSApp.run
