# PubNub Swift Demos
This repo contains Swift playgrounds to demo the PubNub Swift SDK features. Included in this repo are Swift demos for:
- [Publish and Subscribe](https://www.pubnub.com/docs/swift/data-streams-publish-and-subscribe)
- [Storage and Playback](https://www.pubnub.com/docs/swift/storage-and-history)
- [Presence](https://www.pubnub.com/docs/swift/presence)
- [Stream Controller](https://www.pubnub.com/docs/swift/stream-controller)
- [Access Manager](https://www.pubnub.com/docs/swift/pam-security)

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

## [Access Manager Playground](https://github.com/chandler767/PubNub-Swift/blob/master/PubNub%20Demo/PAM.playground/Contents.swift)
