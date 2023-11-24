library(data.table)
library(humdrumR)



bb <- readHumdrum('~/Bridge/Research/Data/CoCoPops/Billboard/Data/.*hum')

bb |> filter(Exclusive == 'harmony') |> harm(parseArgs = list(augment = 'A', diminish = 'd'), inPlace = TRUE) |> unfilter(complement = 'Token') -> bbharm

bbharm |> filter(Exclusive == 'harmony') |> 
  count(Harm=gsub('^[1-9][0-9]*\\.*|[0-9]*%[0-9]*', '', gsub(';', '', Harm)), 
        Harmony = gsub('^[1-9][0-9]*\\.*|[0-9]*%[0-9]*', '', gsub(';', '', Token)), 
        Key = Key) -> checktab


as.data.table.count.frame(checktab) -> checktab

bb |> within(Harm2 <- {
   inversion <- str_extract(Token[Exclusive == 'harte'], '/.*') |> str_extract('[1-7]') |> chartr(old = '1234567', new = 'aebfcgd')
   Harm[Exclusive == 'harmony'] <- paste0(Harm[Exclusive == 'harmony'], inversion)
   Harm
   }
  )
