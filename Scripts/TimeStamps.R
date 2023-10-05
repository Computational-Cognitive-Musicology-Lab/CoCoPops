library(data.table)
library(humdrumR)

setwd("~/Bridge/Research/Data/CoCoPops/BillboardCorpus")

mirexfiles <- dir('OriginalData/MirexFiles/', pattern = 'full.lab$')
mirexid <- as.integer(stringr::str_extract(mirexfiles, '^[0-9]{1,4}'))

sampleData <- fread('BillboardSampleData.tsv')
sampleData[ , ID := as.integer(gsub(', .*', '', `Sample ID#`))]

sampleData <- sampleData[paste0(FileName, '.hum') %in% dir('Humdrum/CompleteTranscriptions/')]
sampleData$MirexFile <- mirexfiles[match(sampleData$ID, mirexid)]


generateTS <- function(humfile, mirexfile, file) {
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
   mirexfile <- mirexfile[!grepl('^X', mirexfile)]
   mirexmat <- stringi::stri_list2matrix(strsplit(mirexfile, split = '\t')) |> t()

   mirexchord <- mirexmat[, 3]
   mirexchord <- gsub('/[^_]*(_*)', '\\1', mirexchord)
   mirexchord[mirexchord == 'X'] <- 'N'
   mirexchord <- gsub('b:', '-:', mirexchord)
   mir <- data.table(Time =  round(as.numeric(mirexmat[, 1]), 3), Chord = mirexchord)
   if (is.na(tail(mir$Time, 1) )) mir$Time[nrow(mir)] <- round(as.numeric(mirexmat[nrow(mir) - 1,2]), 3) # last timestamp is from "end" column
   
   #
   
   if (!file %in% c("SimonAndGarfunkel_ElCondorPasa_1970", "JohnnyHorton_TheBattleOfNewOrleans_1959" )) {
      humfirstchord <- which(!is.na(hum$Chord) & !hum$Chord %in% c('r', 'N'))[1]
      mirfirstchord <- which(mir$Chord != 'N')[1]
      humfirsttime <- hum$Time[humfirstchord]
      mirfirsttime <- mir$Time[mirfirstchord]
      if (!is.na(humfirsttime) && chordsMatch(hum$Chord[humfirstchord], mir$Chord[mirfirstchord])$Match && abs(humfirsttime- mirfirsttime) < 10 && abs(humfirsttime- mirfirsttime) > 0) {
         
         cat('\tChanging first timestamp in .hum file by', humfirsttime - mirfirsttime,'\n')
         hum$Time[humfirstchord] <- mir$Time[mirfirstchord]
         
         
      }
   }
   
   #
   mir$Spans <- cumsum(mir$Time %in% hum$Time)
   hum$Spans <- cumsum(!is.na(hum$Time)) 
   hum$NewTime <- NA
   hum$NewChord <- NA
   hum$Record <- seq_len(nrow(hum))
   lapply(union(hum$Spans, mir$Spans), 
          \(span) {
             .hum <- hum[Spans == span]
             .mir <- mir[Spans == span]
             
             if (inspect) browser()
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
             .hum$Extra <- tail(.mir, -ntargets)[ , substr(paste(Chord, collapse = ','), 0, 20)]
             .hum
          }) |> do.call(what = 'rbind') -> hum
   
   
   hum <- cbind(hum, hum[, chordsMatch(Chord, NewChord)])
   
   hum <- blankend(hum, file == 'StephanieMills_NeverKnewLoveLikeThisBefore_1980', 260)
   hum <- blankend(hum, file == 'Madonna_OhFather_1990', 557)
   hum <- blankend(hum, file == 'LedZeppelin_OverTheHillsAndFarAway_1973', 315)
   hum <- blankend(hum, file == 'SpandauBallet_True_1983', 106)
   hum <- blankend(hum, file == 'EricClapton_WillieAndTheHandJive_1974', 32)
   hum <- blankend(hum, file == 'EarthWindAndFire_September_1979', 466)
   hum <- blankend(hum, file == 'Heart_MagicMan_1976', 565)
   hum <- blankend(hum, file == 'TheBeachBoys_Kokomo_1988', 514)
   hum
          
}

blankend <- function(hum, do, record) {
   if (do) {
      hum[Record >= record, NewTime := ifelse(is.na(Time), NA, Time)]
      hum[Record >= record, Match := TRUE]
   }
   hum
}

chordsMatch <- function(old, new) {
   
   oldroot <- semits(old, simple = TRUE, Exclusive = 'kern')
   newroot <- semits(new, simple = TRUE, Exclusive = 'kern')
   oldroot[old %in% c('r', 'N')] <- -10
   newroot[new == 'N'] <- -10
   
   override <- grepl('_XXX', new)
   
   oldqual <- gsub('^.*:', '', old)
   newqual <- gsub('^.*:', '', new)
   
   rootmatch <- oldroot == newroot | override
   qualmatch <- oldqual == newqual | (newroot == -10 & oldroot == -10) | override
   
   data.table(Rootmatch = rootmatch, Qualmatch = qualmatch, Match = qualmatch & rootmatch)
}


generateFiles <- function(tsTable, filename, humfile) {
   if (is.null(tsTable)) return(NULL)
   
   if (!dir.exists('Scripts/timestamps')) dir.create('Scripts/timestamps')
   
   filename <- paste0('Scripts/timestamps/', filename)
   
   if (tsTable[ , any(!Match, na.rm = TRUE)]) {
      return(tsTable[!is.na(NewTime)])
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
inspect <- FALSE
sampleData[i, {
   cat(i, ': ' , FileName, '\n', sep = '')
  humfile <- readLines(paste0('Humdrum/CompleteTranscriptions/', FileName, '.hum'))
  mirexfile <- readLines(paste0('OriginalData/MirexFiles/', stringr::str_pad(ID, width=4, pad = '0'), 'full.lab'))
  
  tsTable <- generateTS(humfile, mirexfile, FileName)
  
  bad <- generateFiles(tsTable, FileName, humfile)
  if (is.null(bad)) NULL else list(File = FileName, Bad = list(bad), ID = ID, N = sum(!bad$Match, na.rm = TRUE), P = mean(!bad$Match, na.rm = TRUE))
  
  
}, by = i ] -> bad


which <- bad[1]$Bad[[1]][, which(!Match)]
print(bad[1]$ID)

if (diff(range(which)) < 20) bad[1]$Bad[[1]][Filter(\(x) x >0, (min(which) - 10):(max(which) + 5))] |> print() else print(which)
