# CoCoPops/Billboard/


This repository contains a dataset of harmonic and melodic transcriptions of popular songs which charted on Billboard Hot 100 list between 1959 and 1991.
This dataset is part of a larger **Coordinated Corpus of Popular Music** project, led by Nat Condit-Schultz and Claire Arthur at the [Computational and Cognitive Musicology Lab](https://ccml.gtcmt.gatech.edu/) in the Georgia Tech [Center for Music Technology](https://gtcmt.gatech.edu/).

This dataset is based off an existing dataset of 739 harmonic annotations created at McGill University in the period 2010-2012: the [McGill Billboard Project]("https://ddmal.music.mcgill.ca/research/The_McGill_Billboard_Project_(Chord_Analysis_Dataset)/").
The CoCoPops/Billboard dataset is an ongoing project to add melodic transcriptions to the McGill transcriptions.
The dataset is encoded in a [humdrum format](humdrum.org), making it comparable to the [CoCoPops/RollingStone](https://github.com/Computational-Cognitive-Musicology-Lab/CoCoPops-RollingStone) dataset.

This project started at Ohio State, led by Hubert Gauvin, Claire Arthur, and Nat Condit-Schultz.
Currently, Claire and Nat at Geogia Tech are the only people actively working on it.
Other people who have contributed to the project include:

+ Jonathan Eldridge
+ Rhythm Jain
+ Gary Yim 
+ Dana Devlieger


## Directory organization

The repository is organized as follows:

### Root Directory

In the root directory, in addition to this file, there are two text files containing tab-delineated spread sheets of information about the corpus: `BillboardSampleData.tsv` and `BillboardTranscriptionData.tsv`.
Both files have exactly 740 records: 1 for the header, and 739 for the 739 unique songs in the sample.
The first three columns of each of these files are, and should remain, identical, except for that we might sort the rows differently from time to time.
These first three columns state the `FileName`, `ARTIST` and `TITLE` for each sampled song. 
(Note that in the original Billboard data, artist names and song titles are not always consistent; for example, we see some files by "Rolling Stones" and some by "The Rolling Stones." In our `.tsv` spread sheets, these inconsistencies have been removed.)
The `FileName` column indicates the root filename (sans extension) used for all files in the dataset associated with that song.
For instance, files associated with the song "Honey, Honey" by ABBA will all labeled `ABBA_HoneyHoney_1974`; for instance, `ABBA_HoneyHoney_1974.xml`, `ABBA_HoneyHoney_1974.mus`, and `ABBA_HoneyHoney_1974.hum`.
These file names are formatted as follows `Arist_Title_Year.extension`, with the following formatting guidelines: The `Artist` and `Title` portion of each filename contains only roman-letters and Arabic numerals, no special characters (no hyphens, no apostrophes, no commas, no parenthesis, etc.) and no spaces between words. 
The spelled out word "And" is always used, never "&". 
In lieu of spaces, the first character of each word is upper case, while the rest are lower case.
Parentheticals in titles are simply removed, so Otis Reddings' "(Sittin' On) the Dock of the Bay" is just "OtisRedding_TheDockOfTheBay_1968".
The `Year` part of the filename is only the first year the song was sampled, which is not necessarily the year the song was released.


`BillboardSampleData.tsv` contains information about the sample, all copied directly from the original data (i.e. information has not been independently verified).
Much of this information relates to the original McGill project's sampling scheme:
The original sampling scheme (Burgoyne, 2011) called for 1300 chart positions to be targeted for sampling, but data for only 890 positions could be gathered. 
In addition, many songs were sampled more than once so this 890 actually only represents 739 unique recordings.
In the `BillboardSampleData.tsv` file, songs which are sampled more than once have multiple data points filled into some columns, separated by ", ".

`BillboardTranscriptionData.tsv` is a more active document, where we keep track of information about our new transcriptions, and the ongoing transcription process.
Other information in the `BillboardTranscriptionData.tsv` file includes the name of the melodic transcriber, date the transcription was finished, any comments the transcriber has about the transcription, and a brief description of any changes/edits/fixes which the transcriber thinks should be made to the original McGill chord-annotation data.

Finally, links to each song on YouTube are present in the `YoutubeLink` column!

-----

The root directory contains four subdirectories:

+ The `OriginalData` directory contains the original, unaltered McGill Billboard data.
+ The `Humdrum` directory contains a variety of humdrum-formatted files in different subdirectories:
    + **The `CompleteTranscriptions` subdirectory is where the most up-to-date version of all completed files, with the harmony, melody, lyrics, timestamps, etc., resides**.  
    + There is a separate subdirectory `ValenceArousal` which has a clone of the 100-file subset from CompleteTranscriptions that includes continuous V&A ratings.
    + The `HarmonicTranscriptions` subdirectory contains the complete set of all McGill Billboard harmonic transcription files, including corrections, in humdrum format.
    + The `MelodicTranscriptions` subdirectory contains the same information from the `CompleteTranscriptions` folder, but reduced to only contain the melodic and lyrical information. This subdirectory also contains the [transcription instructions](https://github.com/Computational-Cognitive-Musicology-Lab/CoCoPops/blob/main/Billboard/MelodicTranscriptions/TranscriptionInstructions_2019.pdf).
+ The `MelodyResources` directory contains melodic transcription data in pre-humdrum formats (musicxml and Sibelius). **Note that files in this folder are older, and may not match the final transcriptions in the Humdrum format. Use at your own risk!**
+ The `Scripts` directory contains a variety of scripts (Bash, Awk, and R) used in the project.


