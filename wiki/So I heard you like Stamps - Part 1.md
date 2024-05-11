![Header](assets/Header_SoIHeardYouLikeStamps.gif)

An investigation into the Stamps tool for Nuke, by Daniel Harkness, 11 May 2024

# So I heard you like Stamps?

Before we start. For who is this write up on Stamps intended?

It’s for anyone who may have an interest in how and where compositing teams are spending their time and computing resources— from studio owners and investors through to pipeline developers, IT, production, managers, supervisors, and to any artist who touches Nuke in the visual effects pipeline.

### What are Stamps?

Stamps are a third-party tool for Foundry’s Nuke that have become somewhat prolific in their use at vendor-side VFX studios over the past 4 years. A trip to the website describes them best:

> Stamps v1.1 -- Smart node connection system for Nuke
> 
> Stamps is a free and production-ready node connection system for Nuke, that enables placing the main assets in a single place on the Node Graph, through distinct nodes with hidden inputs that reconnect themselves when needed
> 
> https://adrianpueyo.com/stamps/

They look pretty slick! They come with a well written manual, video tutorials, and they work exactly as described: _“hidden inputs that reconnect themselves when needed.”_

If you were to ask some compositors, Stamps are the greatest thing since sliced bread. 

And isn’t sliced bread just fabulous? A loaf of Wonder White™ touts itself as “Full of Goodness” and boasts a 4.5 health star rating. There is of course also the added convenience of not ever needing to own, or know how to use, a bread knife.

But is sliced white bread really that good for you? Or has the marketing department twisted the numbers to make it appear so?

With the help of Shia LaBeouf, I’d like to take you on an investigative journey into the Stamps tool. The journey will be long and technical, so if you have the attention span of a goldfish or your eyes glaze over at the first sight of a spreadsheet or chart, scroll past the data and just jump straight to the conclusions.

You’re either in the Stamps camp, or you have the scars and wisdom learned from opening thousands of other people’s Nuke scripts, and you’re not. And just to make it clear up front, I am not in the Stamps camp. 

This internet post is written to be divisive. Division not for the purpose of engagement, but to spark rational, analytical thought and encourage healthy debate around the way a compositing script is built.

## Contents

- Fact or fiction? Stamps reduce system overhead
- The LaProfiler
	- LaProfiler
	- LaProfiler-TimeOffset
	- LaProfiler-Filtered
	- LaProfiler-Filtered-TimeOffset
	- LaProfiler-TimeOffset-Filtered
- Back to the DOD
- Size on disk
- SpiralProfiler
- Nuke version, topdown & classic rendering
- Conclusions

## Fact or fiction? Stamps reduce system overhead

When discussing the use of Stamps with colleagues, one of the claims put forward is that Stamps will improve the performance of a Nukescript. I’m told “it has been tested and proven that Stamps reduce system overhead”.

I’m told that because Stamps source assets from single nodes in a Nukescript, they minimize CPU, RAM and network usage, as well as reducing node count for cleaner, more optimal scripts.

Conversely, I’m also told that by creating multiples of a Read node asset in a Nukescript, system overheads are also multiplied.

What follows are some profiling examples designed to verify whether these claims are true.

## The LaProfiler

The "LaProfiler" series of tests will involve some sprites sourced from Shia LaBeouf’s infamous “Just Do it!” monologue in __#INTRODUCTIONS (2015)__. The video resolution is 1280x720 pixels — source: https://vimeo.com/125095515

![A lineup of LeBeouf sprites](/wiki/assets/SpriteLineupSingleLine.png)

Apologies to the the Frenchies who will no doubt be appalled at my boucherie de la langue Française.

What are those dotted rectangles around him? In the Shake days we used to call it a “domain of definition” or DOD for short. These days we call them “bounding boxes” or BBox for short.

The DOD/BBox is an instruction to the compositing software to look only within the DOD/BBox for storing pixel data on disk and RAM and to indicate when and where to perform calculations on the data. Compositing software knows no difference between the black pixels surrounding Shia and the coloured pixels he is comprised of.

To put it another way, whilst the black pixels may compress down to near zero when they are stored on disk, when they’re read back from disk, the CPU and RAM requirements of the black pixels are no different to those of the coloured pixels. Hence why we define a DOD/BBox— to help reduce the load on the computing resources.

