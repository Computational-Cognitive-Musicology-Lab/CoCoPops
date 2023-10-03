setwd("~/Bridge/Research/Data/CoCoPops/RollingStoneCorpus/Scripts")

library(humdrumR)

flpath <- dir('../OriginalData/', pattern = '\\.fl*', full.names = TRUE)
fl <- lapply(flpath, readLines) |> lapply(FUN = \(x)  strsplit(head(stringr::str_trim(x), -1), split = '  *'))

fl <- lapply(fl, \(x) as.data.table(do.call('rbind', lapply(x, \(l) c(l[1:7], if (length(l) > 7) paste(l[-1:-7], collapse = ' ') else NA)))))


fl <- lapply(fl, \(x) x[,  Bar := floor(as.numeric(V1))])
secLabels <- c(Vr = 'Verse', Vrf = 'Verse', 
               Ch = 'Chorus', 
               Br = 'Bridge',  BBr = 'Bridge2', Bo = 'Bridge',
               Bld = 'Build',
               In = 'Intro', Intro = 'Intro', 
               Prec = 'PreChorus', 
               Bk = 'Break',
               Tr = 'Transition', 
               Rf = 'Refrain', Rfb = 'Refrain', Ref = 'Refrain',
               Pc = 'PreChorus', 
               Coda = 'Coda', Co = 'Coda', 
               Ou = 'Outro',  
               Tg = 'Tag', Ta = 'Tag',
               Li = 'Link', Ln = 'Link', Ex = 'Link',
               Fadeout = 'Fadeout',
               Inst = 'Instrumental', Inst = 'Vinst',
               Solo = 'Solo', So = 'Solo', Vrsolo = 'Solo')           

removeLab <- c('X', 'VP', 'St', 'BP', 'VP', 'Chext')

cleanNames <- function(x) {
  x <- gsub('\\$', '', x)

  x[x %in% names(secLabels)] <- secLabels[x[x %in% names(secLabels)]]
  
  x
}

####

fl <- lapply(fl, \(x) {
  form <- x$V8
  
  form <- gsub('end', '', form)
  form <- gsub('([a-z])[1-9]+(b[1-2]?)?', '\\1', form)
  lab <- strsplit(form, split = ' ')
  lab <- lapply(lab, cleanNames)
  lab <- lapply(lab, \(x) x[!grepl('^Z', x)])
  lab <- lapply(lab, \(x) {
    x <- x[!x %in% removeLab]
    hit <- x %in% secLabels
    if (any(hit)) {
      i <- tail(which(hit), 1L)
      x[i]
    } else {
      x
    }
  })
  maxl <- max(lengths(lab))
  lab <- lapply(lab, '[', 1:maxl)
  x <- cbind(x[,1:7, with = FALSE], form, do.call('rbind', lab))
  colnames(x)[9:ncol(x)] <- LETTERS[1:maxl]
  x
  
  
})

fl <- Map(\(x, y) x[ , File := y], fl, basename(flpath))

fl <- rbindlist(fl, fill = TRUE)



flx <- fl[ , .SD[!duplicated(form)], by = File]

########

################# 

uniq <- sort(unique(unlist(flx[ , c('A','B','C','D','E'), with = FALSE])))

fac <- \(f) factor(f, levels = uniq)

hierTab <- fl[,table(fac(A), fac(B)) + table(fac(B), fac(C)) + table(fac(C), fac(D)) + table(fac(D), fac(E))]

lapply(uniq, \(v) {
  z <- hierTab[, v]
  z <- z[z != 0]
  
  y <- hierTab[ v,]
  y <- y[y != 0]
  
  data.table(Above = if (length(z)) paste(names(z), collapse = ', ') else NA, 
             Self = v, 
             Below = if(length(y)) paste0(names(y), collapse = ', ') else NA)
}) |> do.call(what = 'rbind') -> hier

sapply(LETTERS[1:5], \(l) {
  lab <- fl[ , l, with = FALSE][[1]]
  ifelse(lab %in% paste0('$', names(secLabels)), lab, NA)
  
  
  })

l <- function(x) {
  if (length(x) == 0) return(rep(NA, nrow(fl)))
  lab <- gsub('end', '', gsub('[1-9]$', '', gsub('\\$','', x[[1]])))
  ifelse(lab %in% names(secLabels), secLabels[lab], Recall(as.list(x)[-1]))
}

alph <- function(x) {
  if (length(x) == 0) return(rep(NA, nrow(fl)))
  lab <- gsub('\\$','', x[[1]])
  ifelse(lab %in% LETTERS, lab, Recall(as.list(x)[-1]))
}

alpha <- alph(fl[,LETTERS[1:5], with = FALSE])
labels <- l(fl[,LETTERS[1:5], with = FALSE])

# show
fl[ , Interp := paste0('*', gsub(' *\\$', '>', V8))]


form <- function(n = 1){
  cur <- fl[File == unique(File)[n]]
  cur <- cur[!duplicated(Interp)]
  cat(cur$File[1], ':\n', sep = '')
  cur[ , cat('\t', V1, ':\t', Interp, '\n', sep = ''), by = 1:nrow(cur)]
  invisible(NULL)
}


################# 

unique <- sort(unique(unlist(strsplit(fl$V8, split = ' '))))
