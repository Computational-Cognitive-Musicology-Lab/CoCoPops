library(humdrumR)


x <- readHumdrum('~/Bridge/Research/Data/CoCoPops/BillboardCorpus/Humdrum/CompleteTranscriptions/*.hum')


setwd('~/Bridge/Research/Data/CoCoPops/BillboardCorpus/Humdrum/CompleteTranscriptions/')

matts <- fread("../../CoCoPops-Billboard Info.csv", fill = TRUE)[-215]

files <- dir(pattern = '[0-9]\\.hum$')




matts[ , 
       {
         lines <- readLines(`Song Title:`)
         ICvox <- which(grepl('\\*ICvox', lines))
         
         voxline <- strsplit(lines[ICvox], split = '\t')[[1]]
         
         voices <- which(voxline == '*ICvox')
         
         role <- stimme <- rep('*', length(voxline))
         
         stimme[voices[1]] <- '*Hstimme'
         stimme[voices[-1]] <- '*Nstimme'
         
         classes <- c(`Voice #1 Classification`, `Voice #2 Classification`, `Voice #3 Classification`, `Voice #4 Classification`, `Voice #5 Classification`)
         
         classes <- gsub('\\(.*\\)', '', classes)
         classes <- gsub(' *', '', classes)
         classes <- gsub('Lead', '*VRlead', classes)
         classes <- gsub('Backing', '*VRbacking', classes)
         classes <- gsub('Call&Response', '*VRresponse', classes)
         classes <- gsub('Harmonize', '*VRharmonize', classes)
         classes <- gsub('Riffing', '*VRriffing', classes)
         classes <- gsub('/','', classes)
         role[voices] <- classes[seq_along(voices)]
         
         
         
         lines[ICvox] <- paste0(lines[ICvox], '\n', paste(role, collapse = '\t'), '\n', paste(stimme, collapse = '\t'))
         
         writeLines(lines, `Song Title:`)
         
         
       }, by = 1:nrow(matts)]



files <- dir('~/Bridge/Research/Data/CoCoPops/RollingStoneCorpus/Humdrum/', pattern = 'hum$', full.names = T)

sapply(files, \(file) {
  lines <- readLines(file)
  open <- grep('<<<<', lines)
  close <- grep('>>>>', lines)
  mid <- grep('====', lines)
  
  all((close - mid ) == 2)
  
  
}) |> table()

