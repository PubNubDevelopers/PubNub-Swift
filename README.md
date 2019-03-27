# PubNub Swift Demos
This repo contains Swift playgrounds to demo the PubNub Swift SDK features. Included in this repo are Swift demos for:
- [Publish and Subscribe](https://www.pubnub.com/docs/swift/data-streams-publish-and-subscribe)
- [Storage and Playback](https://www.pubnub.com/docs/swift/storage-and-history)
- [Presence](https://www.pubnub.com/docs/swift/presence)
- [Stream Controller](https://www.pubnub.com/docs/swift/stream-controller)
- [Access Manager](https://www.pubnub.com/docs/swift/pam-security)

### Running Playgrounds
1. Make sure to add your keys from the [PubNub Dashboard](https://dashboard.pubnub.com).
2. Click on "PubNub.xcodeproj" in the project explorer and press Command + Option + Shift + K. 
3. Press Command + B.
4. Select the playground you want to demo.
5. Press the right-facing blue arrow at the bottom of the Xcode window to run the playground.

## [Publish and Subscribe Playground](https://github.com/chandler767/PubNub-Swift/blob/master/PubNub%20Demo/PubSub.playground/Contents.swift)

You can have many or just one internet connected device publishing and subscribing to messages with an always on connection. Messages can contain whatever type on content you want up to 32 kilobytes.

### In this playground:
- First a client is created for the PubNub configuration using PubNub api keys.
- Then a publish function that accepts a string a message.
- Finally a listener to subscribe to a channel and receive messages sent while printing them to the console output.
  
When the script is run the subscribe listener is started and a message is published to the “TestChannel” channel. Any other device subscribed to “TestChannel” and using the same API keys will receive this message in realtime. If another user was running this same script on the other side of the planet they would receive the same messages in realtime.

PubNub is completely free up to one million messages a month.


## [Storage and Playback Playground](https://github.com/chandler767/PubNub-Swift/tree/master/PubNub%20Demo/History.playground)

Once messages have been sent on the PubNub data stream network you can retrieve them later with the History API. Message can be sent with a time to live or stored indefinitely. Messages can be deleted.

**You must enable Storage and Playback for your api keys.** To enable storage and playback and set the time to live for your messages visit: **[dashboard.pubnub.com](https://dashboard.pubnub.com)**.

### In this playground:
- First a client is created for the PubNub configuration using PubNub api keys.
- Then a function to retrieve the last 10 messages from a channel. 
- Notice how the start and end values are set to nil. If you defined these values, only a messages within that time slice would be returned.
- Next a function to retrieve messages since a time. If over 100 messages are returned then a subsequent fetch is made. This code can be dangerous on client devices if the message volume is high because it may crash your program.
- Use the Publish and Subscribe demo to [publish 200 messages](https://github.com/chandler767/PubNub-Swift/blob/916230cf6642dcbd6c28565ac73dc523c2767a96/PubNub%20Demo/PubSub.playground/Contents.swift#L65) to try these functions.
- If you run the fetchlast10() function you’ll get a list of the last 10 messages in the console.
- If you run the historyNewerThen() function with the start time set so as to include all messages you will get all 200 messages printed in the console.
- An empty array will be returned if there were no messages ever sent to the channel.

This message functionality is ideal for chat applications. When a user opens a chat application the client can download the messages previously sent while the user was offline.


## [Presence Playground](https://github.com/chandler767/PubNub-Swift/blob/master/PubNub%20Demo/Presence%20.playground/Contents.swift)

The Presence API provides an easy way to determine what users or devices are subscribed to your PubNub channels. Presence has 5 client events that will fire for every subscriber on your PubNub keyset: Join, leave, timeout, Set state, and interval. You can register an event handler for each of these events. The event methods provide information like the users UUID and custom state object.

When you initialize the PubNub SDK you can specify a heartbeat interval. Heartbeats are messages sent to tell PubNub a client is still connected. If a heartbeat message is not sent before the interval, a timeout fires for that device UUID.

Set state is an event that fires when a users state has been set. All channel subscribers will receive the event.

Interval is an announcement of how many users are currently in a channel. The interval event will be sent if the number of subscribers exceeds the announce max number. The announce max and interval values are set for an entire keyset in your Pubnub dashboard and not in the client code.

There are 4 accessor methods that allow you to ask for subscriber details like the members in a channel and their state objects.

The one mutator is the setstate() method that allows you to pass a custom object. Setting the users state will fire a set state event to all subscribers.

**You must enable Presence for your api keys.** To enable Presence visit: **[dashboard.pubnub.com](https://dashboard.pubnub.com)**.

### In this playground:
- First a client is created for the PubNub configuration using PubNub api keys with a manually set UUID. Notice that when you subscribe to a channel you must set presence to true.
- Next is a presence event handler that will print events to the console. When our user has successfully subscribed to a channel functions will be called to print out the user's UUID, a list of which channel(s) the UUID is on right now, a list of who is here now for the given channel, a list of everyone on every channel, a state set event for our UUID, and the custom state for our UUID.

PubNub presence makes online user information easy to obtain so you can build online user functionality into your chat applications, smart devices, or fleet management application.


## [Stream Controller Playground](https://github.com/chandler767/PubNub-Swift/blob/master/PubNub%20Demo/StreamController.playground/Contents.swift)

Stream controller allows you to have more control over your message topology with features like multiplexing, channel wildcards, and channel groups. PubNub data streams often need to be restricted so that only certain groups receive information. 

Multiplexing allows a client to be subscribed to multiple channels at once. Multiplexing is enabled by default. 

A client can subscribe to up to 50 channels at one. If a client needs to subscribe to more than 50 channels you can use wildcard subscribe or channel groups.

Wilcard channels are many channels in one. In a game you could use channel wildcards to make sure that game updates make it to everyone, but team updates only go to that specific team. Think of wildcard channels as having a tree structure with a maximum height of 3. Each node can have an unlimited number of children up to the maximum string limit of 92. Subscribing to a wildcard counts as one subscribe with the client listening to all channels fitting the wildcard description.

Channel groups are a single subscribe that listens to multiple channels. Any user of your keyset can create a channel group containing up to 2000 channels and subscribe to it. A client can be subscribed to a maximum of 10 channel groups at one time per connection. A keyset can have an unlimited amount of channel groups.

The List Channels getter method returns a list of channels in a group.

 Add Channels, Remove Channels, and Delete Group are the 3 setter methods for channel group maintenance.
 
 **You must enable Stream Controller for your api keys.** To enable Stream Controller visit: **[dashboard.pubnub.com](https://dashboard.pubnub.com)**.

### In this playground:
- First a client is created for the PubNub configuration using PubNub api keys.
- Subscribe to a wildcard channel and a channel group.
- Publish to a channel on the first level of a wildcard channel and then again on the second level. This is the maximum depth of a wildcard channel.
- Then add a channel to our group channel with the Add Channels method. Publish a message to the channel we added.

Using PubNubs stream controller you can ensure that messages always reach the right clients in your dating app, realtime multiplayer game, or pizza delivery tracker. 


## [Access Manager Playground](https://github.com/chandler767/PubNub-Swift/blob/master/PubNub%20Demo/PAM.playground/Contents.swift)

With Access Manager you can restrict reading and writing messages on PubNub. You can restrict access on a key level, on the channel level, or with an access token.

As your apps administrator you’ll need to be the one to grants and restricts access to client. This can be done using the Grant method available in other PubNub SDKs. The PubNub Swift SDK does not yet include the Grant API call because it is intended only for client applications.

You can only make grants if the PubNub client is connected with your secret key. The secret key is added with the subscribe and publish keys when you initialize a client. You should only initialize with a secret key in secure server instance of pubnub or in a PubNub serverless environment.

Client devices can always connect without the secret key but they won’t be able to make grants. Users with the secret key can revoke reading and writing messages for the entire keyset, channels or channel groups, and for users with specific auth keys.

Grants can be issued with a TTL in minutes or they can be made permanent.

Grants make PubNub work well with 0Auth applications. On your server you can grant a users auth token after a login provider makes a callback to your server.

 **You must enable Access Manager for your api keys.** To enable Access Manager visit: **[dashboard.pubnub.com](https://dashboard.pubnub.com)**.

### In this playground:
- On a secure server [issue a grant](https://github.com/chandler767/PubNub-Swift/blob/d158fb684232457c16d6b739f951505d6f8c62f6/PubNub%20Demo/PAM.playground/Contents.swift#L66) to restrict reading and writing to users with a key.
- If you attempt to publish a message without setting the key you’ll receive an error.
- If you set the auth key and try again the message will be successfully sent.

You can use Access Manager to restrict access to services, create 1 to 1 chats, or ban users from game lobbies.
