# NukeProfilers

This repository is an accompaniment to a LinkedIn article titled ["So I heard you like Stamps?"](http://link.to.article)

The folder "wiki" is a copy of the article in markdown language that can be used for your VFX studio's internal wiki.

All I ask is that you keep the attribution to the original author of the text (Daniel Harkness).

## Usage

To use the "LaProfiler" and "SpiralProfiler" example scripts. Do the following:

- Download the repository.
- Download the original [#INTRODUCTIONS](https://vimeo.com/125095515) clip from Vimeo.
- Open the nukescript /nukescripts/GenerateSprites.nk, re-link the vimeo clip at the top of the NodeGraph and render all write nodes, observing the render order.
- Run the profilers on a local machine.
- The profilers will iterate through the variants and generate results in the corresponding log directory.
```
#local machine profiling example
cd /path/to/LaProfiler/shellscripts
./LaProfilers.sh
```
> [!NOTE]
> The shellscripts are hardcoded to specific versions of Nuke, modify shellscripts as required.
> 
> $PATH may have to be set correctly for your version of Nuke or operating system.

## Alternatively 
- Modify the Nukescripts to work in your comp pipeline.
- Send the Nukescripts to your renderfarm.
- Gather analytics from the renderfarm.
