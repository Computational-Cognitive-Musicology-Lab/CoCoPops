fread('~/Bridge/Research/Data/CoCoPops/Billboard/Billboard_Sample.tsv') -> bb
fread('~/Bridge/Research/Data/CoCoPops/Billboard/Resources/Transcription/TranscriptionInfo.tsv') -> bbt
fread('~/Bridge/Research/Data/CoCoPops/RollingStone/RollingStone_Sample.tsv') -> rs




bb[ , 1:4, with = FALSE] -> bb
bbt[match(bbt$FileName, bb$Filename)] -> bbt
bb[ , Melody := bbt[ , !is.na(Transcriber) & Transcriber != '_']]
bb[ , Harmony := TRUE]
bb[ , Lyrics := Melody]
bb[ , Billboard := TRUE]
bb[ , RollingStone := FALSE]
colnames(bb)[4] <- 'YEAR'

rs[ , c(1:4, 7), with = FALSE] -> rs
colnames(rs)[4:5] <- c('YEAR', 'Lyrics')
rs[ , Harmonic := TRUE]
rs[ , Melodic := TRUE]


