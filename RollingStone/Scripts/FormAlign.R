setwd("~/Bridge/Research/Data/CoCoPops/RollingStoneCorpus/OriginalData")
# 
# 
# fl <- dir(pattern = 'fl$')
# txt <- dir(pattern = 'Temperley.txt$')
# 
# 
# txt <- data.frame(Original = txt, Name = tolower(gsub('.*_', '', gsub('_[12][09][0-9][0-9]_[^_]+$', '', txt))))
# fl <- data.frame(Original = fl, Name = gsub('_|-', '', gsub('_t?d[tc]\\.fl$', '', fl)))
# 
# library(stringdist)
# 
# 
# dmat <- stringdistmatrix(txt$Name, fl$Name)
# # txt$Closest <- fl$Name[apply(dmat, 1, which.min)]
# txt$FLName <- fl$Original[apply(dmat, 1, which.min)]
# # txt$Distance <- apply(dmat, 1, min)
# 
# txt$FLName[txt$Original == "BobDylan_MrTambourineMan_1965_Temperley.txt"] <- 'mr_tambourine_man_dylan_tdc.fl'
# 
# txt$NewName <- gsub('\\.txt$', '.fl', txt$Original)


humpath <- sort(dir('../Humdrum/', pattern ='.krn', full.names = TRUE))
flpath <- sort(dir(pattern= 'fl$'))



secLabels <- c(Vr = 'Verse', Vrf = 'Verse', 
               Ch = 'Chorus', 
               Br = 'Bridge',  BBr = 'Bridge2', Bo = 'Bridge',
               Bld = 'Build',
               In = 'Intro', Intro = 'Intro', 
               Prec = 'PreChorus', 
               Bk = 'Break',
               Tr = 'Transition', 
               Rf = 'Refrain', Rfb = 'Refrain', Ref = 'Refrain',
               Pc = 'PreChorus', 
               Coda = 'Coda', Co = 'Coda', 
               Ou = 'Outro',  
               Tg = 'Tag', Ta = 'Tag',
               Li = 'Link', Ln = 'Link', Ex = 'Link',
               Fadeout = 'Fadeout',
               Inst = 'Instrumental', Inst = 'Vinst',
               Solo = 'Solo', So = 'Solo', Vrsolo = 'Solo')           

removeLab <- c('X', 'VP', 'St', 'BP', 'VP', 'Chext', 'ChX')

cleanNames <- function(x) {
  if (any(is.na(x))) return(NA)
  # if (all(grepl('Zz', x))) browser()
  # print(x)
  x <- gsub('\\$', '', x)
  
  x <- gsub('end', '', x)
  x <- gsub('([a-z])[1-9]+(b[1-2]?)?', '\\1', x)
  
  if (any(!x %in% removeLab)) x <- x[!x %in% removeLab]
  x <- x[!grepl('^Z', x)]
  x[x %in% names(secLabels)] <- secLabels[x[x %in% names(secLabels)]]
  
  hit <- x %in% secLabels
  x<-if (any(hit)) {
    i <- tail(which(hit), 1L)
    x[i]
  } else {
    x[1]
  }
  # if (length(x) == 0) return(NA)
  if (is.na(x)) NA else paste0('*>',x)
}


doit <- function(hum, fl) {
  hlines <- readLines(hum)
  flines <- readLines(fl)
  flines <- flines[!grepl('\\-\\-\\-', flines)]
  
  hmeasureloc <- grepl('^=', hlines)
  hmeasure <- as.numeric(gsub('.*=', '', hlines[hmeasureloc]))
  
  flmeasureloc <- grepl('^[0-9 ][0-9][0-9]?\\.00', flines)
  flmeasure <- as.numeric(gsub(' .*', '', gsub('^ *','', flines[flmeasureloc]))) + 1
  
  matched <- data.frame(hmeasure, flines[flmeasureloc][match(hmeasure, flmeasure)]) 
  
  form <- stringr::str_extract(matched[, 2], '\\$.*$') 
  form <- gsub('  *$', '', form)
  ### 
   
  
  ###f
  formal <- unlist(lapply(strsplit(form, split = ' '), cleanNames))
  
  na <- is.na(formal)
  formalx <- formal[!na]
  formalx[!c(TRUE, head(formalx, -1L) != tail(formalx, -1L))] <- NA
  
  formal <- rep(NA, length(na))
  formal[!na] <- formalx
  
  na <- is.na(formal)
  targets <- which(hmeasureloc)[!na]
  ncol <- stringr::str_count(hlines[targets], '\t') + 1 
  
  form <- formal[!na]
  form <- unlist(Map(\(f, n) paste(rep(f, n), collapse = '\t'), form, ncol))
  
  hlines[targets] <- paste0(hlines[targets], '\n', form) 
  newlines <- paste(hlines, collapse = '\n')
  writeLines(newlines, basename(hum))
  
  
  
}

lines <- Map(doit, humpath, flpath)
