# NukeProfilers

This repository is an accompaniment to a LinkedIn piece titled ["So I heard you like Stamps?"](https://www.linkedin.com/pulse/so-i-heard-you-like-stamps-part-1-daniel-harkness-xxudc)

It contains nukescripts that can be used for profiling various node graph design patterns.

The ["wiki"](../wiki/README.md) directory contains a copy of the LinkedIn piece in markdown format that can be used in your studio's compositing department wiki.

[CC-BY-4.0 license](../LICENSE)

## Profilers Usage

To use the "LaProfiler" and "SpiralProfiler" example scripts, do the following:
1. Download this repository.
2. Download the original **#INTRODUCTIONS** clip from Vimeo https://vimeo.com/125095515 [^1]
3. Remove the "#" from the clip's filename.
4. Open the nukescript /nukescripts/GenerateElements.nk in Nuke.
5. At the top of the node graph, re-link the file **introductions_(2015) (Original).mp4** downloaded from Vimeo.
6. Make available 20GB of free storage space for renders.
7. Render all write nodes to the global frame range, observing the render order.
8. Run the profilers shellscript on a local machine.
9. The profilers shellscript will iterate through the nukescript variants and generate results in the corresponding log directory.
```
#local machine profiling example
cd /path/to/LaProfiler/shellscripts
./LaProfilers.sh
```
> [!NOTE]
> $PATH may have to be set correctly for your version of Nuke or operating system. The shellscripts are hardcoded to specific versions of Nuke, modify shellscripts as required.

## Alternatively 
1. Download this repository.
2. Download the original **#INTRODUCTIONS** clip from Vimeo https://vimeo.com/125095515 [^1]
3. Modify the nukescripts to work with your comp pipeline.
4. Submit the nukescripts to your renderfarm.
5. Gather analytics from the renderfarm.

[^1]: #INTRODUCTIONS 
  By LaBeouf, Rönkkö & Turner in collaboration with Central Saint Martins BA Fine Art 2015 students. Released under a Creative Commons Attribution Non-Commercial Share-Alike licence. https://vimeo.com/125095515
