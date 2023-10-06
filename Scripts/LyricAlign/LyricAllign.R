setwd("~/Bridge/Research/Data/CoCoPops/RollingStoneCorpus/Scripts/LyricAlign")

str_files <- dir('../../OriginalData/', pattern = 'str$')

hum_files <- dir('../../Humdrum/', 'hum$')
hum_files <- hum_files[hum_files %in% gsub('.str$', '.hum', str_files)]



findTB <- function(x, file) {
  for (tb in c(2,3,4,6,8,12,16,24,32, 64)) {
    if (all(abs(((x * tb) - round(x * tb))) < 1/64)) return(tb)
  }
  
  print(x)
  stop("NO TB FOUND in ", file)
}

allign <- function(i, debug = FALSE) {
 str <- process_str(str_files[i])
 hum <- process_hum(hum_files[i])
 
 hum$Offset <- round(hum$Offset, 4)
 
 if(!((str$Offset %in% hum$Offset) %>% all)) {
   if (debug) {
     return(list(str_files[i], str[!Offset %in% hum$Offset,list(TB=findTB(OrigOffset, str_files[i])), by = (1+Measure)]))
   } else {
     stop("There is an offset mismatch between ", str_files[i], ' and ', hum_files[i])
   }
 } 
  
 wordinds <- match(str$Offset, hum$Offset)
 
 # hum[wordinds, if (any(`**deg` == '.')) {
 #   if (debug) {
 #     print(str_files[i])
 #     browser()
 #   } else {
 #    warning('Rhythmic mismatch between ', str_files[i], ' and ', hum_files[i])
 #   }
 # }]
 
 hum$`**silbe` <- hum$`**stress` <- "."
 hum$`**silbe`[wordinds] <- str$Syllable
 hum$`**stress`[wordinds] <- str$Stress
 
 hum$`**silbe`[hum$`**silbe` == "." & hum$`**deg` != '.'] <- '_'
 
 hum[, Offset := NULL]
 hum[, TB := NULL]
 hum[, Measure := NULL]
 
 hum[ , `**silbe` := ifelse(`**silbe` %in% c('I', "I'D", "I'M"), `**silbe`, tolower(`**silbe`))]
 
 setcolorder(hum, c(1,2,3,6,5,4))
 datalines <- hum[ , do.call('paste', c(.SD, sep = '\t')), by = 1:nrow(hum)]$V1 
 
 
 rebuildhumdrum(hum_files[i], datalines)
 
 return(NULL)
}
library(data.table)
process_str <- function(str_file) {
  str <- readLines(paste0('../../OriginalData/', str_file)) %>%
    strsplit(split = ' ') %>% 
    do.call('rbind', .) %>%
    as.data.table
  colnames(str) <- c('What', 'Offset', 'MIDI', 'Deg', 'Stress', 'Syllable')
  str[ , Offset := as.numeric(Offset)]
  str[ , OrigOffset := Offset]
  str[ , Measure := Offset %/% 1]
  # shifts <- 0
  # for (measure in str[, unique(Measure)]) {
  #   if (str[measure == Measure, (What == '204')[1]]){
  #     cat('measure ', measure, ' in ', str_file, ' is 2/4\n')
  #     str$Offset[str$Measure == measure] <- str[Measure == measure, ((Offset %% 1) / 2) + measure - shifts]
  #     shifts <- shifts + .5
  #     
  #   } else {
  #     str$Offset[str$Measure == measure] <- str[Measure == measure, Offset -  shifts]
  #   }
  # }
  
  str$Offset[str$What == '204'] <- str[What == '204', ((Offset %% 1)/2) + Measure]
  
  if (grepl('Prince.*1999', str_file)) str[, Offset := Offset + 1]
  
  
  str[ , Word := cumsum(grepl('1', Syllable))]
  
  
  str[ , Syllable := gsub('\\[[0-9][0-9]*\\]', '', Syllable)]
  
  str$Syllable <- str[ , splitInParts(Syllable), by = Word]$V1
  str[ , Syllable := gsub('[0-9]*', '', Syllable)]
  str
}

library(stringr)



splitInParts <- function(syllable){
  n <- length(syllable)
  if (n == 1) return(syllable)
  syllable <- syllable[1]
  
  size <- ceiling(nchar(syllable) / n )
  pat <- paste0('(?<=.{', size, '})')
  syllables <- unlist(strsplit(syllable, pat, perl=TRUE))
  paste0(c('', rep('-', n - 1)), syllables, c(rep('-', n - 1), '') )
}


process_hum <- function(hum_file) {
  hum <- readLines(paste0('../../Humdrum/', hum_file))
  
  colnames <- strsplit(grep('\\*\\*', hum, value = TRUE), split = '\t')[[1]]
  
  data <- grep('^[^*!]|^\\*tb', hum, value = TRUE) %>%
    strsplit(split = '\t') %>% 
    do.call('rbind', .) %>%
    as.data.table
  
  data <- data[, !colnames %in% c('**stress', '**silbe'), with = FALSE]
  colnames(data) <- colnames[!colnames %in% c('**stress', '**silbe')]
  
  ## Measure
  measurehits <- grepl('^=', data[[1]])
  data$Measure <- cumsum(measurehits) - (if (measurehits[1]) 1 else 0)
  data <- data[!measurehits, ]
   
  ## Tb
  
  tbhits <- grepl('^\\*tb', data[[1]])
  tb <- tapply(data[[1]], cumsum(tbhits), function(tb) (1/as.numeric(str_sub(tb[1], start = 4))) %>% rep(length.out = length(tb))) %>% unlist
  data <- data[!tbhits,]
  tb <- tb[!tbhits]
  offset <- unlist(tapply(tb, data$Measure, function(x) cumsum(c(0, head(x, -1))))) + data$Measure
  
  data$TB <- tb
  data$Offset <- offset
  data
  
  
}


rebuildhumdrum <- function(hum_file, data) {
  hum <- readLines(paste0('../../Humdrum/', hum_file))
  
  nondata <- grepl('^[!*=]', hum)
  hum[!nondata] <- data
  
  # nondata
  global <- grepl('^!!', hum)
  
  
  colnames <- strsplit(grep('\\*\\*', hum, value = TRUE), split = '\t')[[1]]
  localnondata <-  grep('^[*!=]', hum[!global], value = TRUE) %>%
    strsplit(split = '\t') %>% 
    do.call('rbind', .) %>%
    as.data.table
  
  
  localnondata <- localnondata[, !colnames %in% c('**stress', '**silbe'), with = FALSE]
  colnames(localnondata) <-  colnames[!colnames %in% c('**stress', '**silbe')]
  
  localnondata$`**silbe` <- localnondata$`**stress` <- localnondata$`**timestamp`
  localnondata$`**silbe`[1] <- '**silbe'
  localnondata$`**stress`[1] <- '**stress'
  
  localnondata <- localnondata[ , do.call('paste', c(.SD, sep = '\t')), by = 1:nrow(localnondata)]$V1
  
  
  hum[nondata & !global] <- localnondata
  
  
  ##
  if (!dir.exists('with_silbe')) dir.create('with_silbe')
  
  writeLines(hum, paste0('with_silbe/', hum_file))
  
}

result <- lapply(1:length(hum_files), allign, debug=TRUE)
names(result) <- hum_files
result <- result[!sapply(result, is.null)]
print(length(result))
# for (i in 1:length(hum_files)) try(allign(i, debug = TRUEs ))
print(head(result,1))