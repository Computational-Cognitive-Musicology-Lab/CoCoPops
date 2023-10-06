met.int = function(meter) {
  meter = as.numeric(unlist(strsplit(meter, split = '/')))
  paste('*M', meter[1], '/', meter[2], sep = '')
  }
key.int = function(key)   {paste('*' , gsub('b$', '-', key), ':' , sep = '')}
#possible meters (at outset) 12/8 3/4 4/4 5/4 6/8 7/4
#also 1/4 2/4 3/8 5/8 6/4 9/4 9/8 in bodies

ditto = function(x){
  targets = which(x != '.')

  d = diff(c(targets, length(x) + 1))

  output=rep.each(x[targets],d)
  if(targets[1]!=1) output=c(x[1:(targets[1]-1)],output)

  return(output)
}

measure_breakdown=function(measure_row){
  ## THIS IS THE BIG FUNCTION, it
  # 1) detencts changes of meter that apply either, only to this measure, marked with (), or which propogate to next measures, marked #
  # 2) figures out how the chords in the measure are form beats
  # 3) inserts durations
  if(measure_row[1, 1] == '1r;')   return(matrix(c('1r;', 'silence', '.', measure_row[1, 4], measure_row[1, 5]), nrow = 1))
  if(measure_row[1, 1] %in% c('&pause', '*')) return(matrix(c('1r;', 'fermata', '.', measure_row[1, 4], measure_row[1, 5]), nrow = 1))

  measure = unlist(strsplit(measure_row[ , 1], split = ' ')) # splits measure into objects in measure

  # if(any(grepl('&pause', measure))) measure[measure=='&pause'] = 'r'

  ##############################
  ######1 detect local and or global meter changes
  ######################

  if(grepl('[\\(#][1-9]/[48]', measure[1])) {

    cur.meter = gsub('^[#\\(]', '', gsub('\\)$', '', measure[1]))

    if(grepl('^#',measure[1])) { Meter <<- cur.meter } #if its a hashtag, need to change the global meter

    measure = measure[-1]
  } else {cur.meter = Meter}

  if(grepl('^#', measure[1])){#now searching for key changes...this has to come after the meter stuff
    Key <<- gsub('^#', '', measure[1])
    measure = measure[-1]
  }

  ##################################################
  #2-3) key and meter things should be gone now
  #################################################

  if(any(measure == '.')) measure = ditto(measure)#[-1] # ditto fills in null tokens with previous chord
  #
  output = rhythmicize.measure(measure, cur.meter)
  output = cbind(matrix(output, ncol=1), matrix('.', ncol=4, nrow = length(output)))
  output[1, 2:5] = as.matrix(measure_row)[1, 2:5]

  attr(output, which ='meter') = met.int(cur.meter)
  attr(output, which = 'key')  = key.int(Key)
  return(output)
}

