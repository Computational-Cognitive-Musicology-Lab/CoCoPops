# CoCoPops/RollingStone/OriginalData/

This directory contains the original data created by Temperley, de Clercq, Lustig, and Tan.
These files were accessed from (http://rockcorpus.midside.com/){target="\_blank"} in 2019.

---

In the original release of the Rolling Stone Corpus, de Clercq and Temperley encoded their transcriptions in a novel, non-standardized, encoding scheme.
The dataset includes, for each of the two hundred songs, four separate text files: two harmonic transcriptions (one by each author; `.txt` files), one melodic transcription (by one or the other author; `.mel` files), and timestamp information (timestamps for each downbeat in the recording; `.tim` files). 

---

Later, Tan, Lustig, and Temperley (2019) annotated the lyrics, including syllable stress estimates, for a subset of 80 of the 200 songs.
This data is encoded in 80 `.str` files in the `OriginalData` directory.

----

We include a compiled, ``assembled'' version of the files, that were shared by David Temperely, containing all of the above information (melody, harmony, timestamps) along with formal labels for each song. These ``combination'' files are encoded as `.fl` files in their own `Assembled` subdirectory.


