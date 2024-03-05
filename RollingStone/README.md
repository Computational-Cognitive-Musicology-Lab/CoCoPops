# CoCoPops/RollingStone/

This directory contains the *Rolling Stone* subset of the **Coordinated Corpus of Popular Music**.

This repository contains a dataset of 200 melodic and harmonic transcriptions of popular songs which appear on the Rolling Stone "500 Greatest Songs of All Time" list.
This data is a simply a translation of de Clercq and Temperley's [Rolling Stone Corpus](http://rockcorpus.midside.com/) into a [humdrum](www.humdrum.org) format.
By providing this data in humdrum format, we hope to make it more accessible to a wider variety of reseachers, and easier to compare to similarly formatted data.
We've also made some other edits, fixes, and modifications to the original data.
The dataset is encoded in a [humdrum format](humdrum.org).


Early work on this project was started by Nat at McGill University in 2018.
Currently, Claire and Nat at Geogia Tech are the only people actively working on it.
Other people who have contributed to the project include:

+ Rhythm Jain
+ John McNamara


---

### Sample Information

The file `RollingStoneSampleData.tsv` contains information about the sample, all copied directly from the original data (i.e. information has not been independently verified).
Much of this information relates to Temperley and de Clercq's original release history.
[Their initial paper (2011)](https://www.cambridge.org/core/journals/popular-music/article/corpus-analysis-of-rock-harmony/C5210A8EC985DDF170B53124F4464DA4) included only a 100-song subset of the Rolling Stone list, to which they added an additional 100 songs later.
Songs in the original sample are indicated in the `RS 5x20 subset` column.
Later, [Tan, Lustig, and Temperley (2019)](https://online.ucpress.edu/mp/article/36/4/353/62973/Anticipatory-Syncopation-in-Rock-A-Corpus-Study) added lyric information to an 80-song subset: these tracks are indicated in the `Lyric subset` column.


## Directory Structure

This directory contains two subdirectories:

+ The `Data` directory contains the humdrum data for the CoCoPops *Rolling Stone* subset.
+ The `Resources` directory contains various other (potentially) useful information related to the creation of the dataset, including Temperley and de Clercq's original data format.




# Data

The dataset includes transcriptions/annotations of 200 unique songs, each in its own file, all within the `Data` subdirectory.

All 200 files include complete melodic *and* harmonic transcriptions (and additional metadata).
All these files have the file extension `.hum`.
A 80-song subset includes information about the lyrics.
These files have the extension `.lyrics.hum`.

All the files share the same humdrum-structure, with differing columns of data depending on what is included.

### Provenance

Temperley and de Clercq's main [melodic/harmonic encodings](http://rockcorpus.midside.com/) were translated into humdrum format in 2019.
Additional information, including lyrics data, formal sections, and timestamps were provided directly to us by Temperley in 2021--2022, and this information was then incorporated into our data.
Details can be found in the `Resources/Provenance.md` file.


## Humdrum Spines

The files in the Data directory are encoded in [humdrum](https://www.humdrum.org) format.
Each file contains data in independent "spines" (columns).
All files contain two `**harm` and two `**harte` spines, as well as one `**kern` and one `**timestamp` spine.
The `.lyrics.hum` files also include additional `**silbe` and `**stress` spines.


| *Files*       | `**harm`          | `**harte`         | `**kern` | `**silbe` | `**stress` | `**timestamp` |
|:--------------|-------------------|-------------------|----------|-----------|------------|---------------|
| `.hum`        | &#x2713; &#x2713; | &#x2713; &#x2713; | &#x2713; |           |            | &#x2713;      |
| `.lyrics.hum` | &#x2713; &#x2713; | &#x2713; &#x2713; | &#x2713; | &#x2713;  | &#x2713;   | &#x2713;      |
 
The content of each spine is described below.

### Melody

In de Clercq and Temperley's original melodic encodings, pitch is encoded as scale degrees (1-7) with additional marks to indicate melodic contour/leap size.
As described in `Resources/Provenance.md`, we translated these to humdrum's standard [`**kern` representation of pitch](https://www.humdrum.org/rep/kern/index.html).

In de Clercq and Temperley's original melodic encodings, rhythmic information is encode as a drum-machine-like step-sequence, indicating only at which point in each measure a note begins (leaving out offset/duration information).
In the humdrum files, `\*tb` ("timebase") interpretations indicate the step-sequence duration size, which changes dynamically as necassary.
For instance, `\*tb8` indicates that each subsequent data record is an eighth-note.

**Note that de Clercq and Temperley's "step sequence" approach means that the rhythm transcriptions only indicate onsets, not durations.**
(There are also, as a result, no rest tokens.)

Since de Clercq transcribed half of the melodies, and Temperley the other half, comment tokens in the `**kern` spine indicate which annotator: `!T.d.C` or `!D.T.` respectively.

### Harmony

Harmony information is encoded in two separate spines: `**harm` and `**harte`.
Each file actually contains *two* `**harm`/`**harte` pairs---one by Temeperley (`!D.T.`) and one by de Clercq (`T.d.C.`).
The harmonic rhythm is encoded through the same `*tb` timebase interpretations as the melodic rhythm.


The `**harm` interpretation is humdrum's standard representation of harmonic Roman numerals ("functional harmony").

The `**harte` interpretation is a newer humdrum implementation of Harte's common chord syntax, which the original McGill encodings are also based on. (See the [Star Wars Thematic Corpus](https://github.com/Computational-Cognitive-Musicology-Lab/Star-Wars-Thematic-Corpus) repo for full details on the encoding.)
These were *not* manually added via expert annotation, but rather **created by conversion** from the `**harm` interpretation. (See below for additional details.)

*Note*: Our `**harm` notation differs slightly from the humdrum standard, in a way which (we believe) reflects standard practices.
In the official `**harm` [specification](https://www.humdrum.org/rep/harm/index.html), the root of each chord is indicated relative to the prevailing key.
Thus, an Eb major chord is `-III` in the key of C major but `III` in the key of C minor.
We instead specify the roots of each chord absolutely relative to the major scale, regardless of the key.
Thus, if the root of the key is C, a major chord built on Eb is always written `-III`, regardless of whether the key is C major or C minor.
The table below elucidates the differences between our `**harm` annotations and the `**harm` standard:

|Key       |Chord    |Standard **harm |CoCoPops **harm |
|:---------|--------:|---------------:|---------------:|
|*G major* |B♯ major |`#III`          |`#III`          |
|          |B major  |`III`           |`III`           |
|          |B♭ major |`-III`          |`-III`          |
|          |B𝄫 major |`--III`         |`--III`         |
|*G minor* |B♯ major |`##III`         |`#III`          |
|          |B major  |`#III`          |`III`           |
|          |B♭ major |`III`           |`-III`          |
|          |B𝄫 major |`-III`          |`--III`         |

This approach is easier to parse and analyze, because each chord can be understood without having to reference the key interpretation.
It also means that the sometimes-subjective determinination of mode ("is it major or minor here?") has less influence on the content of the data.



#### Differences between harm and harte

Though conceptually different, the `**harm` and `**harte` spines contain essentially redundant information in the Rolling Stone subset.
The one exception is suspended fourth chords, which cannot be represented in `**harm`.
Thus, where `sus4` is indicated in the `**harte` spine, a corresponding major or minor triad is indicated in the `**harm` spine---the choice of major or minor (which is arguably innappripraite in some cases) is based off de Clercq and Temperley's original annotations.

### Lyrics

Lyrics (only in an 80-song subset) are encoded in humdrum's standard [`**silbe` (syllable-wise) representation](https://www.humdrum.org/guide/ch27/).
In addition, a `**stress` spine indicates two levels of syllable stress, `1` and `0`.
This stress data was derived algorithmically, and may not be perfectly accurate (see [Tan, Lustig, and Temperley (2019))](https://online.ucpress.edu/mp/article/36/4/353/62973/Anticipatory-Syncopation-in-Rock-A-Corpus-Study)).

### Timestamp

The `**timestamp` spine simply includes the timestamp of each measure in the original recording, in seconds.
These timestamps were provided to us directly by David Temperley.

### Formal Sections

Section labels, provided to us directly by David Temperley are encoded in humdrum format, as interpretations records beginning with `*>`.

## Metadata

### Key, Meter, Tempo

Many standard musical features are indicated in humdrum "tandem" interpretations in relevant spines.
These include key (A major = `*A:`), time signature (4/4 = `*M4/4`), and tempo ($100_{bpm}$ = `*MM100`).
These features can change dynamically, indicating changes of key, meter, or tempo as needed.

Note that Temperley and de Clercq did not distinguish between *modes*, only tonics.
They made this decision for theoretical reasons (because mode is often ambiguous).
We have incorporated the distinction between major and minor modes into all of our files (manually), indicated in standard humdrum format: e.g., `E-:` for Eb-major, and `e-:` for Eb-minor.


### Reference Records

Metadata about each piece, and each piece's place in Temperley and de Clercq's sampling scheme, is encoded in reference records (beginning `!!!`) at the beginning and end of each file.

Info about the song:

+ `!!!OTL:` Name of song
+ `!!!COC:` Name of artist 
+ `!!!RRD:` Release date

Info about sampling:

+ `!!!Rolling Stone List Rank`: Rank in 500-greatest list
+ `!!!In original RS 5x20 subset:` Is this one of the first 100 de Clercq and Temperley transcribed?

Info about the encoding:

+ `!!!ONB:` About the encoding
+ `!!!YOE:` Original transcribers

