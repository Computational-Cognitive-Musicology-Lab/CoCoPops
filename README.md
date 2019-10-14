# CoCoPops/Billboard


This repository contains files related to an ongoing project to add melodic transcriptions to the existing McGill Billboard corpus of chord annotations.
This project started at Ohio State, led by Hubert Gauvin, Claire Arthur, and Nat Condit-Schultz, and with contributions from Gary Yim, Dana Devlieger.
Currently, Claire and Nat and Geogia Tech are the only people actively working on it.
This project is a part of our larger Coordinated Corpus of Popular Music (CoCoPops) project.


## Directory organization

The repository is organized as follows:

### Root Directory

In the root directory, in addition to this file, there are two text files containing tab-delineated spread sheets of information about the corpus: `BillboardSampleData.tsv` and `BillboardTranscriptionData.tsv`.
The first two columns of each of these files are, and should remain, identical, except for that we might sort the rows differently from time to time.
These first two columns state the ARTIST and TITLE for each sampled song.  Note that in the original Billboard data, artist names and song titles are not always consistent; for example, we see some files by "Rolling Stones" and some by "The Rolling Stones." In our `.tsv` spread sheets, these inconsistencies have been removed.
Both files have exactly 740 records: 1 for the header, and 739 for the 739 unique songs in the sample.
		
`BillboardSampleData.tsv` contains information about the sample, all copied directly from the original data (i.e. information has not been independently verified).
The original sampling scheme (Burgoyne, 2011) called for 1300 chart positions to be targeted for sampling, but data for only 890 positions could be gathered. 
In addition, many songs were sampled more than once so this 890 actually only represents 739 unique recordings.
In the "BillboardSampleData.tsv" file, songs which are sampled more than once have multiple data points filled into some columns, separated by ", ".

`BillboardTranscriptionData.tsv` is a more active document, where we keep track of information about our new transcriptions, and the ongoing transcription process.
In addition to the ARTIST and TITLE columns, there is a Filename column which indicates the root filename (sans extension) that will be used for the associated track in our corpus.
For instance, files associated with the song "Honey, Honey" by ABBA will all labeled "ABBA_HoneyHoney_1974"; for instance, "ABBA_HoneyHoney_1974.xml", "ABBA_HoneyHoney_1974.mus", and "ABBA_HoneyHoney_1974.hum".
These file names are formatted as follows `Arist_Title_Year.extension`, with the following formatting guidelines: The `Artist` and `Title` portion of each filename contains only roman-letters and Arabic numerals, no special characters (no hyphens, no apostrophes, no commas, no parenthesis, etc.) and no spaces between words. 
The spelled out word "And" is always used, never "&". 
In lieu of spaces, the first character of each word is upper case, while the rest are lower case.
Parentheticals in titles are simply removed, so Otis Reddings' "(Sittin' On) the Dock of the Bay" is just "OtisRedding_TheDockOfTheBay_1968".
The `Year` part of the filename is only the first year the song was sampled, which is not necessarily the year the song was released.

Other information in the `BillboardTranscriptionData.tsv` file includes the name of the melodic transcriber, date the transcription was finished, any comments the transcriber has about the transcription, and a brief description of any changes/edits/fixes which the transcriber thinks should be made to the original McGill chord-annotation data.

-----

The root directory contains four subdirectories:

+ The `McGillData_Originals` directory contains the original, unaltered McGill Billboard data.
+ The `Humdrum` directory contains a variety of humdrum-formatted files, including the final melodic-transcription files.
+ The `MelodicTranscriptions` directory contains melodic transcription data which has yet to be translated to humdrum, or bound to the chord data.
+ The `Scripts` directory contains a variety of scripts (Bash, Awk, and R) used in the project.


