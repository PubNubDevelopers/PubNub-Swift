import UIKit
 import PubNub
 
 class PubNubPresence: NSObject {
 let client: PubNub
 let channel: String
 
 required init(channel: String) {
 self.client = PubNub.clientWithConfiguration(PNConfiguration(publishKey: "pub-c-782360a0-ace3-411a-9707-3dbcdc0b86a4", subscribeKey: "sub-c-5eb10e66-f816-11e8-8ebf-6a684a5fb351"))
 self.channel = channel
 super.init()
 }
 
 //
 func doSomething() {
 
 }
 }
 
 
 let presenceDemo = PubNubPresence(channel: "TestChannel") // Set channel.
 
 presenceDemo.doSomething() //
 
