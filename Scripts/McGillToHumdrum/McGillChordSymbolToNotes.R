library(stringr)
Notes = unlist(lapply(c('---', '--', '-', '', '#', '##', '###'), function(x) paste0(c('F', 'C', 'G', 'D', 'A', 'E', 'B'), x)))

intervals = list('1' = 0,
                 'b1' = -7,
                 'bb7' = -9,
                 'b11' = -8,
                 'bb13' = -11,
                 '9' = 2,
                 '7' = 5,
                 'b7' = -2,
                 '3' = 4,
                 '5' = 1,
                 'b3' = -3,
                 '#9' = 9,
                 'b9' = -5,
                 '#11' = 6,
                 '11' = -1,
                 'b13' = -4,
                 '13' = 3,
                 'b5' = -6,
                 '#5' = 8)

qualities = list(
              '^maj$' = c(0, 4, 1),
              '^min$' = c(0, -3, 1),
              '^dim$' = c(0, -3, -6),
              '^aug$' = c(0, 4, 8),
              '^7$' = c(0, 4, 1, -2),
              '^maj7$' = c(0, 4, 1, 5),
              '^min7$' = c(0, -3, 1, -2),
              '^dim7$' = c(0, -3, -6, -9),
              '^hdim7$' = c(0, -3, -6, -2),
              '^minmaj7$' = c(0, -3, 1, 5),
              '^sus2$' = c(0, 2, 1),
              '^sus4$' = c(0, -1, 1),
              '^maj6$' = c(0, 4, 1, 3),
              '^min6$' = c(0, -3, 1, 3),
              '^9$' = c(0,4,-2,2),
              '^maj9$' = c(0, 4, 5, 2),
              '^min9$' = c(0, -3, -2, 2),
              '^min11$' = c(0, -3, -2, -1),
              '^11$' = c(0, 4, -2, -1),
              '^13$' = c(0, 4, -2, 3),
              '^maj13$' = c(0, 4, 5, 3),
              '^min13$' = c(0, -3, -2, 3),
              '^5$' = c(0,1),
              '^1$' = c(0))


chordtonotes = function(token) {

  orig = token
  if(token == 'N') return(NA)
  if(token == 'F:b3)') token = 'F:1(b3)'
 token = strsplit(token, ':')[[1]]


 root = gsub('b', '-',token[1])
 token = token[-1]
 token = strsplit(token, '/')[[1]]


 if(length(token) == 2) bass = token[2] else bass = NA
 qual = token[1]

 if(grepl('\\(', qual)) {
   extra = unlist(strsplit(gsub('.*\\(', '', gsub('\\)$', '', qual)) , ','))
   qual = gsub('\\(.*\\)', '' , qual)
   } else extra = NA


 ####Now we get to work
 rooti = which(Notes == root)

 chordtones = Notes[rooti + qualities[[which(sapply(names(qualities), function(regex) grepl(regex, qual)))[1]]]]


 if(any(!is.na(extra))) {
   for(i in extra){
    chordtones = c(chordtones, Notes[rooti + intervals[[i]]])
   }}


 if(!is.na(bass)) {
  bassnote = Notes[rooti + intervals[[bass]]]

  if(bassnote %in% chordtones){
    chordtones = c(bassnote, chordtones[-which(chordtones == bassnote)])
  } else {
    chordtones = c(bassnote, chordtones)
  }

 }

 paste(chordtones, collapse=' ')



}
