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

## [Presence Playground](https://github.com/chandler767/PubNub-Swift/blob/master/PubNub%20Demo/Presence%20.playground/Contents.swift)

## [Stream Controller Playground](https://github.com/chandler767/PubNub-Swift/blob/master/PubNub%20Demo/StreamController.playground/Contents.swift)

## [Access Manager Playground](https://github.com/chandler767/PubNub-Swift/blob/master/PubNub%20Demo/PAM.playground/Contents.swift)
