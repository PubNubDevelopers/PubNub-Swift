import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true // Needed in playground to wait for messages.

import PubNub

class PubNubPublisher: NSObject {
    let client: PubNub
    let publishChannel: String
    
    required init(publishChannel: String) {
        self.client = PubNub.clientWithConfiguration(PNConfiguration(publishKey: "pub-c-782360a0-ace3-411a-9707-3dbcdc0b86a4", subscribeKey: "sub-c-5eb10e66-f816-11e8-8ebf-6a684a5fb351"))
        self.publishChannel = publishChannel
        super.init()
    }
    
    func publish(message: String?) {
        guard let publishString = message else { 
            print("Nothing to publish")
            return
        }
        client.publish(publishString, toChannel: self.publishChannel) { (status) in
            if status.isError {
                // Handle message publish error.
                // Request can be resent using: status.retry()
                print("Error publishing message: \(publishString)")
            } else {
                // Message was successfully published.
                print("Successful publish of message: \(publishString)")
            }
        }
    }
}
let publisher = PubNubPublisher(publishChannel: "channeltestu")

class PubNubSubscriber: PubNubPublisher, PNObjectEventListener {
    
    required init(publishChannel: String) {
        super.init(publishChannel: publishChannel)
        client.addListener(self)
        client.subscribeToChannels([self.publishChannel], withPresence: false)
    }
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        // Unwrap message payload.
        guard let receivedMessage = message.data.message else {
            print("No message payload received")
            return
        }
        
        print("Received message: \(receivedMessage) on channel " +
            "\((message.data.subscription ?? message.data.channel)!) at time: " +
            "\(message.data.timetoken)")
    }
}

let subscriber = PubNubSubscriber(publishChannel: "channeltestu") //
publisher.publish(message: "Hello from the PubNub Swift SDK!") // Publish a message

for i in 100...500 {
    publisher.publish(message: String(i)+" pn") // Publish a message
    usleep(25000)
}
