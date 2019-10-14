# CoCoPops/Billoard/Humdrum/MelodicTranscriptions

This directory contains melodic transcriptions of (a subset) of the McGill Billboard dataset in humdrum format.
These humdrum files were translated automatically from the XML transcriptions in `../../MelodicTranscriptions/XML`.
All edits made to them should be matched in the XML---or better yet, the changes should be made to the XML and then retransalted to humdrum.

All the files have the `.krn` extension, and share the same humdrum-structure:

## Humdrum Spines

In each harmonic transcription file, the spines are labelled `**kern` and `**silbe`.
Each file has at least one `**kern`/`**silbe` pair.
Some files, have two or more pairs (to reflect multiple parts in the XML file).