rhythmicize.measure=function(measure,meter){
  if(any(measure == '*')) {
    if(length(measure) == 1) measure = 'N' else  measure[measure == '*'] = measure[which(measure == '*') - 1]}

  met = met.int(meter)
  #this first group always only has one chord in the measure (in the McGillCorpus) so it is simply a matter of adding the appropriate durations to the one symbol
  if(met == '*M3/8') return(paste('4.', measure, sep = ''))
  if(met == '*M5/8') return(paste(c('4.','4'), measure, sep = ''))
  if(met == '*M9/8') return(paste(c('2.','4.'), measure, sep = ''))
  if(met == '*M1/4') return(paste('4', measure, sep = ''))

  if(met == '*M9/4') return(paste('4', measure, sep = ''))

  #4/4 the most common example
  if(met == '*M4/4'){
    if(length(measure) == 1){ return(paste('1', measure, sep = ''))} #if theres only one chord, it's just a whole note
    if(length(measure) == 2){ return(paste('2', measure, sep = ''))} #if theres only two symbols, its two half notes
    if(length(measure) == 4){ #if theres four symbols

      dur = rep(.25, 4)
      if(any(tail(measure, -1) == head(measure, -1))){
       remove = c()
      for(b in 4:2){
        if(measure[b] == measure[b-1]) {
          dur[b - 1] = dur[b] + dur[b-1]
          remove = c(remove, b)
        }
      }

      dur = dur[-remove]
      measure = measure[-remove]
      }


      dots = rep('', length(measure))
      dots[dur == .75] = '.'

      measure = paste((rep(1, length(dur)) + (as.numeric(dur == .75) * .5)) / dur, dots, measure, sep='')

      return(measure)
    }
    browser() ; return('ERROR')
  }

  #12/8 much like 4/4
  if(met == '*M12/8'){
    if(length(measure) == 1){ return(paste('1.', measure, sep= '')) } #if theres only one chord, it's just a dotted whole note
    if(length(measure) == 2){ return(paste('2.', measure, sep= ''))} #if theres only two symbols, its two dotted-half notes
    if(length(measure) == 4){ #if theres four symbols
      dur = rep(.25,4)
      if(any(tail(measure, -1) == head(measure, -1))){
        remove = c()
        for(b in 4:2){
          if(measure[b] == measure[b-1]) {
            dur[b - 1] = dur[b] + dur[b-1]
            remove = c(remove, b)
          }
        }

        dur = dur[-remove]
        measure = measure[-remove]
      }

      if(any(dur == .75)){
        if(dur[1] == .75) {
          dur=c(.5,.25,dur[2])
          measure = c(measure[1], measure[1], measure[2])
        }
        if(dur[2] == .75) {
          dur = c(dur[1], .25, .5)
          measure = c(measure[1], measure[2], measure[2])
        }

      }
      dur = paste(1/dur, '.', sep = '')

      return(paste(dur, measure, sep=''))
    }
    browser() ; return('ERROR')
  }

  #3/4
  if(met == '*M3/4'){
    if(length(measure) == 1){ return(paste('2.', measure, sep='')) } #if theres only one chord, it's just a dotted-half note
    if(length(measure) == 2){ browser() ; return('ERROR')} #if theres only two symbols, its an error
    if(length(measure) == 3){ #if theres three symbols, just need to figure out how the durations work
      dur = rep(.25, 3)
      cur = tapply(dur, measure, sum)
      measure = names(cur)
      measure = paste((rep(1, length(cur)) + (as.numeric(cur == .75) * .5)) / cur, rep('.', length(measure))[cur == .75], measure, sep='')


      return(measure)
    }
    browser() ; return('ERROR')
  }

  #6/8
  if(met == '*M6/8'){
    if(length(measure) == 1) return(paste('2.', measure, sep='')) #if there's only one chord, its a dotted-half
    if(length(measure) == 2) return(paste('4.', measure, sep='')) #if there's two chords they're dotted quarters
    browser() ; return('ERROR')
  }

  #6/4
  if(met == '*M6/4'){
    if(length(measure) == 1) return(paste('1.', measure, sep='')) #if there's only one chord, its a dotted-whole
    if(length(measure) == 2) return(paste('2.', measure, sep='')) #if there's two chords they're dotted halfs
    if(length(measure) == 6) return(paste('4', measure, sep='')) #else theres a chord on every beat
    browser() ; return('ERROR')
  }

  #5/4
  if(met == '*M5/4'){
    if(length(measure) == 1) return(paste(c('2.','2'), measure[c(1, 1)], sep = '')) #if there's only one chord, its got to be tied
    if(length(measure) == 5) return(paste('4', measure, sep='')) #else theres a chord on every beat
    browser() ; return('ERROR')
  }

  #7/4
  if(met == '*M7/4'){
    if(length(measure) == 1) return(paste(c('1','2.'), measure[c(1, 1)], sep = '')) #if there's only one chord, its got to be tied
    if(length(measure) == 7) return(paste('4', measure, sep = '')) #else theres a chord on every beat
    browser() ; return('ERROR')
  }

  #9/4
  if(met == '*M9/4'){
    if(length(measure) ==1 ) return(paste(c('2.', '2.', '2.'),measure[c(1, 1, 1)], sep = '')) #if there's only one chord, its got to be tied
    if(length(measure) ==9 ) return(paste('4', measure, sep = '')) #else theres a chord on every beat
    browser() ; return('ERROR')
  }

  #2/4
  if(met == '*M2/4'){
    if(length(measure) == 1) return(paste('2', measure, sep=''))
    if(length(measure) == 2) return(paste('4', measure, sep=''))
    browser() ; return('ERROR')
  }

}

