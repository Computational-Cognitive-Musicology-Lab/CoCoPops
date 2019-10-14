# CoCoPops/Billboard/Humdrum

This directory contains the humdrum data for the CoCoPops billboard dataset.


## Directory organization

The `/Humdrum` directory contains three subdirectories:

+ The `CompleteTranscriptions` directory contains completed humdrum containing both the melodic and harmonic transcription data.
+ The `MelodicTranscriptions` directory contains the isolated melodic transcription files in `**kern` format, translated directly from the XML files (in `../MelodicTranscriptions/XML`).
+ The `HarmonicTranscriptions` directory contains the isolated harmonic transcription files in humdrum format, translated from the original data format.

## Current Activities

The current goal(s) for this directory include:

+ Editing the harmonic transcriptions to 
     + fix errors,
     + add detailed harmonic rhythm information.
+ Making sure the melodic transcriptions match the length of the harmonic transcriptions.
+ Align the melodic and harmonic datasets.