In this case, each sprite has a DOD/BBox that encompasses Shia’s person only and tells the compositing software to ignore all other pixel data within each sprite’s original 1280x720 pixel frame.

## LaProfiler

The tests will run across 3 Nuke scripts. Each script produces the same result. There are 24 Shia’s for each of the 9 types of sprite: LaBeouf, LaRed, LaNoir, etc. A total of 216 Shias are composited on each frame.

There are a few transforms to position Shia into various X-axis offsets in screen space. Everything is merged together (Shake-style, like a tree, over a colorwheel). The composite is designed to be I/O bound and light on CPU operations.

The only difference with the 3 scripts is that the instances of Shia in the script are sourced from:
- __Instances__ — a single Read node of Shia for each type of sprite. 9 read nodes total.
- __Duplicates__ — an individual read node for each Shia. 216 read nodes.
- __Stamps__ — an anchor for each read node. 9 read nodes, 9 anchors, 216 stamps.

![Screenshot of the LaProfiler Node Graph](/wiki/assets/Screenshot_LaProfiler_NodeGraph.png)

The scripts are processed on an 8 year old intel i5-8500B @ 3.00Ghz with the sprites sourced from an on-board SSD on another computer via a direct 1GBe connection. The output frames are saved over the same network connection to the same SSD containing the sprites.

The scripts render 100 frames, iterating the same render 5 times so that an average result can be obtained. The Nuke profiler is disabled, and the CPU and RAM usage logged. These are the results:

![Results for LaProfiler - Nuke 13.2v9 - classic render mode](/wiki/assets/charts-72dpi/LaProfiler_Nuke13-2.png)

So it’s true! Stamps do indeed use less memory resources than duplication of assets in a Nukescript. Not the 2300% overhead that I was told would be the case, but rather an a 101% increase in render time of Duplicates vs Stamps and an 18% increase in RAM overhead. Still, these are not insignificant numbers.

They’re not entirely the results I was expecting, having run similar tests at large facilities and getting results that showed Duplicates using less RAM than Stamps— in those tests there may or may not have been facility specific pipeline and server-side optimizations. More complex multi-part EXRs and Deep data may have also had an impact on the results.

However for vanilla Nuke, the results speak for themselves. Clearly, using Stamps is more efficient than using duplicate assets in a Nukescript and we should all start using _“hidden inputs that reconnect themselves when needed”._

Or should we ...

## LaProfiler-TimeOffset

Let’s increase I/O load for the Nukescript. TimeOffset nodes are added to each occurrence of Shia in the output frame. At each TimeOffset, Nuke is pulling a unique frame from storage, for a total of 216 unique input sprite frames for each output frame. In theory we should only be pulling in more data for each output frame and not applying much change to the CPU load compared to the previous test.

![Screenshot of a section of the LaProfiler-TimeOffset_Duplicates NodeGraph](/wiki/assets/Screenshot_LaProfiler-TimeOffset_NodeGraph.png)

![Results for LaProfiler-TimeOffset - Nuke 13.2v9 - classic render mode](/wiki/assets/charts-72dpi/LaProfiler-TimeOffset_Nuke13-2.png)

Now we see next to no difference in render time when using a single source for each type of Shia sprite (Stamps and Instances) or when using a unique read node for each instance of Shia (Duplicates). We see the same increase in memory overhead for 216 Read nodes (Duplicates) versus 9 Read nodes (Stamps and Instances) as the previous test. 

## LaProfiler-Filtered

What happens when we increase the CPU load by throwing some filters into the script? Let’s remove the TimeOffsets and add a unique filter after each instance of Shia. For the higher CPU load tests, the framerange is reduced from 100 frames to 10 frames (1001-1010). There is no additional DOD/BBox management beyond providing the initial smaller DOD/BBox for the sprites.

![Screenshot of a section of the LaProfiler-Filtered_Stamps NodeGraph](/wiki/assets/Screenshot_LaProfiler-Filtered_NodeGraph.png)

![Results for LaProfiler-Filtered - Nuke 13.2v9 - classic render mode](/wiki/assets/charts-72dpi/LaProfiler-Filtered_Nuke13-2.png)

