

melodicFiles <- dir('MelodicTranscriptions', 'krn$')

basenames <- gsub('\\.krn$', '', melodicFiles)


harmonicFiles  <- dir('HarmonicTranscriptions/Edited', 'hum$')
harmonicFiles2 <- sapply(basenames, function(bn) grep(bn, harmonicFiles, value = TRUE)[1])

cat(melodicFiles[is.na(harmonicFiles2)], sep = '\n')

Map(function(mel, harm) {
	sum(grepl('^=', readLines(mel))) - sum(grepl('^=', readLines(harm)))

}, paste0('MelodicTranscriptions/', melodicFiles), 
   paste0('HarmonicTranscriptions/Edited/', harmonicFiles2)) -> x

x <- unlist(x)

x <- data.frame(File = basenames, Diff = x)

row.names(x) <- NULL
print(warnings())
x[x$Diff != 0,]
