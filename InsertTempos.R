library(data.table)
setwd("~/Bridge/Research/Data/RollingStoneCorpus")


tempos <- fread('Tempos.tsv')


insert <- function(fn, bpm) {
  fn <- paste0('HumdrumFiles/', fn)
  lines <- readLines(fn) 
  
  ##
  meterrec <- grep('^\\*M', lines)[1]
  
  newline <- c(rep(paste0('*MM', bpm), 3), '*')
  newline <- paste(newline, collapse = '\t')
  
  newlines <- append(lines, newline, after = meterrec)
  
  #insert reference record
  onbrec <- tail(grep('^!!!ONB', newlines), 1)
  newlines <- append(newlines, 
                     "!!!ONB: BPMs (quarter-note) inserted by Nathaniel Condit-Schultz, July 2019",
                     onbrec)
  
  
  writeLines(newlines, paste0(fn, ".tmp"))
  
  
}

tempos[, Map(insert, V1, V3)]