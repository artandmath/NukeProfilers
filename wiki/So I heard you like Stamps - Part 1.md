
An investigation into the Stamps tool for Nuke, by Daniel Harkness, 10 May 2024

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

With the help of Shia LaBeouf, I’d like to take you on an investigative journey into the Stamps tool. It will be a technical journey, so if you’re not technically inclined, just jump to the conclusions.

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

## Fact or fiction? Stamps reduce system overhead

When discussing the use of Stamps with colleagues, one of the claims put forward is that Stamps will improve the performance of a Nuke script. I’m told “it has been tested and proven that Stamps reduce system overhead”.

I’m told that because Stamps source assets from single nodes in a Nuke script, they minimize CPU, RAM and network usage, as well as reducing node count for cleaner, more optimal scripts.

Conversely, I’m also told that by creating multiples of an asset in a Nuke script, system overheads are also multiplied.

What follows are some some profiling examples designed to verify whether these claims are true.

## The LaProfiler

The first test will involve some sprites sourced from Shia LaBeouf’s infamous “Just Do it!” monologue in #INTRODUCTIONS (2015). Source: https://vimeo.com/125095515.

![A lineup of LeBeouf sprites](/wiki/assets/SpriteLineupSingleLine.png)

Apologies to the the Frenchies who will no doubt be appalled at my boucherie de la langue Française.

What are those dotted rectangles around him? In the Shake days we used to call it a “domain of definition” or DOD for short. These days we call them “bounding boxes” or BBox for short.

The DOD/BBox is an instruction to the compositing software to look only within the DOD/BBox for storing pixel data on disk and RAM and to indicate when and where to perform calculations on the data. Compositing software knows no difference between the black pixels surrounding Shia and the coloured pixels he is comprised of.

To put it another way, if we didn’t provide a DOD/BBox, whilst the black pixels may compress down to near zero when they are stored on disk, when they’re read back into RAM, the CPU and RAM requirements on the black pixels are no different to those of the coloured pixels. Hence why there is a DOD/BBox— to help reduce the load on the computing resources.

In this case, each sprite has a DOD/BBox that encompasses Shia’s person and tells the compositing software to ignore all other pixel data within each sprite’s original 1280x720 pixel frame.

The tests will run across 3 Nuke scripts. Each script produces the same result. There are 24 Shia’s for each of the 9 types of sprite, LaBeouf, LaRed, LaNoir, etc. A total of 216 Shia’s are computed on each frame.

There are a few transforms to position Shia into various X-offsets in screen space. Everything is merged together (Shake-style, like a tree, over a colorwheel). The composite is very much I/O bound and light on CPU operations.

The only difference in the 3 scripts is that the instances of Shia in the script are sourced from:
- __Instances__ — a single Read node of Shia for each type of sprite. 9 read nodes total.
- __Stamps__ — an anchor for each read node. 9 read nodes, 9 anchors, 216 stamps.
- __Duplicates__ — an individual read node for each Shia. 216 read nodes.

![Screenshot of LaProfiler Nukescript](/wiki/assets/Screenshot_LaProfiler_Nukescript.png)

The scripts are processed on an old intel i5-8500B @ 3.00Ghz with the sprites sourced from an on-board SSD on another computer via a direct 1GBe connection. The renders are saved over the same connection to the same SSD as the sprites.

The scripts are run on 100 frames, 5 times. The Nuke profiler is disabled, and the CPU and RAM usage logged. These are the results:

![Screenshot of LaProfiler Nukescript](/wiki/assets/charts-72dpi/LaProfiler_Nuke13-2.png)

So it’s true! Stamps do indeed use less memory resources than duplication of assets in a script. Not the 2300% overhead that I was told would be the case, but rather an a 101% increase in render time of Duplicates vs Stamps and an 18% increase in RAM overhead. Still, not insignificant numbers.

They’re not entirely the results I was expecting, having run similar tests at large facilities and getting results that showed Duplicates using less RAM than Stamps— in these cases there may or may not have been facility specific pipeline and server-side optimizations. More complex multi-part EXRs and deeps may have also had an impact on the results.

However for vanilla Nuke, the results speak for themselves. Clearly, using Stamps is more efficient than using duplicate assets in a script and we should all start using _“hidden inputs that reconnect themselves when needed”._

Or is it ….