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
   
   ###
   mirexmat <- stringi::stri_list2matrix(strsplit(mirexfile, split = '\t')) |> t()

   mirexchord <- mirexmat[, 3]
   mirexchord <- gsub('/.*', '', mirexchord)
   mirexchord[mirexchord == 'X'] <- 'N'
   mirexchord <- gsub('b:', '-:', mirexchord)
   mir <- data.table(Time =  round(as.numeric(mirexmat[, 1]), 3), Chord = mirexchord)
   if (is.na(tail(mir$Time, 1) )) mir$Time[nrow(mir)] <- round(as.numeric(mirexmat[nrow(mir) - 1,2]), 3) # last timestamp is from "end" column
   
   #
   mir$Spans <- cumsum(mir$Time %in% humtime) 
   hum$Spans <- cumsum(!is.na(hum$Time)) 
   hum$NewTime <- NA
   hum$NewChord <- NA
   hum$Record <- seq_len(nrow(hum))
   lapply(union(hum$Spans, mir$Spans), 
          \(span) {
             .hum <- hum[Spans == span]
             
             
             .mir <- mir[Spans == span]
             if (nrow(.mir) == 0) {
                .hum$NewTime <- .hum$NewChord <- NA
                .hum$Extra <- ''
                .hum$ExtraLength <- 0
                return(.hum)
             }
             
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
      return(tsTable[!is.na(Time)])
   } else {
      # fwrite(tsTable, file = paste0(filename, '.good'))
     newspine <- tsTable[ , ifelse(is.na(NewTime), Slate, NewTime)]
     newlines <- humfile
     newlines[tsTable$Record] <- paste0(humfile[tsTable$Record], '\t', newspine)
     newlines[grepl('^!!!', humfile)] <- humfile[grepl('!!!', humfile)] 
     
     writeLines(newlines, paste0(filename, '_timestamped.hum'))
   }
   NULL
}

i <- 1:nrow(sampleData)
sampleData[i, {
   cat(FileName, ':\n', sep = '')
  humfile <- readLines(paste0('Humdrum/CompleteTranscriptions/', FileName, '.hum'))
  mirexfile <- readLines(paste0('OriginalData/MirexFiles/', stringr::str_pad(ID, width=4, pad = '0'), 'full.lab'))
  
  tsTable <- generateTS(humfile, mirexfile)
  
  bad <- generateFiles(tsTable, FileName, humfile)
  if (is.null(bad)) NULL else list(File = FileName, Bad = list(bad), N = sum(!bad$Match, na.rm = TRUE), P = mean(!bad$Match, na.rm = TRUE))
  
  
}, by = i ] -> x


