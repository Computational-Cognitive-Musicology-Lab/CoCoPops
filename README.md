# CoCoPops: The Coordinated Corpus of Popular Musics

This repository is the home of the **Coordinated Corpus of Popular Music** (CoCoPops).
CoCoPops is a meta-corpus of melodic and harmonic transcriptions of popular music.
CoCoPops has been developed primarily by Nat Condit-Schultz and Claire Arthur in the [Computational and Cognitive Musicology Lab](https://ccml.gtcmt.gatech.edu/), within the Georgia Tech [Center for Music Technology](https://gtcmt.gatech.edu/).
Many other wonderful people have contributed to CoCoPops as well, both directly and indirectly:

+ Hubert Léveillé Gauvin
+ Jonathan Eldridge
+ Rhythm Jain
+ Gary Yim 
+ Dana Devlieger
+ John McNamara
+ David Temperley
+ Trevor de Clercq
+ Ashley Burgoyne
+ Ichiro Fujinaga
+ John Wild


# Contents and Format

The goal of CoCoPops is to make a large ammount of comparable melodic/harmonic data available in a consistent, standardized format.
All CoCoPops files are stored in [humdrum format](www.humdrum.org).
CoCoPops currently includes of two main sub-corpora, the *Billboard* subset and the *Rolling Stone* subset.
We plan on continuing to add more as additional datasets and corpora of popular music with melodic transcriptions become available.

The *Billboard* subcorpus contains two elements: 1) the entire [McGill Billboard Dataset](https://ddmal.music.mcgill.ca/research/The_McGill_Billboard_Project_(Chord_Analysis_Dataset)/) (Burgoyne et al., 2011) converted into humdrum format, as well as 2) new expert melodic transcriptions of (currently) 214 of these songs.
The *RollingStone* subcorpus contains the entire [RS200](http://rockcorpus.midside.com/) (de Clercq & Temperley, 2011) converted into humdrum format.
All transcriptions also include formal information and time stamps, as well as other data and metadata.
In total, CoCoPops currently includes 414 complete melodic-harmonic transcriptions of 398 unique tracks.
The complete list of songs can be found in the master [CoCoPops_Sample.tsv](CoCoPops_Sample.tsv) file.



# Directory Structure

Each subcorpus of CoCoPops is contained in its own subdirectory:

+ [Billboard](Billboard)
+ [Rolling Stone](Billboard)

Each subdirectory in this repo has its own `README` file, with detailed explanations of the directory structure and contents.

# Standards

## Filenames

In CoCoPops, all files associated with particular sampled recordings follow the same filenaming convention.
File names names are formatted as `Arist_Title_Year.extension`, with the following formatting guidelines: The `Artist` and `Title` portion of each filename contains only roman-letters and arabic numerals, no special characters (no hyphens, no apostrophes, no commas, no parenthesis, etc.) and no spaces between words. 
For instance, files associated with the song "Honey, Honey" by ABBA will all labeled `ABBA_HoneyHoney_1974`; for instance, `ABBA_HoneyHoney_1974.xml`, `ABBA_HoneyHoney_1974.mus`, and `ABBA_HoneyHoney_1974.hum`.
The spelled out word "And" is always used, never "&". 
In lieu of spaces, the first character of each word is upper case, while the rest are lower case.
Parentheticals in titles are simply removed, so Otis Reddings' "(Sittin' On) the Dock of the Bay" is just `OtisRedding_TheDockOfTheBay_1968`.
The `Year` part of the filename is the year the song was sampled, which is not necessarily the year the song was released (in the Billboard subset, it is the year the song charted on the Hot 100).


# References 

To cite this work (and for suggestions on how or who to cite depending on usage), please see [our 2023 ISMIR paper](https://www.academia.edu/108502759/THE_COORDINATED_CORPUS_OF_POPULAR_MUSICS_COCOPOPS_A_META_CORPUS_OF_MELODIC_AND_HARMONIC_TRANSCRIPTIONS) full citation reference below.

+ Claire Arthur and Nathaniel Condit-Schultz (2023). The Coordinated Corpus of Popular Musics (CoCoPops): A meta-corpus of melodic and harmonic transcriptions.<br />
  *Proceedings of the 24th International Society for Music Information Retrieval Conference (ISMIR)*, Milan, Italy.
+ David Temperley and Trevor de Clercq (2013). Statistical Analysis of Harmony and Melody in Rock Music<br />
  *The Journal of New Music Research*, Vol. 42, No. 3, pp. 187–204 
+ John Ashley Burgoyne, Jonathan Wild, and Ichiro Fujinaga (2011). An Expert Ground Truth Set for Audio Chord Recognition and Music Analysis.<br />
  *Proceedings of the International Society for Music Information Retrieval* pp. 24–28 


