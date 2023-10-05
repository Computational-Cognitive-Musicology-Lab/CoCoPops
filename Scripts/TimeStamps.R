library(data.table)
library(humdrumR)

setwd("~/Bridge/Research/Data/CoCoPops/BillboardCorpus")

mirexfiles <- dir('OriginalData/MirexFiles/', pattern = 'full.lab$')
mirexid <- as.integer(stringr::str_extract(mirexfiles, '^[0-9]{1,4}'))

sampleData <- fread('BillboardSampleData.tsv')
sampleData[ , ID := as.integer(gsub(', .*', '', `Sample ID#`))]

sampleData <- sampleData[paste0(FileName, '.hum') %in% dir('Humdrum/CompleteTranscriptions/')]
sampleData$MirexFile <- mirexfiles[match(sampleData$ID, mirexid)]


generateTS <- function(humfile, mirexfile) {
  ###
   hummat <- stringi::stri_list2matrix(strsplit(humfile, split = '\t')) |> t()
   humchord <- hummat[ , hummat[grepl('^\\*\\*', humfile), ] == '**chordsym']
   humchord <- ifelse(grepl('^[.*=!]', humchord), NA, humchord)
   humchord <- gsub(' \\(.*', '', humchord)
   
   humtime <- humslate <- hummat[ , hummat[grepl('^\\*\\*', humfile), ] == '**timestamp']
   humtime <- as.numeric(ifelse(grepl('^[.*=!]', humtime), NA, humtime))
   humslate[!is.na(humtime)] <- NA
   
   if (sum(!is.na(humtime)) < 10) {
      cat('\tNo timestamps\n')
      return(NULL)
   }
   
   hum <- data.table(Time = humtime, Chord = humchord, Slate = humslate)
   hum <- hum[!grepl('^!=*', humfile)]
   
   ###
   mirexmat <- stringi::stri_list2matrix(strsplit(mirexfile, split = '\t')) |> t()

   mirexchord <- mirexmat[, 3]
   mirexchord <- gsub('/.*', '', mirexchord)
   mirexchord[mirexchord == 'X'] <- 'N'
   mirexchord <- gsub('b:', '-:', mirexchord)
   mir <- data.table(Time =  round(as.numeric(mirexmat[, 1]), 3), Chord = mirexchord)
   
   #
   mir$Spans <- cumsum(mir$Time %in% humtime) 
   hum$Spans <- cumsum(!is.na(hum$Time)) 
   hum$NewTime <- NA
   hum$NewChord <- NA
   hum$Record <- seq_len(nrow(hum))
   lapply(unique(mir$Spans), 
          \(span) {
             .hum <- hum[Spans == span]
             
             
             .mir <- mir[Spans == span]
             
             targetchords <- !is.na(.hum$Chord)
             ntargets <- sum(targetchords)
             
             .hum$NewTime[targetchords] <- .mir$Time[seq_len(ntargets)]
             .hum$NewChord[targetchords] <- .mir$Chord[seq_len(ntargets)]
             
             .hum$ExtraLength <- nrow(.mir) - ntargets
             .hum$Extra <- tail(.mir, -ntargets)[ , paste(Chord, collapse = ',')]
             .hum
          }) |> do.call(what = 'rbind') -> hum
   
   hum <- cbind(hum, hum[, chordsMatch(Chord, NewChord)])
   
   
        
   hum
          
}


chordsMatch <- function(old, new) {
   
   oldroot <- semits(old, simple = TRUE, Exclusive = 'kern')
   newroot <- semits(new, simple = TRUE, Exclusive = 'kern')
   
   oldqual <- gsub('^.*:', '', old)
   newqual <- gsub('^.*:', '', new)
   
   rest <- old == 'r' & new == 'N'
   
   rootmatch <- oldroot == newroot | rest
   qualmatch <- oldqual == newqual | rest
   
   data.table(Rootmatch = rootmatch, Qualmatch = qualmatch, Match = qualmatch & rootmatch)
}


generateFiles <- function(tsTable, filename, humfile) {
   if (is.null(tsTable)) return(NULL)
   
   if (!dir.exists('Scripts/timestamps')) dir.create('Scripts/timestamps')
   
   filename <- paste0('Scripts/timestamps/', filename)
   
   if (tsTable[ , any(!Match, na.rm = TRUE)]) {
      fwrite(tsTable, file = paste0(filename, '.bad'))
   } else {
      fwrite(tsTable, file = paste0(filename, '.good'))
      browser()
     newspine <- tsTable[ , ifelse(is.na(NewTime), Slate, NewTime)]
     humfile[!grepl('^!!', humfile)] <- paste0(humfile[!grepl('^!!', humfile)], '\t', newspine[!grepl('^!!', humfile)])
     
     writeLines(humfile, paste0(filename, '_timestamped.hum'))
   }
}

i <- 1:nrow(sampleData)
sampleData[i, {
   cat(FileName, ':\n', sep = '')
  humfile <- readLines(paste0('Humdrum/CompleteTranscriptions/', FileName, '.hum'))
  mirexfile <- readLines(paste0('OriginalData/MirexFiles/', stringr::str_pad(ID, width=4, pad = '0'), 'full.lab'))
  
  tsTable <- generateTS(humfile, mirexfile)
  
  generateFiles(tsTable, FileName, humfile)
  
}, by = i ] -> x
