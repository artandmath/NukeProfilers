# NukeProfilers

This repository is an accompianment to a LinkedIn article titled ["So I heard you like Stamps?"](http://link.to.article)

The folder "wiki" is a copy of the article in markdown language that can be used for your VFX studio's internal wiki. All that I ask is that you keep the attribution to the original author of the text (Daniel Harkness).

To use the "LaProfiler" and "SpiralProfiler" example scripts. Do the following:

- Download the repository.
- Download the original [#INTRODUCTIONS](https://vimeo.com/125095515) clip from Vimeo.
- Open the nukescript /nukescripts/GgenerateSprites.nk and render the write nodes.
- Run the profilers on a local machine. EG:
```
cd /path/to/LaProfiler/shellscripts
./profilers.sh
```
- The profilers will iterate throuh the variants and generate results in the corresponding log directory
> [!NOTE]
> The shellscripts are hardcoded to specific versions of nuke. Modify as required. $PATH may have to be set correctly for your version of Nuke.

Alternatively:

- Modify the scripts to work in your comp pipeline.
- Test the scripts by sending the write nodes to your renderfarm.
- Gather the analytics.

