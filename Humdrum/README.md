# CoCoPops/RollingStone/Humdrum/


For this project, a Haskell program was created to translate Temperley and de Clercq's original encodings into the humdrum syntax, with the four original files encoded in four spines of a single humdrum file.
This program was created and run in 2019 by Nat Condit-Schultz;
Information about this initial data translation process is contained below, in the section "Work log."
(A number of errors in the original data are documented in the work log.)

The current version of the humdrum data set is located in the `Humdrum` directory.

---

In 2021, Rhythm Jain worked with Nat to add incorporate the additional lyrical information for the 80-song subset into the humdrum files, as `**silbe` and `**stress` spines.


## Pitch

In de Clercq and Temperley's original melodic encodings, pitch is encoded as scale degrees (1-7) with additional marks to indicate melodic contour/leap size.
de Clercq and Temperley indicate the tonic note and the diatonic scale for each piece, including various diatonic modes.
In our humdrum files, we use the standard humdrum a `\*\*deg` interpretation:
Numerals 1--7 indicate the natural scale degree of each pitch, given the key/mode.
`b` and `#` symbols indicate alterations relative to the mode.
By default, each successive scale degree is assumed to be the pitch closest the previous note.
One or more `^` and `v` symbols are used to indicate violations of this, with multiple `v` or `^` indicating additional octaves.


## Rhythm

In de Clercq and Temperley's original melodic encodings, rhythmic information is encode as a drum-machine-like step-sequence, indicating only at which point in each measure a note begins (leaving out offset/duration information).
In our humdrum files I've produced, `\*tb` interpretations indicate the step-sequence duration size, which changes dynamically as necassary.
For instance, `\*tb8` indicates that each subsequent data record is an eighth-note.

Note that de Clercq and Temperley's "step sequence" approach means that the rhythm transcriptions only indicate onsets, not durations.
(There are also, as a result, no rest tokens.)



# Worklog


This dataset is a translation of de Clercq and Temperley's Rolling Stone Corpus (http://rockcorpus.midside.com/) into the humdrum (www.humdrum.org) format.
This WorkLog file was used to keep notes on progress on this project before it was turned into a git repository.
The "I" below is Nat Condit-Schultz.

The input was the original melodic and harmonic transcription files (`.txt` and `.mel` files in the `OriginalData` directory).



## Errors in original files


I've made a number of (manual) fixes to errors in the original transcriptions/files.
(The descriptions below refer to the original filenames used by Temperely and de Clercq, not our updated CoCoPops naming convention.)

---

Strange warning records appear in the first records of five files, where the title of the song is supposed to be:

+ `both_sides_now_tdc.txt`		->	`Warning: 'In' is defined but never used`
+ `lets_get_it_on_dt.txt`		->	`Warning: 'Vr2' is defined but never used`
+ `living_for_the_city_tdc.txt`		->	`Warning: 'B' is defined but never used`
+ `papa_was_a_rollin_stone_tdc.txt`	->	`Warning: 'Ch2' is defined but never used`
+ `who_do_you_love_dt.txt`		->	`Warning: 'Ch5' is defined but never used`
+ `who_do_you_love_dt.txt`		->	`Warning: 'Vr5' is defined but never used`

These warnings were removed.

> Nat Condit-Schultz, February 2019

----


Several `.tim` are files simply are named wrong. I've correct them:

`youve_got_that_lovin_feelin.tim` 	-> `youve_lost_that_lovin_feelin.tim`
`brown_eyed_girl.tim` 			-> `brown-eyed_girl.tim`


> Nat Condit-Schultz, May 2019

----

A number of the original encodings have a particular inconsistency between the melodic and harmonic transcriptions, with the mismatch of time signatures between the melodic and harmonic transcriptions.
In many cases the scribe simply neglected to indicate a time signature at the beginning of the harmonic transcriptions which is present
in the melodic transcription---in almost all cases, a compound-douple meter in the melodic transcription is absent from the harmonic transcriptions.
In other words, the melody is transcribed as 12/8, but they didn't indicate this in the harmonic transcription.
(Often the "mistake" is because the piece, especially considering the harmonic in issolation, is closer to in a 4/4 shuffle than a true 12/8).

