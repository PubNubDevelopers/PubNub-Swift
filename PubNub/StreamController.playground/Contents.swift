import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true // Needed in playground to wait for messages.

import PubNub;

class PubNubPublisher: NSObject {
    let client: PubNub
    let channel: String
    
    required init(channel: String) {
        self.client = PubNub.clientWithConfiguration(PNConfiguration(
            publishKey: "YOUR_PUB_KEY_HERE",
            subscribeKey: "YOUR_SUB_KEY_HERE"))
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
        client.subscribeToChannels([self.channel], withPresence: false)
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

class PubNubGroupSubscriber: PubNubPublisher, PNObjectEventListener {
    
    required init(channel: String) {
        super.init(channel: channel)
        client.addListener(self)
        client.subscribeToChannelGroups([self.channel], withPresence: true)
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


// 1. Subscribe to a wildcard channel and a channel group:
let subscriberWild = PubNubSubscriber(channel: "one.*") // Subscribe for messages.
let subscriberGroup = PubNubGroupSubscriber(channel: "ChannelGroup") // Subscribe for messages.
// 2. Publish to the wildcard.
let PubNubPublisherWild = PubNubPublisher(channel: "one.two")
PubNubPublisherWild.publish(message: "[one.two]: Test.") // Publish a message.
// 3. Publish to the wildcard again but at the second level (This is the max depth).
let PubNubPublisherWildDeep = PubNubPublisher(channel: "one.two.three")
PubNubPublisherWildDeep.publish(message: "[one.two.three]: Test.") // Publish a message.
// 4. Add a channel to "ChannelGroup" so we can receive messages from it:
subscriberGroup.client.addChannels(["TestChannel"], toGroup: "ChannelGroup", withCompletion: { (status) in
    if !status.isError {
        // Handle successful channels list modification for group.
    }
    else {
        /**
         Handle channels list modification for group error. Check 'category' property
         to find out possible reason because of which request did fail.
         Review 'errorData' property (which has PNErrorData data type) of status
         object to get additional information about issue.
         Request can be resent using: status.retry()
         */
    }
})
// 5. Publish to "TestChannel" inside "ChannelGroup".
let PubNubPublisherGroupChild = PubNubPublisher(channel: "TestChannel")
PubNubPublisherGroupChild.publish(message: "Channel group test.") // Publish a message.
