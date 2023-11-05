

readHumdrum('Data/.*hum') -> bb

bb[[,c('**kern', '**timestamp', '**harmony')]] -> bb

bb |> 
  timeline(Exclusive = ifelse(Exclusive == 'harmony', 'harm', Exclusive)) |> 
  mutate(Timeline = ifelse(grepl('q', Token), NA, Timeline)) -> bb # make gracenotes NA

bb |> group_by(Filename, Record) |> summarize(N=length(unique(Timeline))) -> k # check if there is a unique timeline value per record

bb |> filter(Exclusive == 'kern' | Exclusive == 'timestamp') |> removeEmptySpines() -> bb


bb <-cleave(bb, Spine = 1:2)


interp <- function(start, end, time) {
  if (is.na(time[1]) || is.na(tail(time, 1))) {
    print("NA")
    return(c(start, rep(NA, length(time) -1)))
  }
  browser()
  time <- time - min(time)
  prop <- time / max(time)
  
  head(start + (prop * (end - start)), -1)
  
  
}


bb[1] |> group_by(Filename) |>
  within(NewTs = {
    browser()
    ts <- which(Spine2 != '.')
    ts <- ts[!ts %in% (ts + 1)]
    for (open in ts) {
      close <- which(Spine2 != '.' & seq_along(Spine2) > open)[1]
      interp(Spine2[open], Spine2[close], Timeline[open:close]) 
    }
    
  })

bb |> select(Token) |> timeline() -> bb


ts <- c(11.076, 12.504, 13.931)

ts - min(ts)


