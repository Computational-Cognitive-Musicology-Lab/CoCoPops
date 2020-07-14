This dataset is a translation of de Clercq and Temperley's Rolling Stone Corpus (http://rockcorpus.midside.com/) into the humdrum (www.humdrum.org) format.
Information about the initial data translation process are contained in the file WorkLog.txt.


In the original release of the Rolling Stone Corpus, de Clercq and Temperley encoded their transcriptions in a novel, non-standardized, encoding scheme.
For each of the two hundred songs, two harmonic transcriptions (one by each author; .txt files) and one melodic transcription (by one or the other author; .mel files) are encoded in three separate text files.
In addition, timestamp information (timestamps for each downbeat in the recording) are also encoded in a separate file (.tim files).
This puts the data into four separate files.

For this project, a Haskell program was created to translate these encodings into the humdrum syntax, with the four original files encoded in four spines of a single humdrum file.
Using humdrum makes the data accessible to humdrum tools, and also allows us to include metadata for each song in the file, using humdrum tandem interpretations and reference records.


## Pitch

In de Clercq and Temperley's original melodic encodings, pitch is encoded as scale degrees (1-7) with additional marks to indicate melodic contour/leap size.
de Clercq and Temperley indicate the tonic note and the diatonic scale for each piece, including various diatonic modes.
In the humdrum files I've produced (in the \*\*deg spine) numerals 1-7 indicate the natural scale degree of each pitch, given the key/mode.
"b" and "#" symbols indicate alterations relative to the mode.
By default, each successive scale degree is assumed to be the pitch closest the previous note.
One or more "^" and "v" symbols are used to indicate violations of this, with multiple "v" or "^" indicating additional octaves.


## Rhythm

In de Clercq and Temperley's original melodic encodings, rhythmic information is encode as a drum-machine-like step-sequence, indicating only at which point in each measure a note begins (leaving out offset/duration information).
In the humdrum files I've produced, \*tb interpretations indicate the step-sequence duration size, which changes dynamically as necassary.
For instance, \*tb8 indicates that each subsequent data record is an eighth-note.

Note that de Clercq and Temperley's "step sequence" approach means that the rhythm transcriptions only indicate onsets, not durations.
(There are also, as a result, no rest tokens.)
