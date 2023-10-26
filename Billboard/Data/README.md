# CoCoPops/Billboard/Data/

This directory contains the humdrum data for the CoCoPops Billboard subset.
The dataset includes transcriptions/annotations of 739 unique records, each in its own file.

Currently, 214 files contain complete melodic *and* harmonic transcriptions (and additional metadata).
These files have the file extension `.hum`.
A 100-file subset of these will soon include real-time human-participant valence and arousal data, as well as rolling RMS signal level.
These files have the extension `.varms.hum`.
The remaining 525 files contain "only" the original McGill harmonic transcription data.
These files have the extension `harm`.

+ `.harm` --- 525 --- Only harmonic transcriptions.
+ `.hum` --- 214 files --- Melodic and harmonic transcriptions.
  + `.varms.hum` --- 100 file subset of `.hum` --- Also include valence and arousal data.

All the files have the `.hum` extension, and share the same humdrum-structure:

## Provenance

Initially (in early 2017), the original McGill Billboard data files were parsed and converted to humdrum format.
The original files were accessed from [this McGill DDMAL website](https://ddmal.music.mcgill.ca/research/The_McGill_Billboard_Project_(Chord_Analysis_Dataset)){target="\_blank"} in December 2016, and are contained elsewhere in the repository (`../Resources/McGill_Data`).
The scripts used to conduct the translation, written in **R 3.3.2**, are contained in the directory `../Resources/Scripts/Legacy/McGillToHumdrum`.

In the subsequent years, melodic transcriptions were made in notation software and exported to musicXML (see the `../Resources/Transcription` directory).
These XML files were then converted to humdrum format, and aligned with the harmonic humdrum files.

The final "complete" harmonic/melodic files have been edited since then, and should be regarded as the master copies of the data.


# Humdrum Spines

The files in this directory (`.harm` and `.hum`) are encoded in [humdrum](https://www.humdrum.org) format.
Each file contains data in independent (columnar) "spines" of data.
All files contain `**harm`, `**harte`, `**timestamp`, `**phrase`, and `**leadinstrument` spines.
The `.hum` files add one or more pairs of `**kern` and `**silbe` spines, as well as a `**rhyme` spine.
The `.varms.hum` files also contain spines `**valence`, `**arousal`, and `**rms`.


| *Files*      | `**harm` | `**harte` | `**kern` | `**silbe` | `**rhyme` | `**timestamp` | `**phrase` | `**valence` | `**arousal` | `**rms`  |
|:-------------|----------|-----------|----------|-----------|-----------|---------------|------------|-------------|-------------|----------|
| `.harm`      | &#x2713; | &#x2713;  |                                  | &#x2713;      | &#x2713;   |             |             |          |
| `.hum`       | &#x2713; | &#x2713;  | &#x2713; | &#x2713;  | &#x2713;  | &#x2713;      | &#x2713;   |             |             |          |
| `.varms.hum` | &#x2713; | &#x2713;  | &#x2713; | &#x2713;  | &#x2713;  | &#x2713;      | &#x2713;   | &#x2713;    | &#x2713;    | &#x2713; |

The content of each spine is described below.

## Harmony

Harmony information is encoded in two seprate spines: `**harm` and `**harte`.
The `**harm` interpretation is humdrum's standard representation of harmonic roman numerals ("functional harmony").
The `**harte` interpretation is a newer humdrum implementation of Harte's common chord syntax, which the original McGill encodings are also based on.

The harmonic rhythm is encoded as humdrum-standard `**recip` rhythm tokens attached to the `**harm` tokens.


### Differences between harm and harte

The original McGill Billboard harmony encodings don't really encode "harmonies" in the classical sense, but rather jazz-style chord symbols.
These chord symbols are essentially shorthand descriptions of pitch-class sets, and are specifically intended to represent the pitch-class set played by the accompanying instrument.
The `**harte` spine faithfully reproduces these.

In contrast, our `**harm` annotations are derived from the original McGill annotations, but have been abstracted (manually and automatically) to encode more abstract "harmonies," as understoond in the classical tradition of analysis.
All chords are annotated as triads (major, minor, augmented, or diminished) or seventh chords (major, dominant, minor, half-diminished, or diminished).
In order to translate the original chord symbol tokens to the smaller set of harmonic qualities a set of substitutions had to be identified.
Fortunately, many of these substitutions were already identified by the original researchers: DDMAL/McGill hosts a collection of "Mirex" files which contain a simplified chord-quality vocabulary; the substitutions/simplifications used in these files, currently stored in the file "../Scripts/McGillToHumdrum/MirexSubstitutions", were used as the basis for most chord symbol -> quality translations.
Unfortunately, these substitutions use too small a set of simplified qualities (only M, m, Mm, MM, mm)---other substitutions are marked as "X".
Thus, the translation script introduces a few more obvious substitutions (especially to diminished and augmented triads).
Nonetheless, the appropriate substitution for a number of tokens was not obvious, in which cases Xs were placed in the transcriptions, and later manually fixed.

Another difference between the `**harm` and `**harte` encodings is in the treatment of so-called "implied harmony."
Many chords in the `**harte` notation are encoded simply "5" (indicating simply root and fifth) or "1" (root only).
These tokens are ambiguous as to what the "true" triadic harmonic quality is.
Another ambiguous token is variations of "sus4" or "sus2."
The translation script makes two guesses at the appropriate quality for these chords:

+ First, it looks within the same piece at other chord-symbols with the same root, and if only one unique quality exists, it takes that quality.
  For instance, if a song contains a token "B:5," but also contains the token "B:m," but not other tokens with "B" as the root, the "B:5" token is translated to "B:m".
+ If the first approach doesn't work, the script looks at where the root of the chord fits in the current key and guesses the quality based on this.
  For instance, "F#:5" in the key of A major is most likely "F#:m."
  In some cases, the script still failed to identify the correct key.
  These examples have been manually edited.

## Melody and lyrics

Melodic parts and associated lyrics are recorded in pairs of `**kern` and `**silbe` spine, both standard humdrum representations.
The `**kern` tokens, following standard practice, begin with a `**recip` indication of the rhythmic duration, followed by the pitch information.
The `**silbe` representation shows lyrics broken up into syllables, aligned with each note in the `**kern` line.

The `**rhyme` spine indicates where rhymes occur in the lyrics.
Pairs of syllables that rhyme with each other labeled with arbitrary letters, A, B, C, D, etc.
Multi-syllable rhymes are indicated by connecting letters with parentheses; e.g., (A B), (A B).

## Phrase and Instrument

The `**phrase` spine indicates where line-breaks occur in the original McGill transcriptions.
The exact musical significance of this segmentation is not clear, but they are supposed to indicate "each musical phrase or other sonic element at a comparable level of musical structure."

The `**leadinstrument` spine is also copied directly from the original transcriptions, apparently indicating what the dominant instrument (usually voice) is in each phrase.

> "'Leading instruments' are noted where...there is a notable deviation from the norm of a leading vocal throughout the entire song."

## Timestamp

The `**timestamp` simply copies the timestamps from the original files, rounded to the nearest one-hundredth of a second.


# Metadata

## Key, Meter, Tempo

Many standard musical features are indicated in humdrum "tandem" interpretations in relevant spines.
These include key (A major = `*A:`), time signature (4/4 = `*M4/4`), and tempo ($100_{bpm}$ = `*MM100`).
These features can change dynamically, indicating changes of key, meter, or tempo as needed.

## Voice 



CoCoPops billboard transcriptions are meant to represent the "main" or "lead" vocal part of each song in the sample.
All `**kern` spines thus include a `*ICvox` token to indicate that the "instrument class" is voice.
However, each scribe determined which the "main" part was.
In many cases, more than one vocal part is active in a song, and one part is not clearly the "main" vocal.

The most difficult case is when multiple voices sing in harmony throughout a song and it is not clear which voice is the "main" melody---in some cases, either or both vocal parts might be equal.
We refer to these as ambiguous cases.
In other cases, multiple singers alternate, and the overall "gist" of the main part is a combination of the two parts---we call these "complex" cases.
CoCoPops transcribers in some cases transcribed more than one "main" vocal line, either because 1) they judged that the "main" part was either ambiguous or complex or 2) they simply wished to transcribe the remaining parts.

