import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true // Needed in playground to wait for messages.

import PubNub;

class PubNubPublisher: NSObject {
    let client: PubNub
    let channel: String
    
    required init(channel: String) {
        self.client = PubNub.clientWithConfiguration(PNConfiguration(
            publishKey: "pub-c-26d14f06-e4b4-4541-b8b5-a878f51aaaf5",
            subscribeKey: "sub-c-ae65a0e0-501b-11e9-8d60-1a250947a5a3"))
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
publisher.publish(message: "Hello from the PubNub Swift SDK!") // Publish a message.

/*
 // Send 200 messages. Useful to test history api.
 for i in 1...200 {
 publisher.publish(message: "Test message #"+String(i)) // Publish a message
 usleep(25000)
 }
 */
