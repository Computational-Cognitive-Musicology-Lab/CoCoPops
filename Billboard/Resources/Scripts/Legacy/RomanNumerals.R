library(humdrumR)


readHumdrum('~/Bridge/Research/Data/Hot100Corpus/Humdrum/OriginalMcGillData_Edited/.*.hum') -> mcgill

mcgill[[ , 1]] -> mcgill

mcgill %hum>% ~ as.romanNumeral(Token, Key) -> mcgill$RNfull
mcgill %hum>% ~ as.romanNumeral(as.triad(Token), Key) -> mcgill$RNtriad

mcgill %hum>% ~ c('Minor', 'Major')[(Key == toupper(Key)) + 1L] -> mcgill$Mode

mcgill %hum<% c(~list(list(table(RNfull))), by ~ Mode) -> modeTablesfull
mcgill %hum<% c(~list(list(table(RNtriad))), by ~ Mode) -> modeTablesTriad