library(stringr)
setwd('~/Bridge/Research/Data/McGillRockHarmony/')


files = dir('Unaltered/SalamiFiles/', full.names = TRUE)
spread = read.delim('BillboardSampleData.tsv', stringsAsFactors = FALSE)
spread$chart_date = gsub('-', '/', spread$chart_date)
spread$inputfile = paste('Unaltered/SalamiFiles/', str_pad(spread$id, width = 4, side = 'left', '0'), '.txt', sep = '')
##filename conventions: Only use A-Za-z0-9, get rid or parentheticals, and change & to "And"
spread$outputfile = paste('Humdrum/Unedited/',
                          gsub('[^A-Za-z0-9]', '', gsub('&', 'And',gsub('\\(.*\\)', '', spread$artist))), '_',
                          gsub('[^A-Za-z0-9]', '', gsub('&', 'And',gsub('\\(.*\\)', '', spread$title))), '_',
                          gsub('\\/.*', '', spread$chart_date),
                          '.hum',
                          sep = ''
                          )

spread = subset(spread, !is.na(actual_rank ))

salami = lapply(files, readLines)
names(salami) = gsub('.*/', '', gsub('\\.txt', '', files))

uniques = !duplicated(paste(spread$artist , spread$title, sep = ' - '))

salami = salami[uniques]


spread = do.call('rbind',
                 by(spread, paste(spread$artist , spread$title, sep = ' - '), function(song) {
                    if(nrow(song) >1 ) { song[1 , c(1:4, 7, 8)] = apply(song[1:nrow(song), c(1:4, 7, 8) ], 2, paste, collapse = ', ') }

                    song[1 , ]
                    }
                    )
                 )
rownames(spread) = NULL

spread = spread[order(as.numeric(gsub(', .*', '', spread$id))), ]



ReferenceRecords = lapply(seq_len(nrow(spread)),
                         function(i) {
                           paste('!!!',
                                 c('OTL', 'COC', 'BillboardChartDate', 'BillboardPeak', 'BillboardWeeksOnChart', 'SampleTargetRank',  'SampleActualRank', 'SampleID#'),
                                 ': ',
                                 unlist(c(spread[c('title', 'artist', 'chart_date', 'peak_rank', 'weeks_on_chart', 'target_rank', 'actual_rank')][i, ],
                                   str_pad(spread['id'][i, ], width = 4, side = 'left', '0'))),
                                 sep = '')
                           }
                         )



 #
