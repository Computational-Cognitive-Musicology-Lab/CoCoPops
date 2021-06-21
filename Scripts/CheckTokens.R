#! /usr/local/bin/Rscript

library(humdrumR)
library(stringr)
x <- readHumdrum('../Humdrum/CompleteTranscriptions/.*hum')



##################
### kern
##################

cat("\n\n\t\tFirst, let's work on the tokens in the **kern spines:\n\n")

x[[ , ,~Exclusive == 'kern']] %hum<% ~Token -> kern

##### grace notes

# some tokens have Q or q at the END to indicate grace notes or gruppettos

graceRE <- '[Qq]$'

foundgrace <- str_detect(kern, graceRE)

kern_noG <- str_remove(kern, graceRE)



cat('\tGrace notes [Qq] are all in correct position:\t', !any(kern_noG %>% str_detect('[Qq]')), '\n', sep = '')



##### ties

# some tokens have either [ at the beginning, or ] at the end, or second to last position

tieRE <- '^\\[|\\]$|_$'

kern_noGT <- str_remove(kern_noG, tieRE)

 # there should ONLY be ties in the correct positions

cat('\tTies ([ ] or _) are all in correct position:\t', !any(kern_noGT %>% str_detect('\\[|\\]|_')), '\n', sep = '')

##### recip (rhythm)


# tokens should be standard recip tokens OR Craig's n%y fractions, PLUS an optional ; or ? indicating free timing or approximate timing respetively.
# ALL kern tokens should have a duration except for some r; tokens, indicating empty time.

recipRE <- '([1-9][0-9]*%[1-9][0-9]*|[1-9][0-9]*\\.*)[?;]?'

foundrecip <- str_detect(kern, recipRE)

cat('\tAll tokens have a rhythm:\t', all((kern[!foundrecip] %>% unique) == 'r;'), '\n', sep = '')



kern_noGTR <- str_remove(kern_noGT, recipRE)

#### fermata

# An ; at the end of the token
# this goes here because there CAN be a ; fermata earlir, in the recip token

fermataRE <- ';$'

kern_noGTRF <- str_remove(kern_noGTR,fermataRE)

##### pitch

# tokens should be standard, "basic" (no turns, trills, etc.) kern tokens with the additional modication of allowing mixed accidentals,
# like #- to indicate a "half flat" (read as "sharp flat").
# Also there is an optional prefix of ~ or X indicating approximate pitch or only spectral pitch respecively
# ALL tokens should have a pitch token, or an r


pitchRE <- '[~HML]?[A-Ga-g]+[#-]?(([#-])\\1*)?|r' 

foundpitch <- str_detect(kern, pitchRE)

cat('\tAll tokens have a pitch (or rest):\t', all(foundpitch), '\n', sep = '')

kern_noGTRFP <- str_remove(kern_noGTRF, pitchRE)


## nothing should be left over

cat('\tTokens are exhaustively partitioned as they should be:\t', all((kern_noGTRFP %>% unique) == ''), '\n', sep ='')

if (!all((kern_noGTRFP %>% unique) == '')){
  cat("\tWe've got problems resulting in extra characters:\n")
  cat(paste0('\t\t', sort(unique(kern_noGTRFP))), sep = '\n')
  cat('\n\tin these kern tokens:\n')
  cat(paste0('\t\t', sort(unique(kern[kern_noGTRFP != '']))), sep = '\n')
} else {
  cat('\tHere are all the pitch (sub)tokens (including rests):\n')
  cat(paste0('\t\t', str_extract(kern, pitchRE) %>% unique %>% sort), sep = '\n')
  cat('\tHere are all the rhythm (sub)tokens:\n')
  cat(paste0('\t\t', str_extract(kern, recipRE) %>% unique %>% sort), sep = '\n')
}

## check tokens (manually)




################
##### harmony
###############

# x[[ , ,~Exclusive == 'harmony']] %hum<% ~Token -> harmony
# x[[ , ,~Exclusive == 'chordsym']] %hum<% ~Token -> chordsym
# x[[ , ,~Exclusive == 'phrase']] %hum<% ~Token -> phrase
# x[[ , ,~Exclusive == 'timestamp']] %hum<% ~Token -> timestamp
# x[[ , ,~Exclusive == 'leadinstrument']] %hum<% ~Token -> leadinstrument

