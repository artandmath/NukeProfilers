# So I heard you like Stamps?

Before we start. For who is this write up on Stamps intended?

It’s for anyone who may have an interest in where compositing teams are spending their time and computing resources— from studio owners and investors through to pipeline developers, IT, production, managers, supervisors, and to any artist who touches Nuke in the visual effects pipeline.

### What are Stamps?

Stamps are a third-party tool for Foundry’s Nuke that have become somewhat prolific in their use at vendor-side VFX studios over the past 3 or 4 years. A trip to the website describes them best:

> Stamps v1.1 -- Smart node connection system for Nuke
> 
> Stamps is a free and production-ready node connection system for Nuke, that enables placing the main assets in a single place on the Node Graph, through distinct nodes with hidden inputs that reconnect themselves when needed
> 
> https://adrianpueyo.com/stamps/

They look pretty slick! They come with a well written manual, video tutorials, and they work exactly as described: _“hidden inputs that reconnect themselves when needed.”_

If you were to ask some compositors, Stamps are the greatest thing since sliced bread. 

And isn’t sliced bread just fabulous? A loaf of Wonder White™ touts itself as “Full of Goodness” and boasts a 4.5 health star rating. Then of course there is the convenience.

But is sliced white bread really that good for you? Or has the marketing department twisted the numbers to make it appear so?

Like all “good” internet posts, this series is written to be divisive. Division not for the purpose of engagement, but to spark rational, analytical thought and encourage healthy debate around the way a compositing script is built.

You’re either in the Stamps camp, or you have the scars and wisdom learned from opening thousands of other people’s Nuke scripts, and you’re not. And just to make it clear up front, I am not in the Stamps camp. 

With the help of Shia LaBeouf, I’d like to take you on an investigative journey into the Stamps tool. It's a technical journey, so if you’re not technically inclined, just jump to the conclusions.

## Contents

- Fact or fiction? Stamps reduce system overhead
- The LaProfiler
  - LaProfiler
	- LaProfiler-TimeOffset
	- LaProfiler-Filtered
	- LaProfiler-Filtered-TimeOffset
	- LaProfiler-TimeOffset-Filtered
- Nuke version, topdown & classic rendering
- Back to the DOD
- SpiralProfiler
- Conclusions

![A lineup of LeBeouf sprites](/wiki/assets/SpriteLineupSingleLine.png)