---

In CoCoPops transcriptions, we label vocal parts with tandem interpretations classifying the "role" of the vocal part.
We recognize five roles:

+ **Lead** (`*VRlead`)
  + The "lead" vocal part at any given time.
+ **Lead harmony** (`*VRharmony`)
  + A part "harmonizing" the lead part in rhythmic unison (or near unison).
+ **Backing** (`*VRbacking`)
  + A accompanying part that serves as rhythmic texture, often singing behind the lead part.
+ **Call** (`*VRcall`) and **Response** (`*VRresponse`)
  + An alternation of the "lead" line between two groups of voices.
+ **Riffing** (`*VRriff`)
  + Improvisatory melodic lines, often overdubbed on top of a main lead part.

Each `**kern` spine in each contains at least one vocal role interpretation.
In some cases, vocal roles may change dynamically throughout a piece.

---

In addition, we mark `*Hstimme` and `*Nstimme` to indicate the primary and secondary voices, respectively, at any given time. 
This notation refers to the German term [Haupstimme](https://en.wikipedia.org/wiki/Hauptstimme), invented by Arnold Schoenberg.
`*]stimme` can be used to indicate the end of the previous stimme indication---traditionally marked &#119208; in scores.
These tandem interpretations may dynamically jump between spines on a measure-by-measure basis, sometimes even changing within a vocal phrase.





## Formal Sections

Section labels from the original transcriptions are encoded in humdrum format, as interpretations records beginning with `*>`.
The original McGill files contain two parallel but (somewhat) distinct formal labellings: abstract letters (A, B, C, etc.) and stylistic names (verse, chorus, etc.).
The letter names are usually associated with the chord progression, while the names are associated with the melody/lyrics and or instrumentation.
These annotations are represented in separate humdrum formal label records, starting `*>Letter>` and `*>Label>` respectively.





## Reference Records

True metadata about each piece, and each piece's place in the original McGill Billboard sampling scheme, is encoded in reference records (beginning `!!!`) at the end of each file.

First info about the song:

+ `!!!OTL:` Name of song
+ `!!!COC:` Name of artist (from McGill, not independently verified).

Some songs were sampled multiple times in the scheme---each of these songs has multiple data points (separated by `,`) for the following six records.
The information in these records is copied straight from the McGill data, and has not been independently verified:

+ `!!!BillboardChartDate:` self explanatory
+ `!!!BillboardPeak:` peak position on Billboard chart
+ `!!!BillboardWeeksOnChart:` peak position on the Billboard chart
+ `!!!SampleTargetRank:` An aspect of the McGill sampling scheme. 
+ `!!!SampleActualRank:` An aspect of the McGill sampling scheme. 
+ `!!!SampleID#:` A number identifying one of the 1300 positions in the McGill sample. Songs sampled more than once have more than one number.

Finally, reference data about the encodings:

One `!!!RDF**` record describing, in short, each of the spines in the file.
Plus:

+ `!!!RDT:` Date the encoding was created (i.e. translated from McGill files).
+ `!!!ENC:` Creator of transcription (Me, since I did it using a script).
+ `!!!EST:` Encoding editing status...all "awaiting editing."
+ `!!!EMD:` Place for taking notes on modifications.


# Valence and Arousal

The `**valence` and `**arousal` spines each record four independent, real-time human ratings of valence (positive/negative) and arousal (high/low) respectively.
The four responses at each time stamp are recorded in four, space-separated humdrum "multi stops."
These responses are recorded on a scale of 0 to 127, with higher numbers associated with positive valence and high arousal.

In addition, the `**rms` scales indicates the rolling root-mean-square signal level from the audio recording, on a decibel scale.