I've fixed this by adding time signatures into harmonic encodings of the following files:

+ `a_change_is_gonna_come` (12/8)
+ `be-bop-a-lula` (12/8)
+ `blueberry_hill` (12/8)
+ `california_girls` (12/8)
+ `crazy` (12/8)
+ `da_doo_ron_ron` (12/8)
+ `earth_angel` (12/8)
+ `georgia_on_my_mind` (12/8)
+ `god_only_knows` (12/8)
+ `good_vibrations` (12/8)
+ `heartbreak_hotel` (12/8)
+ `hound_dog` (12/8)
+ `i_cant_stop_loving_you` (12/8)
+ `in_the_still_of_the_night` (12/8)
+ `london_calling` (12/8)
+ `please_please_please` (12/8)
+ `rock_around_the_clock` (12/8)
+ `shake_rattle_and_roll` (12/8)
+ `thatll_be_the_day` (12/8)
+ `tutti_frutti` (12/8)
+ `when_a_man_loves_a_woman` (12/8)
+ `whole_lotta_shakin_goin_on` (12/8)
+ `you_send_me` (12/8)

+ `hallelujah` (6/8)
+ `house_of_the_rising_sun` (6/8)
+ `i_only_have_eyes_for_you` (6/8)
+ `ive_been_loving_you_too_long` (6/8)
+ `norwegian_wood` (6/8)

+ `im_so_lonely_i_could_cry` (9/8)

+ `the_times_they_are_a-changin` (3/4)

+ `mystery_train` (missing one measure of 2/4 at beginning)
+ `ring_of_fire` (missing one measure of 3/4 at beginning)

