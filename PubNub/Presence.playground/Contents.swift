import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true // Needed in playground to wait for messages.

import PubNub

class PubNubPresence: NSObject, PNObjectEventListener {
    let client: PubNub
    let channel: String
    
    required init(channel: String) {
        let config = PNConfiguration(
            publishKey: "YOUR_PUB_KEY_HERE",
            subscribeKey: "YOUR_SUB_KEY_HERE")
        config.uuid = "DEMO-UUID" // Comment to allow PubNub to create UUID.
        self.client = PubNub.clientWithConfiguration(config)
        self.channel = channel
        super.init()
        client.subscribeToPresenceChannels([self.channel])
        client.subscribeToChannels([self.channel], withPresence: true)
        client.addListener(self)
    }
    
    // Presence event handling.
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout, state-change).
        if event.data.channel != event.data.subscription {
            // Presence event has been received on channel group stored in event.data.subscription.
        }
        else {
            // Presence event has been received on channel stored in event.data.channel.
        }
        if event.data.presenceEvent != "state-change" {
            print("\n\(event.data.presence.uuid ?? "N/A") \"\(event.data.presenceEvent)\" " +
                "at: \(event.data.presence.timetoken) on \(event.data.channel) " +
                "(Occupancy: \(event.data.presence.occupancy))");
            if ((event.data.presence.uuid == self.client.uuid()) && (String(describing: event.data.channel) == self.channel) && (String(describing: event.data.presenceEvent) == "join"))  {
                
                // Now that our UUID has joined, demo presence features:
                self.myUUID() // Print the current UUID.
                sleep(1)
                self.whereNow() // Which channel(s) is UUID on right now.
                self.hereNow() // Get a list of who is here now for a given channel.
                self.golbalHereNow() // Get a list of everyone on every channel.
                self.setState() // Set custom presence key/value pairs for a specific UUID. Calls getState() after set.
                // self.getState() // Get custom presence key/value pairs for a specific UUID.
                sleep(1)
                self.client.unsubscribeFromChannels([self.channel], withPresence: true) // Unsubscribe from channel.
                
            }
        }
        else {
            print("\n\(event.data.presence.uuid  ?? "N/A") changed state at: " +
                "\(event.data.presence.timetoken) on \(event.data.channel) to:" +
                "\(String(describing: event.data.presence.state))");
        }
    }
    
    // Print the current UUID.
    func myUUID() {
        print("\nYour UUID is: ")
        print(self.client.uuid());
    }
    
    // Which channel(s) is UUID on right now.
    func whereNow() {
        self.client.whereNowUUID(self.client.uuid(), withCompletion: { (result, status) in
            if status == nil {
                print("\nWhere Now: ")
                print("Channels: \(result!.data.channels)")
                // Handle downloaded presence 'where now' information using: result.data.channels
            }
            else {
                /**
                 Handle presence audit error. Check 'category' property
                 to find out possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.
                 Request can be resent using: status.retry()
                 */
            }
        })
    }
    
    // Get a list of who is here now for a given channel.
    func hereNow() {
        self.client.hereNowForChannel(self.channel, withCompletion: { (result, status) -> Void in
            if status == nil {
                print("\nHere Now: ")
                print("Occupancy: \(result!.data.occupancy), UUIDs: \(result!.data.uuids ?? "N/A")")
                /**
                 Handle downloaded presence information using:
                 result.data.uuids - list of uuids.
                 result.data.occupancy - total number of active subscribers.
                 */
            }
            else {
                /**
                 Handle presence audit error. Check 'category' property to find
                 out possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.
                 Request can be resent using: status.retry()
                 */
            }
        })
    }
    
    // Get a list of everyone on every channel.
    func golbalHereNow() {
        self.client.hereNowWithCompletion({ (result, status) in
            if status == nil {
                print("\nGlobal Here Now: ")
                print("Occupancy: \(result!.data)")
                /**
                 Handle downloaded presence information using:
                 result.data.channels - dictionary with active channels and presence
                 information on each. Each channel will have
                 next fields: "uuids" - list of subscribers;
                 "occupancy" - number of active subscribers.
                 Each uuids entry has next fields:
                 "uuid" - identifier and "state" if it has been
                 provided.
                 result.data.totalChannels - total number of active channels.
                 result.data.totalOccupancy - total number of active subscribers.
                 */
            }
            else {
                /**
                 Handle presence audit error. Check 'category' property
                 to find out possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.
                 Request can be resent using: status.retry()
                 */
            }
        })
    }
    
    // Set custom presence key/value pairs for a specific UUID.
    func setState() {
        self.client.setState(["Ready": "True"], forUUID: self.client.uuid(), onChannel: self.channel, withCompletion: { (status) in
            if !status.isError {
                // Client state successfully modified on specified channel.
                print("\nState Set for UUID: \(self.client.uuid())")
                self.getState() // Get custom presence key/value pairs for a specific UUID.
            }
            else {
                /**
                 Handle client state modification error. Check 'category' property
                 to find out possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.
                 Request can be resent using: status.retry()
                 */
            }
        })
    }
    
    // Get custom presence key/value pairs for a specific UUID.
    func getState() {
        self.client.stateForUUID(self.client.uuid(), onChannel: self.channel, withCompletion: { (result, status) in
            if status == nil {
                print("\nGet State: ")
                print("\(result!.data.state)")
                // Handle downloaded state information using: result.data.state
            }
            else{
                /**
                 Handle client state audit error. Check 'category' property
                 to find out possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.
                 Request can be resent using: status.retry()
                 */
            }
        })
        
    }
}

let presenceDemo = PubNubPresence(channel: "TestPresence") // Set channel.
