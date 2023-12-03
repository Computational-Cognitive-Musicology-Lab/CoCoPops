# This file takes the 214 harm files and inserts all the FULL mirex labels into them.
library(data.table)
library(humdrumR)

setwd("~/Bridge/Research/Data/CoCoPops/Billboard")

mirexfiles <- dir('Resources/McGill_Data/MirexFiles/', pattern = 'full.lab$')
mirexid <- as.integer(stringr::str_extract(mirexfiles, '^[0-9]{1,4}'))

sampleData <- fread('Billboard_Sample.tsv')
sampleData[ , ID := as.integer(gsub(', .*', '', `Sample ID#`))]

humfiles <- dir('Data', '(varms)?.hum$')
sampleData <- sampleData[Filename %in% gsub('(\\.varms)?\\.hum', '', humfiles)]
sampleData[ , HumFile := humfiles[match(Filename, gsub('(\\.varms)?\\.hum', '', humfiles))]]
sampleData$MirexFile <- mirexfiles[match(sampleData$ID, mirexid)]


generateTS <- function(humfile, mirexfile, file) {
  ###
   hummat <- stringi::stri_list2matrix(strsplit(humfile, split = '\t')) |> t()
   humchord <- hummat[ , hummat[grepl('^\\*\\*', humfile), ] == '**harte']
   humchord <- ifelse(grepl('^[.*=!]', humchord), NA, humchord)
   humchord <- gsub(' \\(.*', '', humchord)
   
   humtime <- hummat[ , hummat[grepl('^\\*\\*', humfile), ] == '**timestamp']
   humtime <- as.numeric(ifelse(grepl('^[.*=!]', humtime), NA, humtime))

   if (sum(!is.na(humtime)) < 10) {
      cat('\tNo timestamps\n')
      return(NULL)
   }
   
   hum <- data.table(Time = humtime, Chord = humchord)
   
   ###
   mirexfile <- mirexfile[!grepl('^X', mirexfile)]
   mirexmat <- stringi::stri_list2matrix(strsplit(mirexfile, split = '\t')) |> t()

   mirexchord <- mirexmat[, 3]
   mirexchord <- gsub('b:', '-:', mirexchord)
   
   mir <- data.table(Time =  round(as.numeric(mirexmat[, 1]), 3), Chord = mirexchord)

   pair <- closest(hum$Time[!is.na(hum$Time)], mir$Time[!is.na(mir$Time)], value = FALSE)
   hum[ , Offset := {
      time <- rep(NA, nrow(hum))
      time[!is.na(hum$Time)] <- hum$Time[!is.na(hum$Time)] - mir$Time[!is.na(mir$Time)][pair]
      time
      }]
   hum[ , MirChord := {
      chord <- rep(NA, nrow(hum))
      chord[!is.na(hum$Time)] <- mir$Chord[!is.na(mir$Time)][pair]
      chord
   }]
   hum[ , MirChord := ifelse(!is.na(Offset) & abs(Offset) > 4, 'BAD', MirChord)]
   #
   hum
          
}






generateFiles <- function(tsTable, filename, humfile) {
   if (is.null(tsTable)) return(NULL)
   
   if (!dir.exists('Resources/Scripts/timestamps')) dir.create('Resources/Scripts/timestamps')
   
   filename <- paste0('Resources/Scripts/timestamps/', filename)

      # fwrite(tsTable, file = paste0(filename, '.good'))
     
   hummat <- stringi::stri_list2matrix(strsplit(humfile, split = '\t')) |> t()
   hartej <- hummat[grepl('^\\*\\*', humfile), ] == '**harte'
   hummat[ , hartej] <- ifelse(is.na(tsTable$Time), hummat[ , hartej], paste0('<', hummat[ , hartej], '> ', tsTable$MirChord))
   
   newlines <- apply(hummat, 1, paste, collapse = '\t')
   newlines[grepl('^!!', humfile)] <- humfile[grepl('!!', humfile)] 
   
   writeLines(newlines, paste0(filename, '_timestamped.hum'))
   
   NULL
}
i <- 1:nrow(sampleData)
# i <- which(grepl('Zepp', sampleData$Filename))
inspect <- FALSE
sampleData[i, {
   cat(i, ': ' , Filename, '\n', sep = '')
  humfile <- readLines(paste0('Data/', HumFile))
  mirexfile <- readLines(paste0('Resources/McGill_Data/MirexFiles/', stringr::str_pad(ID, width=4, pad = '0'), 'full.lab'))
  
  tsTable <- generateTS(humfile, mirexfile, Filename)
  if (is.null(tsTable)) file.copy(paste0('Data/', Filename, '.hum'), paste0('Resources/Scripts/timestamps/', Filename, '_timestamped.hum'))
  bad <- generateFiles(tsTable, Filename, humfile)
  if (is.null(bad)) NULL else list(File = Filename, Bad = list(bad), ID = ID, N = sum(!bad$Match, na.rm = TRUE), P = mean(!bad$Match, na.rm = TRUE), I = i)
  
  
}, by = i ] -> bad


which <- bad[1]$Bad[[1]][, which(!Match)]
bad[1]$Bad[[1]][Filter(\(x) x >0, (min(which) - 10):(max(which) + 8))] |> print()
print(bad[1]$ID)
print(bad[1]$Fi)
bad[1]$Bad[[1]][1:100]

# 