+ `blue_suede_shoes` (alternating 6/8 and 12/8 at beginning didn't quite match. It was missing the first 12/8.)

> Nat Condit-Schultz, May 2019


---

Some songs have inconsistent keys between transcriptions.
In some cases, these are legitimate disagreements about what the key is (for instance, is vi in C major, or i in A minor?).
However, there are a number of cases of arbitrary enharmonic disgagreement (Ab vs G#). 
I've change melodic files to be consistent with the harmonic files in:

+ `love_and_happiness` G# -> Ab
+ `sabotage` G# -> Ab
+ `the_message` G# -> Ab
+ `you_really_got_me` G# -> Ab

+ `nothing_but_a_g_thang` empty -> B
+ `foxey_lady` empty -> F#
+ `
+ `i_walk_the_line` removed [F] at the beginning because it starts in [Bb]

+ `light_my_fire` remove [Db] at beginning because it starts on [F#]; changed Gb -> F# 

+ `california_dreamin` 		C# -> Db

+ `good_vibrations` 		Gb -> F#
+ `in_the_still_of_the_night` 	Gb -> F#
+ `the_sounds_of_silence`	 Gb -> F#

Unfortunately, since the harmonic transcriptions don't explicitely indicate mode, AND there is the possibility of legitimate disagreement regarding 
key/mode between two transcribers, I elected to automatically resolve mode disagreements by manually inspecting humdrum files.

> Nat Condit-Schultz, September 2019



### (Mis)Aligning Lyrics

Rhythm and I worked to insert the lyrics (and stress) info from the 80-song lyric subset into the humdrum files, in `\*\*silbe` and `\*\*stress` spines.
This was done using scripts in `../Scripts/LyricAlign`.

In a number of tracks, `.str` and `.mel` files do not agree on all the rhythms.
(In general, I believe the rhythms in the `.str` files are more accurate detailed, but not in all cases.)
For now, rather than picking a side (`.str` vs `.mel`) we've simply inserted the syllables into the humdrm files wherever the `.str` says they go.
This means that in some places, there are slight discrepencies between the `\*\*deg` and `\*\*silbe` spines.

In some cases (listed below) the timebase used in the humdrum/`.mel` scores in a particular measure wasn't able to capture the rhythms indicated in the `.str` file.
I manually changed the timebases for these measures so that both rhythms (`.mel` and `.str`) could be put into the same measure---in some cases, going up to `tb48`.
This was done in the following files:
	
+ AlGreen_LetsStayTogether_1971.hum
+ ArethaFranklin_Respect_1967.hum
+ BobDylan_LikeARollingStone_1965.hum
+ BobMarley_NoWomanNoCry_1975.hum
+ BobMarley_RedemptionSong_1980.hum
+ BonnieRaitt_ICantMakeYouLoveMe_1991.hum
+ BruceSpringsteen_BornToRun_1975.hum
+ ChuckBerry_Maybellene_1955.hum
+ ChuckBerry_RollOverBeethoven_1956.hum
+ DavidBowie_Heroes_1977.hum
+ DerekAndTheDominos_Layla_1970.hum
+ DonnaSummer_HotStuff_1979.hum
+ ElvisPresley_JailhouseRock_1957.hum
+ EricClapton_TearsInHeaven_1992.hum
+ LedZeppelin_StairwayToHeaven_1971.hum
+ LittleRichard_GoodGollyMissMolly_1958.hum
+ MichaelJackson_BillieJean_1983.hum
+ NewOrder_BizarreLoveTriangle_1986.hum
+ Nirvana_SmellsLikeTeenSpirit_1991.hum
+ Pavement_SummerBabe_1992.hum
+ Prince_1999_1982.hum
+ Prince_LittleRedCorvette_1983.hum
+ Prince_WhenDovesCry_1984.hum
+ RKelly_IBelieveICanFly_1996.hum
+ Radiohead_FakePlasticTrees_1995.hum
+ SimonAndGarfunkel_BridgeOverTroubledWater_1970.hum
+ TheBeatles_ADayInTheLife_1967.hum
+ TheBeatles_HeyJude_1968.hum
+ TheBeatles_InMyLife_1965.hum
+ TheBeatles_Yesterday_1965.hum
+ TheEagles_HotelCalifornia_1976.hum
+ TheImpressions_PeopleGetReady_1965.hum
+ TheRamones_BlitzkriegBop_1976.hum
+ TheRollingStones_SympathyForTheDevil_1968.hum
+ TheRonettes_BeMyBaby_1963.hum
+ TheVerve_BitterSweetSymphony_1997.hum
+ TheWho_MyGeneration_1965.hum
+ U2_One_1991.hum

Prince's "1999" had an additional file where the melodic/harmonic transcriptions and the `.str` file were off by one measure.
I changed my script to add 1 to the rhythmic offsets from the `.str` file, which fixed this problem (there were still a few other bars to change).




## HumdrumFiles

I wrote a Haskell parser which translates and combines the original melodic and harmonic transcriptions into a single humdrum file, using `\*tb` (timebase) for melodic rhythm.

Two songs (*Layla* and *Crazy*) have key changes mid measure, which my parser is not ready for.
I fix these manually *after* auto parsing was complete.
(In *Layla*, one of the two harmonic transcriptions also failed to change keys mid measure.)

*Shout* has a weird "commented" breakdown which is messing up my parser. I am changing the `|` bars from this passage to `:`, so the parser doesn't trip on it.
*Strawberry Fields* has the same problems.

> Nat Condit-Schultz, May 2019


### Tempos


The files `../Tempos.tsv` lists the bpm(s) for each file, based on my tapping along to them using the (https://www.all8.com/tools/bpm.htm) tool.
Using the `../Scripts/InsertTempos.R` script (**CURRENTLY BROKEN**), these tempos can be inserted into the humdrum files.
For files with multiple tempos, the actual location of tempo changes in the humdrum file has to be input manually (after the fact).

