# 0.9.1.0 (2024-02-09)

## Changes

In the Billboard dataset, we have finished the process of translating our previous `**harmony` chord symbols into [roman numerals](https://en.wikipedia.org/wiki/Roman_numerals).
Specifically, we are using a [slightly modified](Billboard/README.md###Harm) version of humdrum's standard [`**harm` interpretation](https://www.humdrum.org/rep/harm/index.html).

In order to create accurate roman numerals, we made numerous small fixes to the harmonic transcriptions, mostly regarding the *keys* of the transcriptions.
The original McGill harmonic transcriptions often omit key changes, an in a few cases simply mislabel the key.
They also sometimes *mispell* chords given the key---for example, spelling a chord Db minor in the key of E major---which leads to weird roman numerals.
There are still some places where interpreting the key or how to "spell" a chord in the key is genuinely difficult (check out "Do I Do" by Stevie Wonder for example!), but for the most part we've fixed things so the roman numerals come out reasonable.


----

We have also taken some steps to keep the "original" `**harte` annotations in an exact one-to-one relationship with symbols in the McGill "Mirex files."
Most notably, we have pulled all of McGill's timestamps into our files, so nearly every chord has a timestamp associated with it.




# 0.9.0.0 (2023-11-22)

## Changes 

We've incorporated updated (better aligned) versions of the Billboard valence-arousal subset files.


## Notes

The dataset is now *almost* entirely complete and consistent with what we described in our 2023 paper in the proceedings of *International Conference for Music Information Retrieval* ([ISMIR 2023](https://ismir2023.ismir.net/)).
We have a few things to wrap up, but should have those finished in the next month.
