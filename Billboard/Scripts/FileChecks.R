#!/usr/bin/env Rscript

library(data.table)
library(magrittr)
setwd('../')


tsv <- fread('BillboardTranscriptionData.tsv')


tsv[ , XML := paste0('MelodicTranscriptions/XML/', FileName, '.musicxml')]
tsv[ , KRN := paste0('Humdrum/MelodicTranscriptions/', FileName, '.krn')]
tsv[ , HUM := paste0('Humdrum/CompleteTranscriptions/', FileName, '.hum')]

tsv[ , Checked := Transcriber != "_"]


cat("\nAccording to BillboardTranscription.tsv:\n\n")

tsv[ , cbind(Checked = sum(Checked, na.rm = TRUE), 
             `.xml` = sum(file.exists(XML)), 
             `.krn` = sum(file.exists(KRN)), 
             `.hum` = sum(file.exists(HUM)))] %>% print


##

## XML

cat('\n')
xmlfiles <- dir('MelodicTranscriptions/XML/', '.*xml')

if (all(xmlfiles %in% basename(tsv$XML))) {
  cat("All xmlfiles files in 'MelodicTranscriptions/XML/' are marked in transcription spreadsheet.\n" ) 
  
  if (any(basename(tsv$XML) %in% xmlfiles & !tsv$Checked, na.rm = TRUE)) {
    cat("\n\tHowever, the files \n")
    cat(paste(tsv$XML[basename(tsv$XML) %in% xmlfiles & !tsv$Checked & !is.na(tsv$Checked)], collapse = '\n'))
    cat('\n\tare not marked in the spread sheet.\n')
  }
  
} else {
  cat("The following xml files are misnamed:\n")
  cat(paste(xmlfiles[!xmlfiles %in% basename(tsv$XML)], collapse = '\n'))
}

cat('\n')

## Krn

cat('\n')
krnfiles <- dir('Humdrum/MelodicTranscriptions/', '.*krn')

if (all(krnfiles %in% basename(tsv$KRN))) {
 cat("All xmlfiles files in 'Humdrum/MelodicTranscriptions' are marked in transcription spreadsheet.\n" ) 
 
 if (any(basename(tsv$KRN) %in% krnfiles & !tsv$Checked, na.rm = TRUE)) {
   cat("\n\tHowever, the files \n")
   cat(paste(tsv$KRN[basename(tsv$KRN) %in% krnfiles & !tsv$Checked & !is.na(tsv$Checked)], collapse = '\n'))
   cat('\n\tare not marked in the spread sheet.\n')
 }
 
} else {
  cat("The following krn files are misnamed:\n")
    cat(paste(krnfiles[!krnfiles %in% basename(tsv$KRN)], collapse = '\n'))
}

cat('\n')





