# CoCoPops/Billboard/Humdrum/CompleteTranscriptions/

This directory contains the completed humdrum transcriptions containing both the melodic and harmonic transcription data of the entire McGill Billboard dataset in humdrum format.


## Humdrum Format

### **kern


#### Voice Roles

CoCoPops billboard transcriptions are meant to represent the "main" or "lead" vocal part of each song in the sample.
However, each scribe determined which the "main" part was.
In many cases, more than one vocal part is active in a song, and one part is not clearly the "main" vocal.
Arnold Schoenberg popularized the terms [Haupstimme and Nebenstimme](https://en.wikipedia.org/wiki/Hauptstimme) to describe the primary (Haupstimme) and secondary (Nebenstimme) voices, marked in scores with &#119206; and &#119207; respecitvely.


The most difficult case is when multiple voices sing in harmony throughout a song and it is not clear which voice is the "main" melody---in some cases, either or both vocal parts might be equal.
We refer to these as ambiguous cases.
In other cases, multiple singers alternate, and the overal "gist" of the main part is a combination of the two parts---we call these "complex" cases.
CoCoPops transcribers in some cases transcribed more than one "main" vocal line, either because 1) they judged that the "main" part was either ambiguous or coplex or 2) they simply wished to transcribe the remaining parts.


---

In CoCoPops transcriptions, we label vocal parts with tandem intretations classifying the "role" of the vocal part.
We recognize xxx roles:

+ **Lead** (`*VRlead`)
  + The "lead" vocal part at any given time.
+ **Lead harmony** (`*VRharmony`)
  + A part "harmonizing" the lead part in rhythmic unison (or near unison).
+ **Backing** (`*VRbacking`)
  + A accompanying part that serves as rhythmic texture, often singing behind the lead part.
+ **Call** (`*VRcall`) and **Response** (`*VRresponse`)
  + An alternation of the "lead" line between two groups of voices.
+ **Riffing** (`*VRriff`)
  + Improvisatory melodic lines, often overdubbed on top of a main lead part.

Each `**kern` spine in each contains at least one vocal role interpretation.
In some cases, vocal roles may change dynamically throughout a piece.

---

In addition, we mark `*Hstimme` `*Nstimme` to indicate the primary and secondary voices at any given time. 
`*]stimme` can be used to indicate the end of the previous stimme indication---traditionally marked &#119208; in scores.
These tandem intrpretation may dynamically jump between spines on a measure-by-measure basis, somes times even changing within a vocal phrase.




