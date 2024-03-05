# CoCoPops/RollingStone/Resources/

As described in the `OriginalData/README.md` file, Temperley and de Clercq's the original dataset includes, for each of the two hundred songs, four separate text files: two harmonic transcriptions (one by each author; .txt files), one melodic transcription (by one or the other author; .mel files), and timestamp information (timestamps for each downbeat in the recording; .tim files).
For this project, we created Haskell program to translate these original encodings into the humdrum syntax, with the four original files (2 x .txt, .mel, and .fl) encoded into four separate spines of a single humdrum file. 
This program was created and run in 2019 by Nat Condit-Schultz;
Information about this initial data translation process is contained below.
(A number of errors in the original data are documented at the bottom.)

In 2021, Rhythm Jain worked with Nat to add incorporate the additional lyrical information for the 80-song subset into the humdrum files, as `**silbe` and `**stress` spines.



## Translating to Humdrum

Our Haskell parser translated and combined the original melodic and harmonic transcriptions into a single humdrum file, using `\*tb` (timebase) for melodic rhythm.

Two songs (*Layla* and *Crazy*) have key changes mid measure, which the parser is not ready for; these were manually fixed *after* auto parsing was complete.
(In *Layla*, one of the two harmonic transcriptions also failed to change keys mid measure.)

*Shout* has a weird "commented" breakdown which does not work with the parser. The `|` bars from this passage were changed to `:`, so the parser doesn't trip on it.
*Strawberry Fields* has the same problems.



### Pitch

In de Clercq and Temperley's original melodic encodings, pitch is encoded as scale degrees (1-7) with additional marks to indicate melodic contour/leap size.
de Clercq and Temperley indicate the tonic note and the diatonic scale for each piece, including various diatonic modes.
In the humdrum files, we translated this to the (similar) standard humdrum `\*\*deg` interpretation:
Numerals 1--7 indicate the natural scale degree of each pitch, given the key/mode.
`b` and `#` symbols indicate alterations relative to the mode.
By default, each successive scale degree is assumed to be the pitch closest the previous note---*tritones are assumed to be upward, regardless of their spelling*!
One or more `^` and `v` symbols are used to indicate violations of this, with multiple `v` or `^` indicating additional octaves.

---

In March 2022, author NCS used the latest version of `humdrumR` and some additional fiddling (to deal with tritones) to translate the `**deg` representation to `**kern`.
After some time inspecting various songs, they now should all be correct.

### Rhythm

In de Clercq and Temperley's original melodic encodings, rhythmic information is encode as a drum-machine-like step-sequence, indicating only at which point in each measure a note begins (leaving out offset/duration information).
In the humdrum files, `\*tb` interpretations indicate the step-sequence duration size, which changes dynamically as necassary.
For instance, `\*tb8` indicates that each subsequent data record is an eighth-note.

**Note that de Clercq and Temperley's "step sequence" approach means that the rhythm transcriptions only indicate onsets, not durations.**
(There are also, as a result, no rest tokens.)


# Error/edit log

As I worked on the translation, I found and fixed number of errors in the original files:


----

Strange warning records appear in the first records of five files, where the title of the song is supposed to be:

+ both_sides_now_tdc.txt	->	Warning: 'In' is defined but never used
+ lets_get_it_on_dt.txt	->	Warning: 'Vr2' is defined but never used
+ living_for_the_city_tdc.txt	->	Warning: 'B' is defined but never used
+ papa_was_a_rollin_stone_tdc.txt	->	Warning: 'Ch2' is defined but never used
+ who_do_you_love_dt.txt	->	Warning: 'Ch5' is defined but never used
+ who_do_you_love_dt.txt	->	Warning: 'Vr5' is defined but never used

These warnings were removed.

> Nat Condit-Schultz, February 2019


----

Several .tim are files simply are named wrong. I've correct them:

+ youve_got_that_lovin_feelin.tim -> youve_lost_that_lovin_feelin.tim
+ brown_eyed_girl.tim -> brown-eyed_girl.tim


> Nat Condit-Schultz, May 2019

---

A number of the original encodings have a particular inconsistency between the melodic and harmonic transcriptions,
with the mismatch of time signatures between the melodic and harmonic transcriptions.
In many cases the scribe simply neglected to indicate a time signature at the beginning of the harmonic transcriptions which is present
in the melodic transcription---in almost all cases, a compound-douple meter in the melodic transcription is absent from the harmonic transcriptions.
In other words, the melody is transcribed as 12/8, but they didn't indicate this in the harmonic transcription.
(Often the "mistake" is because the piece, especially considering the harmonic in issolation, is closer to in a 4/4 shuffle than a true 12/8).
I've fixed this by adding time signatures into harmonic encodings of the following files (in the "Original_Files" directory):

+ a_change_is_gonna_come (12/8)
+ be-bop-a-lula (12/8)
+ blueberry_hill (12/8)
+ california_girls (12/8)
+ crazy (12/8)
+ da_doo_ron_ron (12/8)
+ earth_angel (12/8)
+ georgia_on_my_mind (12/8)
+ god_only_knows (12/8)
+ good_vibrations (12/8)
+ heartbreak_hotel (12/8)
+ hound_dog (12/8)
+ i_cant_stop_loving_you (12/8)
+ in_the_still_of_the_night (12/8)
+ london_calling (12/8)
+ please_please_please (12/8)
+ rock_around_the_clock (12/8)
+ shake_rattle_and_roll (12/8)
+ thatll_be_the_day (12/8)
+ tutti_frutti (12/8)
+ when_a_man_loves_a_woman (12/8)
+ whole_lotta_shakin_goin_on (12/8)
+ you_send_me (12/8)

+ hallelujah (6/8)
+ house_of_the_rising_sun (6/8)
+ i_only_have_eyes_for_you (6/8)
+ ive_been_loving_you_too_long (6/8)
+ norwegian_wood (6/8)

+ im_so_lonely_i_could_cry (9/8)

+ the_times_they_are_a-changin (3/4)

+ mystery_train (missing one measure of 2/4 at beginning)
+ ring_of_fire (missing one measure of 3/4 at beginning)

+ blue_suede_shoes (alternating 6/8 and 12/8 at beginning didn't quite match. It was missing the first 12/8.)

> Nat Condit-Schultz, May 2019


---

Some songs have inconsistent keys between transcriptions.
In some cases, these are legitimate disagreements about what the key is (for instance, is vi in C major, or i in A minor?).
However, there are a number of cases of arbitrary enharmonic disgagreement (Ab vs G#). 
I've change melodic files to be consistent with the harmonic files in:

+ love_and_happiness G# -> Ab
+ sabotage G# -> Ab
+ the_message G# -> Ab
+ you_really_got_me G# -> Ab

+ nothing_but_a_g_thang empty -> B
+ foxey_lady empty -> F#
+ 
+ i_walk_the_line removed [F] at the beginning because it starts in [Bb]

+ light_my_fire remove [Db] at beginning because it starts on [F#]; changed Gb -> F# 

+ california_dreamin C# -> Db

+ good_vibrations Gb -> F#
+ in_the_still_of_the_night Gb -> F#
+ the_sounds_of_silence Gb -> F#

Unfortunately, since the harmonic transcriptions don't explicitely indicate mode, AND there is the possibility of legitimate disagreement regarding 
key/mode between two transcribers, I elected to automatically resolve mode disagreements by manually inspecting humdrum files.

> Nat Condit-Schultz, September 2019
	
