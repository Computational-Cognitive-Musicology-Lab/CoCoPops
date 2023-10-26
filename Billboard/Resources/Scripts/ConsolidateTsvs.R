fread('~/Bridge/Research/Data/CoCoPops/Billboard/Billboard_Sample.tsv') -> bb
fread('~/Bridge/Research/Data/CoCoPops/Billboard/Resources/Transcription/TranscriptionInfo.tsv') -> bbt
fread('~/Bridge/Research/Data/CoCoPops/RollingStone/RollingStone_Sample.tsv') -> rs



setorder(bb, Filename)
setorder(bbt, Filename)
bb[ , 1:4, with = FALSE] -> bb
bb$Melody <- bbt[ , !is.na(Transcriber) & Transcriber != '_']

bb[ , Harmony := TRUE]
bb[ , Lyrics := Melody]
colnames(bb)[4] <- 'YEAR'
bb[ , YEAR := as.integer(gsub('/.*', '', YEAR))]
bb[ , Corpus := 'Billboard']



rs[ , c(1:4, 7), with = FALSE] -> rs
colnames(rs)[4:5] <- c('YEAR', 'Lyrics')
rs[ , Harmony := TRUE]
rs[ , Melody := TRUE]
rs[, Corpus := 'Rolling Stone']

coco <- rbind(bb, rs)
setcolorder(coco, neworder = c(8,1,2,3,4,5,6,7))
colnames(coco) <- stringr::str_to_title(colnames(coco))

fwrite(coco, '~/Bridge/Research/Data/CoCoPops/CoCoPops_Sample.tsv', quote = FALSE, sep = '\t')