Stamps and Duplicates are using far more RAM than single instances. Render times for duplicates are the longest, taking 6-7% longer than Instances and Stamps.

## LaProfiler-Filtered-TimeOffset

Finally, let us combine the Filters and TimeOffsets.

![Screenshot of LaProfiler Node Graph](/wiki/assets/Screenshot_LaProfiler-Filtered-TimeOffset_NodeGraph.png)

![LaProfiler results chart](/wiki/assets/charts-72dpi/LaProfiler-Filtered-TimeOffset_Nuke13-2.png)

What is interesting to note is that what was the most RAM performant script in all previous cases (Instances) is now the most RAM heavy script and takes slightly longer to render than the other two tests. The Duplicates and Stamps scripts are pretty much on par with each other in terms of render time and CPU requirements, with the Duplicates script requiring 1% more memory than Stamps (or 4% relative to each other).

By the time we've created a script of even moderate complexity, it appears there is no major difference as to whether we use Stamps or not, or whether or not we create duplicates of the Read node assets.

## LaProfiler-TimeOffset-Filtered

And just for safe measure, and because nothing in VFX is actually ever final, let's run the same test but flip the order of operations between the Filter and TimeOffset operations. TimeOffsets are concatenated where possible and performed before the Filter operations.

![Screenshot of a section of the LaProfiler-TimeOffset-Filtered_Duplicates NodeGraph](/wiki/assets/Screenshot_LaProfiler-TimeOffset-Filtered_NodeGraph.png)

![Results for LaProfiler-TimeOffset-Filtered - Nuke 13.2v9 - classic render mode](/wiki/assets/charts-72dpi/LaProfiler-TimeOffset-Filtered_Nuke13-2.png)

Again, by the time we've created a script of even moderate complexity, it appears there is no major difference as to whether we use Stamps or not, or whether or not we create duplicates of the Read node assets.

And by changing the order of operations it appears we can shave a full 40 seconds off a 5 minute render for a 15% improvement in render time.

## Back to the DOD

If changing the order of operations gave us a 15% improvement in render times, what sort of impact does the DOD have?

Let's run the tests again with each sprite's DOD/BBox set to use the full 1280x720 pixel frame.

When it comes to computing resources, referencing single instances of a Read node asset in a script by using Stamps has less of an impact on CPU and RAM than telling Nuke when and where it should performing its calculations. In some instances the full frame Nukescripts casued Nuke to crash due to hitting a RAM ceiling. Where Nuke didn't crash we see a X to X increase in render times and X to X increase in memory requirements.

These tests are simple comps, running on old hardware in a restricted 4GB to 5GB RAM environment. We might think it's irrelevant and we can just throw more computing power at a compositing problem and not worry about something so trivial as the DOD/BBox. But the impact of the DOD is just as relevant in a modern Nuke session referencing 4K plates and multi-part EXRs on a workstation with 96 CPU cores and 256GB of RAM. Not taking the care to manage the size of the DOD/BBox on complex compositing work is going to bring even the best workstation to its knees or, at the very least, make for a slower artist.

## Size on disk

Taking a look at the file dialog box for our Nukescripts, an item to note is the size on disk of the Stamp scripts compared to the non-Stamp scripts.

![Screenshot of the File>Open dialog for the LaProfiler Nukescripts folder](/wiki/assets/Screenshot_LaProfiler_FileDialog.png)

Pasting a Stamp and Anchor pair into a text editor will show us the space on disk they take within a Nukescript when compared to a pair of Dot nodes.

![Screenshot of Stamps in a text editor](/wiki/assets/Screenshot_StampsPairInTextEditor.png)

## SpiralProfiler

The following three scripts take a look at nodes used for script organisation. Dots (sometimes called elbows) and NoOps (No Operation node) allow a compositor to organise their script to make it more readable for both themselves and other artists who may pick up their work.

Stamps falls into the category of script organisation and I’m told they have the same overhead as a Dot or NoOp.

The SpiralProfiler scripts contains 500 nodes of the organizational type (Dot or NoOp), and in the case of Stamps, 250 Anchor nodes and 250 Stamps. The scripts follow the mythical “spiral” compositing Nukescript pattern— also known as a “toilet bowl” script.

