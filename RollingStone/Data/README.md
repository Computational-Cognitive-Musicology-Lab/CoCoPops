# CoCoPops/RollingStone/Humdrum/


For this project, a Haskell program was created to translate Temperley and de Clercq's original encodings into the humdrum syntax, with the four original files (2 x .txt, .mel, and .fl) encoded into four separate spines of a single humdrum file.
This program was created and run in 2019 by Nat Condit-Schultz;
Information about this initial data translation process is contained below, with additional details in the "WorkLog" file.
(A number of errors in the original data are documented in the work log.)

The current version of the humdrum data set is located in the `Humdrum` directory.

---

In 2021, Rhythm Jain worked with Nat to add incorporate the additional lyrical information for the 80-song subset into the humdrum files, as `**silbe` and `**stress` spines.

## HumdrumFiles

A Haskell parser translates and combines the original melodic and harmonic transcriptions into a single humdrum file, using `\*tb` (timebase) for melodic rhythm.

Two songs (*Layla* and *Crazy*) have key changes mid measure, which the parser is not ready for.
these were manually fixed *after* auto parsing was complete.
(In *Layla*, one of the two harmonic transcriptions also failed to change keys mid measure.)

*Shout* has a weird "commented" breakdown which does not work with the parser. The `|` bars from this passage were changed to `:`, so the parser doesn't trip on it.
*Strawberry Fields* has the same problems.

### Tempos

The file `../Tempos.tsv` lists the bpm(s) for each file, based on author NCS tapping along to them using the (https://www.all8.com/tools/bpm.htm) tool.
Using the `../Scripts/InsertTempos.R` script (**CURRENTLY BROKEN**), these tempos can be inserted into the humdrum files.
For files with multiple tempos, the actual location of tempo changes in the humdrum file has to be input manually (for now.)


## Pitch

In de Clercq and Temperley's original melodic encodings, pitch is encoded as scale degrees (1-7) with additional marks to indicate melodic contour/leap size.
de Clercq and Temperley indicate the tonic note and the diatonic scale for each piece, including various diatonic modes.
In the humdrum files, we use the standard humdrum a `\*\*deg` interpretation:
Numerals 1--7 indicate the natural scale degree of each pitch, given the key/mode.
`b` and `#` symbols indicate alterations relative to the mode.
By default, each successive scale degree is assumed to be the pitch closest the previous note---*tritones are assumed to be upward, regardless of their spelling*!
One or more `^` and `v` symbols are used to indicate violations of this, with multiple `v` or `^` indicating additional octaves.

---

In March 2022, author NCS used the latest version of `humdrumR` and some additional fiddling (to deal with tritones) to translate the `**deg` representation to `**kern`.
After some time inspecting various songs, they now should all be correct.

## Rhythm

In de Clercq and Temperley's original melodic encodings, rhythmic information is encode as a drum-machine-like step-sequence, indicating only at which point in each measure a note begins (leaving out offset/duration information).
In the humdrum files, `\*tb` interpretations indicate the step-sequence duration size, which changes dynamically as necassary.
For instance, `\*tb8` indicates that each subsequent data record is an eighth-note.

**Note that de Clercq and Temperley's "step sequence" approach means that the rhythm transcriptions only indicate onsets, not durations.**
(There are also, as a result, no rest tokens.)

