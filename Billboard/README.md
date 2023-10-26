# CoCoPops/Billboard


This directory contains the *Billboard* subset of the **Coordinated Corpus of Popular Music**.

This Billboard subset includes harmonic and melodic transcriptions of popular songs which charted on Billboard Hot 100 list between 1959 and 1991.
This dataset is based off an existing dataset of 739 harmonic annotations created at McGill University in the period 2010-2012: the [McGill Billboard Project]("https://ddmal.music.mcgill.ca/research/The_McGill_Billboard_Project_(Chord_Analysis_Dataset)/").
We have (as of now) added melodic transcriptions to 214 of these transcriptions and human arousal/valence ratings to 100.
We've also made a number of other edits, fixes, and modifications ot the McGill data.
The dataset is encoded in a [humdrum format](humdrum.org).

This project started at Ohio State, led by Hubert Gauvin, Claire Arthur, and Nat Condit-Schultz, with the help of Gary Yim and Dana Devlieger.
Since other people who have contributed to the project include:

+ Jonathan Eldridge
+ Rhythm Jain
+ John McNamara

---

### Sample Information

In this directory, in addition to this README file, there is a tab-delineated spread sheet of information about the corpus: [Billboard_Sample.tsv](Billboard_Sample.tsv).
This file contains information about the sample, all copied directly from the original McGill data (i.e. information has not been independently verified).
Much of this information relates to the original McGill project's sampling scheme:
The original sampling scheme (Burgoyne, 2011) called for 1,300 chart positions to be targeted for sampling, but data for only 890 positions could be gathered. 
In addition, many songs were sampled more than once so this 890 actually only represents 739 unique recordings.
In the `Billboard_Sample.tsv` file, songs which are sampled more than once have multiple data points filled into some columns, separated by ", ".


## Directory Structure

This directory contains two subdirectories:

+ The `Data` directory contains the actual humdrum data files.
+ The `Resources` directory contains various other (potentially) useful information related to the creation of the dataset.


