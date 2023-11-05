library(humdrumR)
setwd('~/Bridge/Research/Data/CoCoPops/Billboard/')

readHumdrum('Data/.*hum') -> bb

bb[[,c('**kern', '**timestamp', '**harmony')]] -> bb

bb |> 
  timeline(Exclusive = ifelse(Exclusive == 'harmony', 'harm', Exclusive)) |> 
  mutate(Timeline = ifelse(grepl('[qQ]', Token), NA, Timeline)) -> bb # make gracenotes NA

#bb |> group_by(Filename, Record) |> summarize(N=length(unique(Timeline))) -> k # check if there is a unique timeline value per record

bb |>  select(Timeline, Token) |>
  group_by(Filename, Record) |> 
  within(Beat = unique(Timeline[!is.na(Timeline)]), 
         Stamp = as.numeric(Token[Exclusive == 'timestamp']), dataTypes = 'Dd') -> time

time |> ungroup() |> index2( , 1) -> time

time |> select(Stamp) |>
  within(NextStamp = Stamp[lag = -1],
         NextBeat = Beat[lag = -1]) -> time

time |> 
  select(Beat, Stamp) |> 
  group_by(File) |> 
  within(Spans = cumsum(!is.na(Stamp))) |>
  within(SegLen = {
    rle <- rle(c(Spans))
    rep(rle$lengths, rle$lengths)
  }) -> time


interpolate <- function(beats, nextbeat, start, end) {
  nextbeat <- nextbeat - min(beats)
  beats <- beats - min(beats)
  beats <- beats / nextbeat
  
  start + (beats * (end - start))
  
}


time |> group_by(File, Spans) |>
  within(NewTime = ifelse(SegLen > 1, interpolate(Beat, NextBeat[1], Stamp[1], NextStamp[1]), Stamp)) -> time

time |> ungroup() |> group_by(File) |> select(Beat) |> with(Record[which(duplicated(Beat))[1]])
# time |> ungroup() |> group_by(File) |> summarize(all(diff(NewTime) > 0))