#
process_salami = function(file) {
  hash = grep('^#', file, value = TRUE)

  body = file

  Meter <<- gsub('.* ', '', hash[3])
  Key <<- gsub('.* ', '', hash[4])

  #separate timestamps
  timestamps = gsub('\t.*','',body)
  timestamps = suppressWarnings(round(as.numeric(timestamps),3))

  #
  phrases=gsub('[^\t]*\t', '', body)
  #seperate phrase headers and footers
  phraseHeaders = gsub(', ', '_', gsub(',* *$', '', gsub('\\|.*$', '', phrases)))
  phraseFooters = gsub('^[, ]', '', gsub('^.*\\|', '', phrases))
  phraseFooters[phraseFooters==''] = '.'

  #remove headers and footers
  phrases=gsub('^ ', '', gsub('^[^\\|]*\\|', '', phrases)) # headers
  phrases=gsub(' $', '', gsub('\\|[^|]*$', '', phrases)) # footers

  phrases[phraseHeaders == phraseFooters & phraseHeaders != ''] = '.'
  #phrases[grep('^Z', phrases)] = '.'


  phrase_frame = data.frame(phraseHeaders, phrases, phraseFooters, timestamps, stringsAsFactors = FALSE)

  phrase_frame$Nmeasures = as.numeric(!is.na(phrase_frame[ , 2])) * (count.char('|', phrase_frame[ , 2]) + 1)


  #incorporate key and meter changes that are specified by #, by adding them to the following measure, with a # to distinguish them from () changes that only affect a single measure
  for(i in grep('^#', file)[-1:-4]){
    insert = paste('#', gsub('^#.*: ', '', file[i]), ' ', sep='')
    phrase_frame$phrases[i + 1] = paste(insert, phrase_frame$phrases[i + 1], sep='')
  }

   phrase_frame = phrase_frame[grep('^#', invert = TRUE, file), ]
   phrase_frame = phrase_frame[phrase_frame$phrases != '', ]

  ##Some phrases have repeat indications (x4 for instance) in their Footer
  for(i in grep('x[1-9]', phrase_frame$phraseFooters)){
    xrep = as.numeric(gsub('^.*x', '', gsub(',.*', '', phrase_frame$phraseFooters[i])))

    phrase_frame$phrases[i] = paste(rep(phrase_frame$phrases[i], xrep), collapse=' | ')
    phrase_frame$Nmeasures[i] = phrase_frame$Nmeasures[i] * xrep
  }

  ##Clean up footers
  phrase_frame$phraseFooters = gsub('x[0-9][0-9]*', '', phrase_frame$phraseFooters)
  phrase_frame$phraseFooters = gsub('^,* ', '', phrase_frame$phraseFooters)
  ####

  measures = unlist(strsplit(phrase_frame$phrases, split = ' \\| '))
  phrase.measures = section.measures = timestamp.measures = footer.measures = c()
  for(i in 1:nrow(phrase_frame)){

    if(phrase_frame$Nmeasures[i] == 0) {
      phrase.measures    = c(phrase.measures, phrase_frame$phrases[i])
      section.measures   = c(section.measures, phrase_frame$phraseHeaders[i])
      timestamp.measures = c(timestamp.measures, phrase_frame$timestamps[i])
      footer.measures    = c(footer.measures, phrase_frame$phraseFooters[i])
    } else {
      phrase.measures  = c(phrase.measures, 'newline', rep('.', phrase_frame$Nmeasures[i] - 1))

      section.measures = c(section.measures, ifelse(phrase_frame$phraseHeaders[i] == '', '.', phrase_frame$phraseHeaders[i]),
                         rep('.', phrase_frame$Nmeasures[i] - 1))

      timestamp.measures = c(timestamp.measures,phrase_frame$timestamps[i], rep('.', phrase_frame$Nmeasures[i] - 1))

      footer.measures = c(footer.measures, phrase_frame$phraseFooters[i], rep('.', phrase_frame$Nmeasures[i] - 1))
    }

  }

  measures[section.measures %in% c('silence', 'end')] = '1r;'
  measures[grep('Z', section.measures)] = '1r;'


  measure_frame = data.frame(measures, phrase.measures, section.measures, timestamp.measures, footer.measures, stringsAsFactors = FALSE)
  #######################
  beat_frame = list()
  beat_frame[[1]] = cbind(c('**chords', met.int(Meter), key.int(Key)),
                          c('**phrase', '*', '*'),
                          c('**timestamp', '*', '*'),
                          c('**leadinstrument', '*', '*'))
  meters = c()
  l = 2
  m = 1 #measure counter
  last.meter = met.int(Meter)
  last.key = key.int(Key)

  for(i in 1:nrow(measure_frame)){
    cur = measure_breakdown(measure_frame[i, ])

    if(cur[1, 1] == '1r;') {
      cur.meter = last.meter
      cur.key = last.key
      beat_frame[[l]] = cur[ , -3]
      l = l+1
    } else {

      cur.meter = attr(cur, 'meter')
      cur.key = attr(cur, 'key')

      beat_frame[[l]] = paste('=', rep(m, 4), sep='') ; l = l + 1 ; m = m + 1 #barlines
      if(cur[1,3] != '.') { beat_frame[[l]] = rep(paste('*>', cur[1, 3], sep = ''), 4) ; l = l + 1} #sections
      if(all(cur.key != last.key)) { beat_frame[[l]] = rep(cur.key, 4) ; l = l + 1} #key if necessarry
      if(all(cur.meter != last.meter)) {beat_frame[[l]] = rep(cur.meter, 4) ; l = l + 1} #meter if necessarry
      beat_frame[[l]] = cur[ , -3] ; l = l + 1# data
      meters[l] = attr(cur, 'meter')
    }
    last.meter = cur.meter
    last.key = cur.key
  }
  beat_frame[[l]] = rep('*-', 4)

  tran = do.call('rbind',beat_frame)

  #remove "Z'
  tran[tran[ ,4] == 'Z', 4] = '?'
  tran[ , 4] = gsub('Z, ', '', tran[ , 4])

  ## remove primes ( i.e. A') from section labels. Change to numbers, i.e. A = A, A' = A2, A'' = A3
  for(i in grep("\\*>", tran[ , 1])) {
    tran[i, ] = gsub("''*", str_count(tran[i, 1], "'") + 1, tran[i, ])

  #clean up section labels to make consisent
    tran[i, ] = gsub(' two| three| four| one| five', '', tran[i, ])
    tran[i, ] = gsub(' two| three| four| one| five', '', tran[i, ])
    tran[i, ] = gsub('fade in', 'fadein', tran[i, ])
    tran[i, ] = gsub('fade out', 'fadeout', tran[i, ])
    tran[i, ] = gsub('\\(|\\)', '', tran[i, ])
    tran[i, ] = gsub('pre[- ]', 'pre', tran[i, ])
    tran[i, ] = gsub(' [ab]$', '', tran[i, ])
    tran[i, ] = gsub(' break', '', tran[i, ])
    tran[i, ] = gsub('^trans$', 'transition', tran[i, ])
    tran[i, ] = gsub('-', ' ', tran[i, ])
    tran[i, ] = gsub(' ', '', tran[i, ])
    tran[i, ] = gsub('\\*>([^A-Z])', '*>_\\1', tran[i, ])
    tran[i, ] = gsub('\\*>([A-Z])$', '*>\\1_', tran[i, ])


    }


  tran
}

