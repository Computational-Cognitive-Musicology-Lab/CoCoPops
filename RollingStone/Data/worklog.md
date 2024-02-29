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

----

#### Other Mistakes:

+ Trevor marks the first note (a B) in Buddy Holly's "Rave On" and "That'll Be The Day" as OCT=4. I think it should be OCT=3. Have corrected. ---NCS


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
