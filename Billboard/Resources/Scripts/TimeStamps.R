library(data.table)
library(humdrumR)

setwd("~/Bridge/Research/Data/CoCoPops/Billboard")

mirexfiles <- dir('Resources/McGill_Data/MirexFiles/', pattern = 'full.lab$')
mirexid <- as.integer(stringr::str_extract(mirexfiles, '^[0-9]{1,4}'))

sampleData <- fread('Billboard_Sample.tsv')
sampleData[ , ID := as.integer(gsub(', .*', '', `Sample ID#`))]

sampleData <- sampleData[paste0(Filename, '.harm') %in% dir('Data')]
sampleData$MirexFile <- mirexfiles[match(sampleData$ID, mirexid)]


generateTS <- function(humfile, mirexfile, file) {
  ###
   hummat <- stringi::stri_list2matrix(strsplit(humfile, split = '\t')) |> t()
   humchord <- hummat[ , hummat[grepl('^\\*\\*', humfile), ] == '**harte']
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
   # mirexchord <- gsub('/[^_]*(_*)', '\\1', mirexchord)
   mirexchord <- gsub('1/1', '1', mirexchord)
   mirexchord[mirexchord == 'X'] <- 'N'
   mirexchord <- gsub('b:', '-:', mirexchord)
   mir <- data.table(Time =  round(as.numeric(mirexmat[, 1]), 3), Chord = mirexchord)
   if (is.na(tail(mir$Time, 1) )) mir$Time[nrow(mir)] <- round(as.numeric(mirexmat[nrow(mir) - 1,2]), 3) # last timestamp is from "end" column
   
   thresh <- .25 #max(mir[, (mean(diff(Time)) / 2)], .5)
   mir <- mir[!(c(diff(Time), 1) < thresh & Chord == c('', head(Chord, -1)))] # remove short repeated chords
   #
   
   if (!file %in% c()) {
      humfirstchord <- which(!is.na(hum$Chord) & !hum$Chord %in% c('r', 'N'))[1]
      mirfirstchord <- which(mir$Chord != 'N')[1]
      humfirsttime <- hum$Time[humfirstchord]
      mirfirsttime <- mir$Time[mirfirstchord]
      if (!is.na(humfirsttime) && chordsMatch(hum$Chord[humfirstchord], mir$Chord[mirfirstchord])$Match && abs(humfirsttime- mirfirsttime) < 20 && abs(humfirsttime- mirfirsttime) > 0) {

         cat('\tChanging first timestamp in .hum file by', humfirsttime - mirfirsttime)
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
   # hum <- blankend(hum, file == 'StephanieMills_NeverKnewLoveLikeThisBefore_1980', 260)
   # hum <- blankend(hum, file == 'Madonna_OhFather_1990', 557)
   # hum <- blankend(hum, file == 'LedZeppelin_OverTheHillsAndFarAway_1973', 315)
   # hum <- blankend(hum, file == 'SpandauBallet_True_1983', 106)
   # hum <- blankend(hum, file == 'EricClapton_WillieAndTheHandJive_1974', 32)
   # hum <- blankend(hum, file == 'EarthWindAndFire_September_1979', 466)
   # hum <- blankend(hum, file == 'Heart_MagicMan_1976', 565)
   # hum <- blankend(hum, file == 'TheBeachBoys_Kokomo_1988', 514)
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
   
   if (!dir.exists('Resources/Scripts/timestamps')) dir.create('Resources/Scripts/timestamps')
   
   filename <- paste0('Resources/Scripts/timestamps/', filename)
   if (tsTable[ , any(!Match, na.rm = TRUE)]) {
      return(tsTable[!is.na(NewTime)])
   } else {
      # fwrite(tsTable, file = paste0(filename, '.good'))
     newspine <- tsTable[ , ifelse(is.na(NewTime), Slate, NewTime)]
     
     hummat <- stringi::stri_list2matrix(strsplit(humfile, split = '\t')) |> t()
     hummat[,3] <- newspine
     newlines <- apply(hummat, 1, paste, collapse = '\t')
     # newlines[tsTable$Record] <- paste0(humfile[tsTable$Record], '\t', newspine)
     newlines[grepl('^!!!', humfile)] <- humfile[grepl('!!!', humfile)] 
     
     writeLines(newlines, paste0(filename, '_timestamped.harm'))
   }
   NULL
}

inspect <- FALSE
i <- 0
go <- TRUE
while(go) {
   i <- i + 1
   go <- i < nrow(sampleData)
   with(sampleData[i],  {
      cat(i, ': ' , Filename, sep = '')
      humfile <- readLines(paste0('Data/', Filename, '.harm'))
      mirexfile <- readLines(paste0('Resources/McGill_Data/MirexFiles/', stringr::str_pad(ID, width=4, pad = '0'), 'full.lab'))
      
      tsTable <- generateTS(humfile, mirexfile, Filename)
      if (is.null(tsTable)) file.copy(paste0('Data/', Filename, '.harm'), paste0('Resources/Scripts/timestamps/', Filename, '_timestamped.harm'))
      bad <- generateFiles(tsTable, Filename, humfile)
      output <- if (is.null(bad)) {
         badcount <- c(badcount, FALSE) 
         NULL
      } else {
         
         cat('->BAD')
         list(File = Filename, Bad = list(bad), ID = ID, N = sum(!bad$Match, na.rm = TRUE), P = mean(!bad$Match, na.rm = TRUE)) ->> bad
         go <<- FALSE
      } 
      
      cat('\n')
      
      output
   }) 
}



which <- bad$Bad[[1]][, which(!Match)]

if (diff(range(which)) < 20) bad$Bad[[1]][Filter(\(x) x >0, (min(which) - 10):(max(which) + 5))] |> print() else bad$Bad[[1]][Filter(\(x) x >0, (which[1]- 10):(which[1] + 10))] |> print()
paste('vim -O ../../../Data/', bad$File, '.harm ', '../../McGill_Data/MirexFiles/', stringr::str_pad(bad$ID, width=4, pad = '0'), 'full.lab', sep ='') |> clipr::write_clip()

print(i)
