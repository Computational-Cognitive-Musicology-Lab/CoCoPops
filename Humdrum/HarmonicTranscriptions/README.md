# CoCoPops/Billoard/Humdrum/HarmonicTranscriptions/

This directory contains harmonic transcriptions of the entire McGill Billboard dataset in humdrum format.
These humdrum files were translated automatically from the original McGill Billboard data files.
These original files were accessed from [this McGill DDMAL website](https://ddmal.music.mcgill.ca/research/The_McGill_Billboard_Project_(Chord_Analysis_Dataset)){target="\_blank"} in December 2016, and are contained elsewhere in the repository (`../../McGillData`).
The scripts used to conduct the translation, written in **R 3.3.2**, are contained in the directory `../../Scripts/McGillToHumdrum`.

There are two subdirectories, each containing a complete collection of the files:

+ The `Unedited` directory contains the humdrum files as they were originally translated.
+ The files in the `Edited` directory have had error corrections made: For instance, adding missing key changes or fixing chord errors.
  All edits are described in `!!!EMD:` reference records at the end of each file (the name of editor and the date of the edit is also noted here).

All the files have the `.hum` extension, and share the same humdrum-structure:

## Humdrum Spines

In each harmonic transcription file, the spines are labelled `**harmony`, `**chordsym`, `**phrase`, `**timestamp`, and `**leadinstrument`.

The `**harmony` spine encodes three pieces of information:


1. Rhythmic information, encoded in \*\*recip format. 
   These rhythms are straightforward extrapolations of the rhythmic encoding in the original files which are is always rounded to the nearest quarter note.  
   As part of the current project, more rhythmic details (i.e. 8th-note syncopations) will be added.
   Rest are encoded a-la \*\*kern, as `r`, often with `;` to indicate a fermata.
2. The chord root, encoded as a pitch-class (i.e., ignoring octave) with **kern-style accidentals (`#` = sharp, `-` = flat). 
   This information is also a 1-1 translation from the original data files.
   However, some roots are not labelled logically in the original key, for instance B in the key of Gb which should be labelled C-, and must be edited.
   `N`, as in the original data, indicates "no harmony," with no quality.
3. The chord quality. 
   The original McGill Billboard data files don't really encode "harmonies" in the classical sense, but rather jazz-style chord symbols.
   The chord symbols are more akin to figure bass than roman numerals---they are simply shorthand for pitch-class sets, and are specifically intended to represent the pitch-class set played by the accompanying instrument.
   The current project is interested in encoding more abstract "harmonies."
   A much more limited set of possible harmonies are theoretically recognized:
   In some cases, only the quality of the triad may be all that is of interest (Major, Minor, Augmented, or Diminished).
   In other cases, the quality of the seventh (if present) is also of interest.
   Thus, the set of possible harmonic tokens is limited to four types of triads M, m, A, d, and six types of seventh chords: Major (MM), Dominant (Mm), Minor (mm), Half-diminished (dm), fully-diminished, and augmented (Am).
   The first letter in each these seventh chord tokens identifies the triad type---thus 7ths can be easily ignored.

   In order to translate the original chord symbol tokens to the smaller set of harmonic qualities a set of substitutions had to be identified.
   Fortunately, many of these substitutions were already identified by the original researchers: DDMAL/McGill hosts a collection of "Mirex" files which contain a simplified chord-quality vocabulary; the substitutions/simplifications used in these files, currently stored in the file "../Scripts/McGillToHumdrum/MirexSubstitutions", were used as the basis for most chord symbol -> quality translations.
   Unfortunately, these substitutions use too small a set of simplified qualities (only M, m, Mm, MM, mm)---other substitutions are marked as "X".
   Thus, the translation script introduces a few more obvious substitutions (especially to diminished and augmented triads).
   Nonetheless, the appropriate substitution for a number of tokens was not obvious, in which cases Xs were placed in the transcriptions.
   Replacing these Xs with appropriate quality symbols will be part of the current project's editing process.

   Another difference between encoding harmonies and encoding chord symbols is so called "implied harmony."
   Many tokens in the original chord-symbol data simply encode "5" (indicating simply root and fifth) or "1" (root only).
   These tokens are ambiguous as to what the "true" triadic harmonic quality is.
   Another ambiguous token is variations of "sus4" or "sus2."
   The translation script makes two guesses at the appropriate quality for these chords:
   + First, it looks within the same piece at other chord-symbols with the same root, and if only one unique quality exists, it takes that quality.
     For instance, if a song contains a token "B5," but also contains the token "Bmin," but not other tokens with "B" as the root, the "B5" token is translated to "Bmin".
   + If the first approach doesn't work, the script looks at where the root of the chord fits in the current key and guesses the quality based on this.
     For instance, "F#5" in the key of A major is most likely "F#min."
     In some cases, the script still failed to identify the correct key.
     In the case of "sus4" and "sus2" chords, the "sus4" and "sus2" tokens remain.
     In other cases, a `X` is placed.
     Since the translation script may be making mistakes, qualities identified by the script are marked with a ?.
     Part of the editing task of this project, is changing these tokens to the appropriate token.

The `**chordsym` spine simply encodes the original chord-symbol token.
The set of pitch-classes implied by the symbol is also identified in parentheses.
The bass-note is placed as the first pitch-class within the parentheses.
The order of the remaining notes does is simply their order within the chord, it does NOT represent the voicing in the real music.
`r` is used to indicate silence, and `N` indicates no chord.

The `**phrase` spine indicates where line-breaks occur in the original McGill transcriptions.
The exact musical significance of this segmentation is not clear, but they are supposed to indicate "each musical phrase or other sonic element at a comparable level of musical structure."

The `**timestamp` simply copies the timestamps from the original files, rounded to the nearest one-hundredth of a second.

The `**leadinstrument` spine is also copied directly from the original transcriptions.

> "'Leading instruments' are noted where...there is a notable deviation from the norm of a leading vocal throughout the entire song."

`r`s for rest are included in this spine as well.

## Metadata

### Sections

Section labels from the original transcriptions are encoded in humdrum format, as interpretations records beginning with `*>`.

> One thing that should be edited for consistency in all transcriptions is how sections are labeled. 
> One inconsistency I have noticed is that some times transcribers split succesive verses into two, while other times they just call it one long verse.
> *Nat Condit-Schultz, 2017-01-18*

### Reference Records

Finally, metadata about each piece, and each piece's place in the original McGill Billboard sampling scheme, is encoded in reference records (beginning `!!!`) at the end of each file.

First info about the song:

+ `!!!OTL:` Name of song
+ `!!!COC:` Name of artist (from McGill, not independently verified).

Some songs were sampled multiple times in the scheme---each of these songs has multiple data points (separated by `,`) for the following six records.
The information in these records is copied straight from the McGill data, and has not been independently verified.

+ `!!!BillboardChartDate:` self explanatory
+ `!!!BillboardPeak:` peak position on Billboard chart
+ `!!!BillboardWeeksOnChart:` peak position on the Billboard chart
+ `!!!SampleTargetRank:` An aspect of the McGill sampling scheme. 
+ `!!!SampleActualRank:` An aspect of the McGill sampling scheme. 
+ `!!!SampleID#:` A number identifying one of the 1300 positions in the McGill sample. Songs sampled more than once have more than one number.

Finally, reference data about the encodings:

One `!!!RDF**` record describing, in short, each of the five spines.
Plus:

+ `!!!RDT:` Date the encoding was created (i.e. translated from McGill files using my R script).
+ `!!!ENC:` Creator of transcription (Me, since I did it using a script).
+ `!!!EST:` Encoding editing status...all "awaiting editing."
+ `!!!EMD:` Place for taking notes on modifications.




