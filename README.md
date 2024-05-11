# NukeProfilers

This repository is an accompaniment to a LinkedIn article titled ["So I heard you like Stamps?"](http://link.to.article)

This folder contains files in markdown format that can be used in your studio's internal wiki for the compositing department.

[CC-BY-4.0 license](../LICENSE)

## Usage

To use the "LaProfiler" and "SpiralProfiler" example scripts. Do the following:

- Download the repository.
- Download the original #INTRODUCTIONS clip from Vimeo https://vimeo.com/125095515
- Open the nukescript /nukescripts/GenerateSprites.nk
- At the top of the NodeGraph, re-link the file *"#introductions_(2015) (Original).mp4"* downloaded from Vimeo.
- Render all write nodes, observing the render order.
- Run the profilers shellscript on a local machine.
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
- Modify the Nukescripts to work whithin your comp pipeline.
- Submit the Nukescripts to your renderfarm.
- Gather analytics from the renderfarm.
