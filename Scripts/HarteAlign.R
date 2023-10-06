library(data.table)
library(humdrumR)

setwd("~/Bridge/Research/Data/CoCoPops/BillboardCorpus")


harte <- dir('Scripts/Harte/', pattern = '.*[0-9]\\.hum$', full.names = TRUE)
hum <- dir('Humdrum/CompleteTranscriptions/', pattern = '.*hum', full.names = TRUE)

Map(\(ha, hu) length(readLines(ha)) - length(readLines(hu)), harte, hum) |> unlist() -> n
print( n[n!=0])

files <- data.table(Harte = harte, Hum = hum)

i <- 1:nrow(files)
files[i , {
  hr <- readLines(Harte)
  hm <- readLines(Hum) 
  
  if (!all(grepl('\t=', hr) == grepl('^=', hm))) stop('barlines not aligned in ', Hum)
  
  strsplit(hm, split = '\t') |> stringi::stri_list2matrix() |> t() -> hummat
  exclusive <- grepl('^\\*\\*', hm)
  harmony <- hummat[ , hummat[grepl('^\\*\\*', hm), ] == '**harmony']
  harmony[exclusive] <- '**harte'
  
  fill <- nchar(hr) < 2
  fill <- fill 
  
  harte <- ifelse(fill | grepl('^[*!=]', hm), harmony, gsub('^.*\t', '', hr))
  newhum <- ifelse(grepl('^!!', hm), hm, paste0(hm, '\t', harte))
  newhum[fill] <- paste0(newhum[fill], 'XXX')
  
  writeLines(newhum, gsub('hum$', 'xxx.hum', Harte))
  
  
  
}, by = i]


readHumdrum('~/Bridge/Research/Data/CoCoPops/BillboardCorpus/Scripts/Harte/.*xxx.hum') -> hh

hh[[,c('**harte','**chordsym')]] -> k
k |> collapseStops() |> cleave(1:2, newFields = 'Harte') -> k
root <- function(x) str_extract(x, '.*:')
qual <- function(x) str_extract(x, ':[^ /]*')
<<<<<<< HEAD
=======


# hh |> filter(Exclusive != 'chordsym') |> removeEmptySpines() -> hh2
writeHumdrum(hh2, prefix = '', affix = 'yyy', EMD = NULL)
>>>>>>> voiceRoles
