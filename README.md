This dataset is a translation of de Clercq and Temperley's Rolling Stone Corpus (http://rockcorpus.midside.com/) into the humdrum (www.humdrum.org) format.
Using humdrum makes the data accessible to humdrum tools, and also allows us to include metadata for each song in the file, using humdrum tandem interpretations and reference records.

The files `RollingStoneSampleData.txt` is a table of metadata about the pieces, which was used to populate the reference records of the humdrum files.


# Original Data


In the original release of the Rolling Stone Corpus, de Clercq and Temperley encoded their transcriptions in a novel, non-standardized, encoding scheme.
The dataset includes, for each of the two hundred songs, two harmonic transcriptions (one by each author; `.txt` files) and one melodic transcription (by one or the other author; `.mel` files) are encoded in three separate text files.
In addition, timestamp information (timestamps for each downbeat in the recording) are also encoded in a separate file (`.tim` files).
This puts the data into four separate files in the `OriginalData` directory.
Later, Tan, Lustig, and Temperley (2019) annotated the lyrics, including syllable stress estimates, for a subset of 80 of the 200 tracks.
This data is encoded in 80 `.str` files in the `OriginalData` directory.


----

# CoCoPops Dataset


For this project, a Haskell program was created to translate the original encodings into the humdrum syntax, with the four original files encoded in four spines of a single humdrum file.
This program was created and run in 2019 by Nat Condit-Schultz;
Information about this initial data translation process is contained in the file `WorkLog.md`.

The current version of the humdrum data set is located in the `Humdrum` directory.

---

In 2021, Rhythm Jain worked with Nat to add incorporate the additional lyrical information for the 80-song subset into the humdrum files, as `**silbe` and `**stress` spines.


## Pitch

In de Clercq and Temperley's original melodic encodings, pitch is encoded as scale degrees (1-7) with additional marks to indicate melodic contour/leap size.
de Clercq and Temperley indicate the tonic note and the diatonic scale for each piece, including various diatonic modes.
In our humdrum files, we use the standard humdrum a `\*\*deg` interpretation:
Numerals 1--7 indicate the natural scale degree of each pitch, given the key/mode.
`b` and `#` symbols indicate alterations relative to the mode.
By default, each successive scale degree is assumed to be the pitch closest the previous note.
One or more `^` and `v` symbols are used to indicate violations of this, with multiple `v` or `^` indicating additional octaves.


## Rhythm

In de Clercq and Temperley's original melodic encodings, rhythmic information is encode as a drum-machine-like step-sequence, indicating only at which point in each measure a note begins (leaving out offset/duration information).
In our humdrum files I've produced, `\*tb` interpretations indicate the step-sequence duration size, which changes dynamically as necassary.
For instance, `\*tb8` indicates that each subsequent data record is an eighth-note.

Note that de Clercq and Temperley's "step sequence" approach means that the rhythm transcriptions only indicate onsets, not durations.
(There are also, as a result, no rest tokens.)
