# NukeProfilers

This repository is an accompaniment to a LinkedIn article titled ["So I heard you like Stamps?"](http://link.to.article)

The "wiki" folder contains a copy of the article in markdown format that can be used in your studio's internal wiki for the compositing department.

[CC-BY-4.0 license](../LICENSE)

## Profilers Usage

To use the "LaProfiler" and "SpiralProfiler" example scripts, do the following:
- Download the repository.
- Download the original #INTRODUCTIONS clip from Vimeo https://vimeo.com/125095515 [^1]
- Open the nukescript /nukescripts/GenerateSprites.nk
- At the top of the NodeGraph, re-link the file *"#introductions_(2015) (Original).mp4"* downloaded from Vimeo.
- Check for 20GB of free storage space for renders.
- Render all write nodes to the global frame range, observing the render order.
- Run the profilers shellscript on a local machine.
- The profilers will iterate through the variants and generate results in the corresponding log directory.
```
#local machine profiling example
cd /path/to/LaProfiler/shellscripts
./LaProfilers.sh
```
> [!NOTE]
> $PATH may have to be set correctly for your version of Nuke or operating system. The shellscripts are hardcoded to specific versions of Nuke, modify shellscripts as required.

## Alternatively 
- Modify the Nukescripts to work whithin your comp pipeline.
- Submit the Nukescripts to your renderfarm.
- Gather analytics from the renderfarm.

[^1]: #INTRODUCTIONS 
  By LaBeouf, Rönkkö & Turner in collaboration with Central Saint Martins BA Fine Art 2015 students. Released under a Creative Commons Attribution Non-Commercial Share-Alike licence. https://vimeo.com/125095515
