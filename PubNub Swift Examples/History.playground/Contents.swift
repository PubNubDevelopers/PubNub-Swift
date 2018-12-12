import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true // Needed in playground to wait for messages.

import PubNub

class PubNubHistorian: NSObject {
    let client: PubNub
    let historyChannel: String
    
    required init(historyChannel: String) {
        self.client = PubNub.clientWithConfiguration(PNConfiguration(publishKey: "pub-c-782360a0-ace3-411a-9707-3   dbcdc0b86a4", subscribeKey: "sub-c-5eb10e66-f816-11e8-8ebf-6a684a5fb351"))
        self.historyChannel = historyChannel
        super.init()
    }
    
    func fetchLast() {
        self.client.historyForChannel(self.historyChannel, start: nil, end: nil, limit: 1, withCompletion: { (result, status) in
            if status == nil {
                print(result!.data.messages)
                /**
                 Handle downloaded history using:
                 result.data.start - oldest message time stamp in response
                 result.data.end - newest message time stamp in response
                 result.data.messages - list of messages
                 */
            }
            else {
                
                /**
                 Handle message history download error. Check 'category' property
                 to find out possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.
                 
                 Request can be resent using: status.retry()
                 */
            }
        })
    }
    
    func historyNewerThen(_ date: NSNumber, withCompletion closure: @escaping (Array<Any>) -> Void) {
        
        var msgs: Array<Any> = []
        self.historyNewerThen(date, withProgress: { (messages) in
            
            msgs.append(contentsOf: messages)
            if messages.count < 100 { closure(msgs) }
        })
    }
    
    private func historyNewerThen(_ date: NSNumber, withProgress closure: @escaping (Array<Any>) -> Void) {
        
        self.client.historyForChannel(self.historyChannel, start: date, end: nil, limit: 100,
                                       reverse: false, withCompletion: { (result, status) in
                                        
                                        if status == nil {
                                            
                                            closure((result?.data.messages)!)
                                            if result?.data.messages.count == 100 {
                                                
                                                self.historyNewerThen((result?.data.end)!, withProgress: closure)
                                            }
                                        }
                                        else {
                                            
                                            /**
                                             Handle message history download error. Check 'category' property
                                             to find out possible reason because of which request did fail.
                                             Review 'errorData' property (which has PNErrorData data type) of status
                                             object to get additional information about issue.
                                             
                                             Request can be resent using: [status retry];
                                             */
                                        }
        })
    }

}
let historian = PubNubHistorian(historyChannel: "channel500")

historian.fetchLast() // Request last message from history.

// Pull out all messages newer then message sent at 15445546833194000.
let date = NSNumber(value: (15445683836084000 as CUnsignedLongLong));
historian.historyNewerThen(date, withCompletion:  { (messages) in
    print("Messages from history: \(messages)")
})

