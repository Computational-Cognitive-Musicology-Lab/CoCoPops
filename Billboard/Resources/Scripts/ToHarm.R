library(data.table)
library(humdrumR)



bb <- readHumdrum('~/Bridge/Research/Data/CoCoPops/Billboard/Data/.*hum')

bb |> filter(Exclusive == 'harmony') |> harm(parseArgs = list(augment = 'A', diminish = 'd')) |> unfilter(complement = 'Token') -> bb

bb |> filter(Exclusive == 'harmony') |> 
  count(Harm=gsub('^[1-9][0-9]*\\.*|[0-9]*%[0-9]*', '', gsub(';', '', Harm)), 
        Harmony = gsub('^[1-9][0-9]*\\.*|[0-9]*%[0-9]*', '', gsub(';', '', Token)), 
        Key = Key) -> checktab


as.data.table.count.frame(checktab) -> checktab

# F G
