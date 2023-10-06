# CoCoPops/RollingStone/

This repository contains a dataset of 200 melodic and harmonic transcriptions of popular songs which appear on the Rolling Stone "500 Greatest Songs of All Time" list.
This dataset is part of a larger **Coordinated Corpus of Popular Music** project, led by Nat Condit-Schultz and Claire Arthur, in the [Computational and Cognitive Musicology Lab](https://ccml.gtcmt.gatech.edu/) in the Georgia Tech [Center for Music Technology](https://gtcmt.gatech.edu/).
This data is a simply a translation of de Clercq and Temperley's [Rolling Stone Corpus](http://rockcorpus.midside.com/) into a [humdrum](www.humdrum.org) format.
By providing this data in humdrum format, we hope to make it more accessible to a wider variety of reseachers, and easier to compare to similarly formatted data, like the [CoCoPops/Billboard corpus](https://github.com/Computational-Cognitive-Musicology-Lab/CoCoPops-Billboard).

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
The `FileName` column indicates the root filename (sans extension) used for all files in the dataset associated with that song.
For instance, files associated with the song "With Or Without You" by U2 will all labeled `U2_WithOrWithoutYou_1987`; for instance, `U2_WithOrWithoutYou_1974.xml`, `U2_WithOrWithoutYou_1974.mus`, or `U2_WithOrWithoutYou_1974.hum`.
These file names are formatted as follows `Arist_Title_Year.extension`, with the following formatting guidelines: The `Artist` and `Title` portion of each filename contains only roman-letters and Arabic numerals, no special characters (no hyphens, no apostrophes, no commas, no parenthesis, etc.) and no spaces between words. 
The spelled out word "And" is always used, never "&". 
In lieu of spaces, the first character of each word is upper case, while the rest are lower case.
Parentheticals in titles are simply removed, so Otis Reddings' "(Sittin' On) the Dock of the Bay" is just "OtisRedding_TheDockOfTheBay_1968".
The `Year` part of the filename is only the first year the song was sampled, which is not necessarily the year the song was released.

`RollingStoneSampleData.tsv` contains information about the sample, all copied directly from the original data (i.e. information has not been independently verified).
Much of this information relates to the Temperley and de Clercq's original release history.
Their initial paper (2011) included only a 100-song subset of the Rolling Stone list, to which they added an additional 100 songs later.
Songs in the original sample are indicated in the `RS 5x20 subset` column.
Later, Tan, Lustig, and Temperley (2019) added lyric information to an 80-song subset: these tracks are indicated in the `Lyric subset` column.

Finally, links to each song on YouTube are present in the `YoutubeLink` column!

----

The root directory contains three subdirectories:

+ The `OriginalData` directory contains the original, unaltered dataset.
+ The `Humdrum` directory containing the humdrum-formatted files.
+ The `Scripts` directory contains a variety of scripts (Bash, Awk, and R) used in the project.