trans = lapply(salami, process_salami)

### FIX TWO "*" tokens which appear in salami 25 and 446
### translate chords

###
#

#
#
#
# #
# #



source('McGillChordSymbolToNotes.R')

trans = lapply(trans,
               function(tran) {
                 output = cbind(tran, tran[ ,1])
                 data = grep('^[!=*.]|r;', tran[ ,1], invert = TRUE)

                 output[ data ,ncol(output)] = unlist(lapply(gsub('^[0-9]+\\.*', '', tran[ data, 1]), chordtonotes))
                 output[1, ncol(output)] = c('**notes')
                 output[ output[ , ncol(output)] == '1r;', c(2,4,5)] = 'r'
                 output
               }
)

# Notes = c('Fb', 'Cb', 'Gb', 'Db', 'Ab', 'Eb', 'Bb', 'F', 'C', 'G', 'D', 'A', 'E',  'B', 'F#', 'C#', 'G#', 'D#', 'A#')
#
Major = c(b2='M',b6='M',b3='M','M','M', 'M', 'M', 'm', 'm', 'm', 'd','d','M')
minor = c('M','M','M','M', iv = 'm', 'm', 'm','d')
#
process_harmony = function(tran) {
 ind = grep('^[=!*.]', invert = TRUE, tran[ ,1])
 tokens = tran[ind, 1]

 Durations =  gsub(':.*', '', tokens)
 Roots =  gsub('^[1-9]\\.*', '', Durations)
 Roots[Roots %in% c('N')] = NA

 Durations = gsub('[A-GNr];*.*', '' , Durations)

 Quality = gsub('^.*:', '' , tokens)
 Quality[grepl('r;|N', Quality)] = NA
 Bass = '1'
 Quality = gsub('/.*', '', Quality)

 dur = roots = qual = bass = tran[ , 1]

 dur[ind] = Durations
 roots[ind] = Roots
 qual[ind] = Quality
 bass[ind] = Bass



 tran = cbind(dur, roots, qual, bass, tran[, -1])
 tran[1, 1:4] = c('**recip', '**root', '**quality', '**bass')

 tran
}
#
#

trans = lapply(trans, process_harmony)


