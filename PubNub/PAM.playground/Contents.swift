import UIKit
import PlaygroundSupport
//PlaygroundPage.current.needsIndefiniteExecution = true // Needed in playground to wait for messages.

import PubNub;

class PubNubPublisher: NSObject {
    let client: PubNub
    let channel: String
    
    required init(channel: String) {
        let config = PNConfiguration(
            publishKey: "YOUR_PUB_KEY_HERE",
            subscribeKey: "YOUR_SUB_KEY_HERE")
        // config.authKey = "my-password-12345" // Uncomment to test using auth key.
        self.client = PubNub.clientWithConfiguration(config)
        self.channel = channel
        super.init()
    }
    
    func publish(message: String?) {
        guard let publishString = message else {
            print("Nothing to publish")
            return
        }
        client.publish(publishString, toChannel: self.channel) { (status) in
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

class PubNubSubscriber: PubNubPublisher, PNObjectEventListener {
    
    required init(channel: String) {
        super.init(channel: channel)
        client.addListener(self)
        client.subscribeToChannels([self.channel], withPresence: true)
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

let subscriber = PubNubSubscriber(channel: "TestChannel") // Subscribe for messages.

let publisher = PubNubPublisher(channel: "TestChannel")

/*
 // Javascript code to issue grant:
 pubnub.grant({
    channels: "TestChannel",
    read: true,   // true to grant, false to revoke
    write: true, // true to grant, false to revoke
    ttl: 0,           // Time to live in minutes, 0 for permanent.
 }, (status, response) => { console.log(status, response); });
 
*/
/*
 1. Restricted with channel + password grant.
 2. Try publishing without uncommenting authKey above.
 3. Try again with authKey set.
*/

publisher.publish(message: "Hello from the PubNub Swift SDK!") // Publish a message.
