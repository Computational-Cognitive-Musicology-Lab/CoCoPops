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


humpath <- dir('../Humdrum/', pattern ='.hum', full.names = TRUE)
flpath <- dir(pattern= 'fl$')

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
  form <- gsub('^\\$', '*>', form)
  form <- gsub(' \\$','>>', form)
  
  na <- is.na(form)
  formx <- form[!na]
  formx[formx == c('', head(formx, -1))] <- NA
  
  form[!na] <- formx
  
  
  targets <- which(hmeasureloc)[!is.na(form)]
  ncol <- stringr::str_count(hlines[targets], '\t') + 1 
  
  form <- form[!is.na(form)]
  form <- unlist(Map(\(f, n) paste(rep(f, n), collapse = '\t'), form, ncol))
  
  
  hlines[targets] <- paste0(hlines[targets], '\n', form) 
  
  newlines <- paste(hlines, collapse = '\n')
  writeLines(newlines, basename(hum))
  
  
}

for (i in 1:length(humpath)) {
  print(humpath[i])
  doit(humpath[i], flpath[i])
}