![Screenshot of SpiralProfiler Node Graphs](/wiki/assets/Screenshot_SpiralProfiler-NoOps_NodeGraph.png)

The scripts are organised as follows:
- 1024x1024px checkerboard.
- Transform operation with __rotation=time__ and filtering of type __Impluse__ (nearest neighbour, aliased pixel filtering).
- The chain of 500 organizational nodes.
- Transform operation with __rotation=time__ and filtering of type __Cubic__ (an anti-aliased filtering operation).
- The two transforms will concatenate (concatenate meaning that the two transforms are combined into one operation, inheriting the Cubic filtering).
- Grade node to purposely break any further concatenation.
- As this is a CPU test, the final result is scaled to 32x32 pixels to keep IO load low and the resulting frames saved over the network.

The scripts are run on 1000 frames, again iterating 5 times, with the Nuke profiler disabled, and the CPU and RAM usage logged. 

![Results for SpiralProfiler - Nuke 13.2v9 - classic render mode](/wiki/assets/charts-72dpi/SpiralProfiler_Nuke13-2.png)

As an organisational tool, Stamps add compute overhead when compared to Dots and NoOps, they create larger Nukescripts, and as seen in the next screenshot, break concatenation.

![Stamps break concatenation](/wiki/assets/Screenshot_SpiralProfiler_StampsBreakConcatenation.gif)

Why should it matter that Stamps break concatentation? Aren't they a tool that _"enables placing the main assets in a single place on the Node Graph"?_

Should they not exist at the asset level where concatenation won't matter? In Part 2 we'll see why it does matter, because of all the weird, wonderful and confusing things that happen when you give _"hidden inputs that reconnect themselves when needed”_ to your compositing team.

## Nuke version, topdown & classic rendering

The above tests were all performed using Nuke13.2v9 and the classic render mode. Nuke 13.2 introduced a new way for Nuke to render the NodeGraph called Topdown rendering. From the Foundry's newsletter:

> In Nuke 13.2, we introduced a new way for Nuke to render its node graph called Top-down rendering. This new rendering method allows Nuke to render its node graph from the top of the graph down, rather than scanline-by-scanline on-demand, allowing Nuke to cache its data more efficiently, reducing thread synchronization issues and results in overall faster rendering.

> In our internal tests, we have seen scripts render on average 20% faster and some by as much as up to 200% faster (performance gains being script-dependent).

> https://www.foundry.com/nuke-newsletter/top-down-rendering

The LaProfiler and SpiralProfiler test scripts were run in Nuke 12.2, Nuke 13.2 Classic and Nuke 13.2 Topdown. Whilst there were in some instances improvements in speed between Nuke 12.2 Classic mode and Nuke 13.2 Topdown mode, Nuke 13.2 Topdown mode was generally slower (in some cases more than half as slowe) and consumed far more RAM (is some cases more than double the RAM usage) than Nuke 13.2 Classic mode. Topdown mode also seemed to exhibit potential signs of memory leaks.

It will be interesting to investigate to see if Topdown rendering has improved in Nuke 14 & 15. The decrease in Topdown performance rather than the proposed increase in performance may well be a case of these tests being run on ancient hardware.

The full set of results are available here: https://github.com/artandmath/NukeProfilers/tree/main/wiki/assets/charts-pdf

## Conclusions

Initial tests show that using Stamps in Nukescripts could be a good way to organise Read node assets, because of the potential efficiency gains to be had from not having duplicate Read nodes.

However, as script complexity grew, those advantages were reduced to the point of not being relevant. Stamps added to script bloat and broke concatenation.

What turns out to be more important than reducing Read node count is managing what data is being processed by Nuke. By mananging the bounding box, render times were brought down X percent and memory brought down by X percent.

What Stamps don't do is reduce system overheads, but what they do do is give us hidden inputs and the appearance of organization.

See you in Part 2, where we will take a look at what happens when Stamps are put into production and why the appearance of organization is not organization. Until then, let's take another look at that Stamps spiral....

## Downloads

Don't believe everything you've read here just because I said it's so! The test scripts used in this piece are available for download so you can them run yourself. https://github.com/artandmath/NukeProfilers.

This piece is also available for download from the same repository— written in markdown format for your VFX studio's compositing department wiki.
