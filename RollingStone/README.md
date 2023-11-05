# CoCoPops/RollingStone/

This repository contains a dataset of 200 melodic and harmonic transcriptions of popular songs which appear on the Rolling Stone "500 Greatest Songs of All Time" list.
This dataset is part of a larger **Coordinated Corpus of Popular Music** project, led by Nat Condit-Schultz and Claire Arthur, in the [Computational and Cognitive Musicology Lab](https://ccml.gtcmt.gatech.edu/) in the Georgia Tech [Center for Music Technology](https://gtcmt.gatech.edu/).

This data is a simply **a translation of de Clercq and Temperley's [Rolling Stone Corpus](http://rockcorpus.midside.com/) into a [humdrum](www.humdrum.org) format.**
By providing this data in humdrum format, we hope to make it more accessible to a wider variety of reseachers, and easier to compare to similarly formatted data, like the [CoCoPops/Billboard corpus](https://github.com/Computational-Cognitive-Musicology-Lab/CoCoPops-Billboard). 
The most important **note for those wishing to combine the Billboard and RollingStone subcorpora has to do with the encoding of rhythmic information.** 
Please see the `Rhythm` subsection below for important details.

The files `RollingStoneSampleData.txt` is a table of metadata about the pieces, which was used to populate the reference records of the humdrum files.

Early work on this project was started by Nat at McGill University in 2018.
Currently, Claire and Nat at Geogia Tech are the only people actively working on it.
Other people who have contributed to the project include:

+ Rhythm Jain


## Directory Structure

This repository is organized as follows:

### Root Directory


In the root directory, in addition to this file, there is a text file containing a tab-delineated spread sheet of information about the corpus: `RollingStoneSampleData.tsv`. 
This file has exactly 201 records: 1 for the header, and 200 for the 200 unique songs in the sample.
These first three columns state the `FileName`, `ARTIST` and `TITLE` for each sampled song.
The `FileName` column indicates the root filename (minus extension) used for all files in the dataset associated with that song.


As described on the root README file, names are formatted as follows `Arist_Title_Year.extension`. 
Unlike the Billboard subset, the `Year` part of the filename for the RollingStone subset should align with the year of the song's release. 

`RollingStoneSampleData.tsv` contains information about the sample, all copied directly from the original data (i.e. information has not been independently verified).
Much of this information relates to Temperley and de Clercq's original release history.
[Their initial paper (2011)](https://www.cambridge.org/core/journals/popular-music/article/corpus-analysis-of-rock-harmony/C5210A8EC985DDF170B53124F4464DA4) included only a 100-song subset of the Rolling Stone list, to which they added an additional 100 songs later.
Songs in the original sample are indicated in the `RS 5x20 subset` column.
Later, [Tan, Lustig, and Temperley (2019)](https://online.ucpress.edu/mp/article/36/4/353/62973/Anticipatory-Syncopation-in-Rock-A-Corpus-Study) added lyric information to an 80-song subset: these tracks are indicated in the `Lyric subset` column.

Finally, links to each song on YouTube are present in the `YoutubeLink` column!

The root directory contains three subdirectories:

+ The `OriginalData` directory contains the original, unaltered dataset.
+ The `Humdrum` directory containing the humdrum-formatted files.
+ The `Scripts` directory contains a variety of scripts (Bash, Awk, and R) used in the project.
  
----
### Humdrum directory

As described in the `OriginalData/README.md` file, The original dataset includes, for each of the two hundred songs, four separate text files: two harmonic transcriptions (one by each author; .txt files), one melodic transcription (by one or the other author; .mel files), and timestamp information (timestamps for each downbeat in the recording; .tim files).
For this project, a Haskell program was created to translate Temperley and de Clercq's original encodings into the humdrum syntax, with the four original files (2 x .txt, .mel, and .fl) encoded into four separate spines of a single humdrum file. 
Therefore in the Humdrum folder there is one single file per song (`.hum`) with all the above information collated into a single file with each piece of information in a separate column (spine).

This program was created and run in 2019 by Nat Condit-Schultz;
Information about this initial data translation process is contained below, with additional details in the "WorkLog" file.
(A number of errors in the original data are documented in the work log. See `Humdrum/worklog.md` for additional details.)

The current version of the humdrum data set is located in the `Humdrum` directory.

In 2021, Rhythm Jain worked with Nat to add incorporate the additional lyrical information for the 80-song subset into the humdrum files, as `**silbe` and `**stress` spines.

### HumdrumFiles

A Haskell parser translates and combines the original melodic and harmonic transcriptions into a single humdrum file, using `\*tb` (timebase) for melodic rhythm.

Two songs (*Layla* and *Crazy*) have key changes mid measure, which the parser is not ready for.
these were manually fixed *after* auto parsing was complete.
(In *Layla*, one of the two harmonic transcriptions also failed to change keys mid measure.)

*Shout* has a weird "commented" breakdown which does not work with the parser. The `|` bars from this passage were changed to `:`, so the parser doesn't trip on it.
*Strawberry Fields* has the same problems.

### Tempos

The file `../Tempos.tsv` lists the bpm(s) for each file, based on author NCS tapping along to them using the (https://www.all8.com/tools/bpm.htm) tool.
Using the `../Scripts/InsertTempos.R` script (**CURRENTLY BROKEN**), these tempos can be inserted into the humdrum files.
For files with multiple tempos, the actual location of tempo changes in the humdrum file has to be input manually (for now.)

### Pitch

In de Clercq and Temperley's original melodic encodings, pitch is encoded as scale degrees (1-7) with additional marks to indicate melodic contour/leap size.
de Clercq and Temperley indicate the tonic note and the diatonic scale for each piece, including various diatonic modes.
In the humdrum files, we use the standard humdrum a `\*\*deg` interpretation:
Numerals 1--7 indicate the natural scale degree of each pitch, given the key/mode.
`b` and `#` symbols indicate alterations relative to the mode.
By default, each successive scale degree is assumed to be the pitch closest the previous note---*tritones are assumed to be upward, regardless of their spelling*!
One or more `^` and `v` symbols are used to indicate violations of this, with multiple `v` or `^` indicating additional octaves.

In March 2022, author NCS used the latest version of `humdrumR` and some additional fiddling (to deal with tritones) to translate the `**deg` representation to `**kern`.
After some time inspecting various songs, they now should all be correct.

### Rhythm

In de Clercq and Temperley's original melodic encodings, rhythmic information is encode as a drum-machine-like step-sequence, indicating only at which point in each measure a note begins (leaving out offset/duration information).
In the humdrum files, `\*tb` interpretations indicate the step-sequence duration size, which changes dynamically as necassary.
For instance, `\*tb8` indicates that each subsequent data record is an eighth-note.

**Note that de Clercq and Temperley's "step sequence" approach means that the rhythm transcriptions only indicate onsets, not durations.**
(There are also, as a result, no rest tokens.)



