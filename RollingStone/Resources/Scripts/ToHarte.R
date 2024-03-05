
library(humdrumR) # version 0.7.0.4


setwd("~/Bridge/Research/Data/CoCoPops/RollingStone/")

rs <- readHumdrum('Data/.*hum')


## First need to fix inversions in supposed **harm, which are really in roman numeral style (i.e., 43)

toharm <- function(roman) {
  
  subs <- c('^Vd7' = 'V7',
            '^bVd7' = 'bVm7',
            '^Id42' = 'Im7d',
            '^bVd42' = 'bVm7d',
            '^bIIId7' = 'bIIIm7',
            '^bIIId42' = 'bIIIm7d',
            '^IVd43' = 'IVm7c',
            '^V7b9' = 'Vm9',
            'b5' = 'D5',
            '^Id7' = 'Im7',
            '^IVd7' = 'IVm7',
            '^Vd7#9' = 'VA9',
            '#9' = 'A9',
            '^Vd43' = 'V7c',
            '^Vd42' = 'V7d',
            '^IId7' = 'II7',
            '^bIId7' = 'bIIm7',
            '^bVIId7' = 'bVIIm7',
            '^bVId7' = 'bVIm7',
            '^VId7' = 'VI7',
            '^VId9' = 'VI9',
            '^Id9' = 'Im7M9',
            '^iid6' = 'iiob', # this is an error in de Clercq (should be iio6 in their system)
            'x7' = 'oD7',
            'x43' = 'oD7c',
            'x42' = 'oD7d',
            'h7'  = 'om7',
            'h65' = 'om7b',
            'h43' = 'om7c',
            'h42' = 'om7d',
            'o6' = 'ob',
            'a7'  = '+7',
            'a65' = '+7b',
            '65' = '7b',
            '64' = 'c',
            '43' = '7c',
            '42' = '7d',
            's4' = 'sus4',
            '6' = 'b',
            'a' = '+'
            
            
            )
  harm <- roman
  for (i in seq_along(subs)) {
    harm <- gsub(names(subs)[i], subs[i], harm)
  }
  harm <- gsub('^b', '-', harm)
  harm
}

rs |> filter(Spine <= 2) |>
  within(NewHarm = toharm(Token))  -> rs


rs |> harte() -> rs

# resolve sus 4
rs |> filter(grepl('sus4', NewHarm)) |> count(NewHarm, Harte)

insertSus <- function(harm, harte) {
  
  triad <- harm %in% c('Vsus4', '-VIsus4', 'Isus4', 'Vsus4/vi')
  harte[ triad] <- gsub(':maj', ':sus4', harte[ triad])
  harte[harm == 'iisus4'] <- gsub(':min', ':sus4', harte[harm == 'iisus4'])
  
  harte[harm == 'V7sus4'] <- gsub(':7', ':(1,4,5,b7)', harte[harm == 'V7sus4'])
  harte[harm == 'v7sus4'] <- gsub(':min7', ':(1,4,5,b7)', harte[harm == 'v7sus4'])
  
  harte
  
  
}

rs |> mutate(Harte <- insertSus(NewHarm, Harte),
             NewHarm <- gsub('sus4', '', NewHarm)) -> rs

# checks
library(stringr)

## qualities
rs |> mutate(HarteQual = str_extract(Harte, ':.*') |> str_remove('/.*'),
             HarmQual = NewHarm |> str_remove('/.*') |> str_remove('[bcd]$')) |>
  # pull_data.table(Harte, NewHarm, HarteQual, HarmQual) -> qualcheck 
  count()

## roots
rs |> mutate(paste(Key, str_remove(Harte, ':.*'), paste0(str_extract(NewHarm, '[#-]?[VIvi]+') |> chartr('VIvi', 'VIVI', x = _), ifelse(grepl('/', NewHarm), str_extract(NewHarm, '/.*'), '')), sep = ' | ')) |> count()

## inversions
rs |> mutate(HarteInv = str_extract(Harte, '/.*') ,
             HarmInv = str_extract(NewHarm, '[bcd]$|[bcd]/') |> str_remove('/')) |> count() # pull_data.table(Harte, NewHarm, HarteInv, HarmInv) -> invcheck
  


rs |> rend(NewHarm, Harte, fieldName = 'New') -> rs

rs |> unfilter(complement = 'Token') -> rs


rs@Humtable[Type == 'E', New := ifelse(Spine %in% c(2,4), '**harte', New)]

writeHumdrum(rs, prefix = 'harte_', EMD = NULL)