trans = lapply(trans,
                function(tran) {
                  keys = grepl('^\\*[A-Ga-g]', tran[,1])
                  keyscs =  gsub(':','',gsub('^\\*', '' ,c('', rle(tran[keys, 1])$values)[1 + cumsum(keys)]))

                  for(i in seq_len(sum(keys))) {
                    ind = which(keyscs == gsub(':','',gsub('^\\*', '' , grep('^\\*[A-Ga-g]', tran[,1], value = TRUE)[i])))

                    # print(unique(tran[ind,][gsub('b', '-', tran[ind , 2]) == keyscs[ind], 3]))
                    rootqual = unique(tran[ind,][tran[ ind, 2] == keyscs[ind], 3])

                    if('min' %in%  rootqual || 'min7' %in% rootqual && !'maj' %in% rootqual && !'7' %in% rootqual ) {

                      tran[grep('^\\*[A-Ga-g]', tran[,1])[i] ,] =  tolower(grep('^\\*[A-Ga-g]', tran[,1], value=T)[i])
                    }
                  }
                tran
                }
)


subs = do.call('rbind',strsplit(readLines('MirexSubstitutions'), split = '\t'))

subs = gsub('.*:','',subs)
subs = apply(subs,1, paste, collapse=' - ')
subs = strsplit(subs[!duplicated(subs)], split = ' - ')
subs = do.call('rbind', subs)

subs[ subs[ , 1] =='dim7' , 2] = 'dd'
subs[ subs[ , 1] =='dim' , 2] = 'd'
subs[ subs[ , 1] =='hdim7' , 2] = 'dm'
subs[ subs[ , 1] =='aug' , 2] = 'A'
subs[ subs[ , 1] =='aug(b7)' , 2] = 'Am'
subs[ subs[ , 1] =='aug(9)' , 2] = 'Am'
subs[ subs[ , 1] =='aug(7)' , 2] = 'AM'

subs[subs[,2] == '7', 2] = 'Mm'
subs[subs[,2] == 'maj', 2] = 'M'
subs[subs[,2] == 'maj7', 2] = 'MM'
subs[subs[,2] == 'min', 2] = 'm'
subs[subs[,2] == 'min7', 2] = 'mm'
subs[subs[,2] == 'mm7', 2] = 'mm'


qualityfromkey = function(tran, i){
  keys = grepl('^\\*[A-Ga-g]', tran[,1])
  keys =  gsub(':','',gsub('^\\*', '' ,c('', rle(tran[keys, 1])$values)[1 + cumsum(keys)]))

  root = gsub('b', '-', tran[i , 2])


  int = which(Notes == root) - which(Notes == toupper(keys[i]))

  if(toupper(keys[i]) == keys[i]) {
    ScaleQual = c('-9' = 'M?', '-8' = 'M?', '-7' = 'M?', '-6' = 'M', '-5' = 'M', '-4' = 'M', '-3' = 'M', '-2' = 'M', '-1' = 'M',
                  '0' = 'M', '1' = 'M', '2' = 'm', '3' = 'm', '4' = 'm', '5' = 'm', '6' = 'M?', '7' = 'M?', '8' = 'M?','9' = 'M?', '10' = 'M?')
  } else {
    ScaleQual = c('-9' = 'M?', '-8' = 'M?', '-7' = 'M?','-6' = 'M', '-5' = 'M', '-4' = 'M', '-3' = 'M', '-2' = 'M', '-1' = 'm',
                  '0' = 'm', '1' = 'm', '2' = 'm', '3' = 'm', '4' = 'm', '5' = 'm', '6' = 'M?', '7' = 'M?', '8' = 'M?')
  }

  qual = ScaleQual[as.character(int)]

  # cat('Root:', tran[i, 2],'\t')
  # cat('Key:', keys[i],'\t')
  # cat('Qual:', qual,'\n')
  qual
}


