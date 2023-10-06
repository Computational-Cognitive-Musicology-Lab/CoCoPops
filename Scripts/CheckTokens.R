#! /usr/local/bin/Rscript
library(magrittr)
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

cat('\tAll tokens have a rhythm (or are r;):\t', all((kern[!foundrecip] %>% unique) == 'r;'), '\n', sep = '')



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

cat("\n\n\t\tNext, let's work on the tokens in the **harmony spine:\n\n")

x[[ , ,~Exclusive == 'harmony']] %hum<% ~Token -> harmony


#### fermata

#### fermata

# An ; may appear at the end of the token

fermataRE <- ';$'

harmony_noF <- str_remove(harmony, fermataRE)

##### recip (rhythm)


# tokens should start with a standard **recip sub-token OR Craig's n%y fractions.
# ALL harmony tokens should have a duration.

recipRE <- '^[1-9][0-9]*%[1-9][0-9]*|^[1-9][0-9]*\\.*'

foundrecip <- str_detect(harmony, recipRE)

cat('\tAll tokens have a rhythm:\t', all(foundrecip), '\n', sep = '')



harmony_noFR <- str_remove(harmony_noF, recipRE)


##### root

# all tokens should start with an uppercase tonal name (A-G + accidental),
# unless they are r; or N (no chord)

rootRE <- '^[A-G](([#-])\\2*)?|^[rN]'

foundroot <- str_detect(harmony_noFR, rootRE)

cat('\tAll tokens have a root, rest, or N:\t', all(foundroot), '\n', sep = '')

harmony_noRR <- str_remove(harmony_noFR, rootRE)

##### quality



qualityRE <- '[AMmd][Mmd]?'

foundquality <- str_detect(harmony_noFR, qualityRE)

cat('\tOnly tokens that are r or N have no quality: ', all(foundquality | (harmony_noFR %in% c('r', 'N'))), '\n', sep = '')

harmony_empty <- str_remove(harmony_noRR, qualityRE)


cat('\tTokens are exhaustively partitioned as they should be:\t', all(harmony_empty == ''), '\n', sep ='')


cat('\tHere are all the rhythm (sub)tokens:\n')
cat(paste0('\t\t', str_extract(harmony, recipRE) %>% unique %>% sort), sep = '\n')
cat('\tHere are all the root (sub)tokens (including rests and N):\n')
cat(paste0('\t\t', str_extract(harmony_noFR, rootRE) %>% unique %>% sort), sep = '\n')
cat('\tHere are all the quality (sub)tokens:\n')
cat(paste0('\t\t', str_extract(harmony, qualityRE) %>% unique %>% sort), sep = '\n')

################
##### chordsym
###############


cat("\n\n\t\tNext, let's work on the tokens in the **chordsym spine:\n\n")

# First-stop tokens should either be r or N, or have a Root:Quality
# Later stops should be tonalnames with optional ( or ) in front or back


x[[ , ,~Exclusive == 'chordsym' & Stop == 1]] %hum<% ~Token -> chordsym1

##### colon

foundcolon <- str_detect(chordsym1, '.+:.+')

cat('\tOnly tokens that are r or N have no ":" seperator: ', all((chordsym1[!foundcolon] %>% unique) %in% c('r', 'N')), '\n', sep = '')


##### root

# all tokens should start with an uppercase tonal name (A-G + accidental),
# unless they are r; or N (no chord)

rootRE <- '^[A-G](([#-])\\2*)?|^[rN]'

foundroot <- str_detect(chordsym1, rootRE)

cat('\tAll tokens have a root, rest, or N:\t', all(foundroot), '\n', sep = '')

chordsym1_noR <- str_remove(str_remove(chordsym1, rootRE), '^:')



##### higher stops

x[[ , ,~Exclusive == 'chordsym' & Stop > 1]] %hum<% ~Token -> chordsymS
    
chordsymS_ <- str_remove(str_remove(chordsymS, '^\\('), '\\)$') 

noteRE <- '^[A-G](([#-])?\\2*)?$'


cat(paste0('\tAll multi-stop tokens have a legal note name: ', all(str_detect(chordsymS_, noteRE))), '\n', sep = '')

cat('\tTokens are exhaustively partitioned as they should be:\t', all(str_remove(chordsymS_, noteRE) == ""), '\n', sep = '')

# summary

cat('\tHere are all the root(sub)tokens:\n')
cat(paste0('\t\t', sort(unique(str_extract(chordsym1, rootRE)))), sep = '\n')

cat('\tHere are all the quality (sub)tokens:\n')
cat(paste0('\t\t', sort(unique(chordsym1_noR[chordsym1_noR != '']))), sep = '\n')

cat('\tHere are all the chord-tone multi-stops:\n')
cat(paste0('\t\t', sort(unique(str_extract(chordsymS_, noteRE)))), sep = '\n')



################
##### phrase
###############


cat("\n\n\t\tNext, let's work on the tokens in the **phrase spine:\n\n")



x[[ , ,~Exclusive == 'phrase']] %hum<% ~Token -> phrase

cat('\t', 'All phrase tokens are just "newline": ', all(phrase %in% c('->newline', 'newline')), '\n', sep = '')



################
##### leadinstrument
###############


cat("\n\n\t\tNext, let's work on the tokens in the **leadinstrument spine:\n\n")



x[[ , ,~Exclusive == 'leadinstrument']] %hum<% ~Token -> leadinstrument


cat('\tHere are all the leadinstrument tokens:\n')
cat(paste0('\t\t', sort(unique(leadinstrument))), sep = '\n')


################
##### timestamp
###############

cat("\n\n\t\tFinally, let's work on the tokens in the **timestamp spine:\n\n")

x[[ , ,~Exclusive == 'timestamp']] %hum<% ~Token -> timestamp

ntime <- as.numeric(timestamp)

cat('\tAll timestamps parse as positive numbers: ', !any(is.na(ntime)) & all(ntime >= 0), '\n', sep ='')

cat('\tHere is the largest timestamp: ', max(ntime), '\n', sep ='')

mins <- x[[,,~Exclusive == 'timestamp']] %hum<% c(~min(as.numeric(Token), na.rm = TRUE), by ~ File)

cat('\tAll files have at least one timestamp: ', length(mins) == length(x), '\n', sep = '')
cat('\tAll files have a zero timestamp: ', all(mins == 0), '\n', sep = '')



cat('\n\n\n\t\tFile checks are complete!\n\n')