trans = lapply(trans,
       function(tran) {
         sub = tran[ , 3]
         for( i in which(!tran[ , 3] %in% c('maj', 'min', 'min7', 'maj7', '7') & !grepl('^[!=*]', tran[ ,3]) & !is.na(tran[,3]))) {
             hit = subs[tran[i, 3] == subs[,1], 2]
             if(length(hit) == 0) sub[i] = 'X'
             if(length(hit) == 1) sub[i] = hit

         }

         sub[gsub('\\(.*\\)', '' , tran[,3]) %in% c('sus4')] = 'sus4'
         sub[gsub('\\(.*\\)', '' , tran[,3]) %in% c('sus2')] = 'sus2'

         sub = unlist(lapply(sub, function(x) {
           changes = switch(x, 'maj' = 'M', 'min' = 'm', 'maj7' = 'MM', 'min7' = 'mm', '7' = 'Mm', 'mm7' = 'mm')
           if(is.null(changes)) x else changes
         }))



         for( i in which(gsub('\\(.*\\)', '' , tran[ , 3]) %in% c('5', '1','sus2','sus4') & !grepl('^[!=*]', tran[ ,3]) & !is.na(tran[,3]))) {
               sameroots = sub[tran[,2] == tran[i,2] ]
               sameroots = sameroots[sameroots != 'X']
               if(length(unique(sameroots)) == 1 && !is.na(sameroots)) {
                 sub[i] = unique(sameroots)
                 }
               else {
                new = qualityfromkey(tran, i)

                  # if(new == 'X') browser()
                sub[i] = new
               }
             }
           cbind(tran, sub)
       }
)

trans = lapply(trans,
               function(tran) {
                tran[ tran[,9] == 'X' & tran[,2] =='r', 9] = 'r'
                tran[!grepl('^[=!*]', tran[ ,2]), 2] = gsub('b', '-', tran[!grepl('^[=!*]', tran[ ,2]), 2])
                tran = tran[ , -4]

                new = tran[ ,1]
                data = !grepl('^[!=*]', new)

                new[data] = paste(tran[data,1], tran[data,2], tran[data,8], sep='')
                new[1] = '**harmony'
                new[new == 'rr'] = '1r;'
                new = gsub('NANA', 'N', new)
                new = gsub('NA', 'X', new)

                tran[1,3] = '**chordsym'
                tran[data, 3] = paste(tran[data,3], paste('(',tran[data,7],')', sep=''))

                tran[, 3] = gsub(' \\(r\\)', '', tran[ ,3])
                tran[, 3] = gsub('NA \\(NA\\)', '', tran[ ,3])

                tran[data, 3] = paste0(tran[data, 2], ':', tran[data, 3])
                tran[ , 3] = gsub('[rN]:', '', tran[ , 3])


                out = cbind(new, tran[ , c(3,4,5,6)])



                out[data, 5] = ditto(gsub('\\(|\\)','', out[data, 5]))
                out[out[ ,3] == 'r', 3] = '.'
                out[out[ ,4] == 'r', 4] = '.'

                out[out[ , 2] == 'NA:NA', 2] = 'r'
                out[out[ , 2] == 'NA:', 2] = 'N'
                out[grepl('r;:', out[ , 2]), 2] = 'r'

                out[ , 1] = gsub(';X', ';', out[ , 1])

                out
               }
)



Stack = do.call('rbind',trans)
stack = subset(Stack, !grepl('^[=*!]', Stack[,1]))

ReferenceRecords = lapply(ReferenceRecords,
                          function(RR) {
                            c(RR,
                              '!!!RDF**harmony: **recip + pitch class of root + chord quality' ,
                              '!!!RDF**chordsym: original McGill chord annotation + (implied pitch class set, with bass pitch in first position)',
                              '!!!RDF**phrase: newline = linebreak in original McGill transcription',
                              '!!!RDF**timestamp: McGill audio timestamp in seconds',
                              '!!!RDF**leadinstrument: original McGill primary instrumentation annotation',
                              paste0('!!!RDT: ', gsub('-', '/', Sys.Date()),'/'),
                              '!!!ENC: Nathaniel Condit-Schultz',
                              '!!!EST: Awating manual error checking and editing.',
                              '!!!EMD:'

                            )
                            }
)

lapply(seq_len(nrow(spread)),
       function(i) {
         write.table(trans[[i]], file = spread$outputfile[i],
                     quote = FALSE, sep = '\t', row.names = FALSE, col.names = FALSE)
         write(ReferenceRecords[[i]], file = spread$outputfile[i], append = TRUE,  ncolumns = 1)

       }
)
