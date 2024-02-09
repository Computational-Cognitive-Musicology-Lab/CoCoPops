library(data.table)
library(humdrumR)
library(stringr)


bb <- readHumdrum('~/Bridge/Research/Data/CoCoPops/Billboard/Data/.*hum|.*harm')


bb |> 
   filter(Exclusive == 'harmony') |> 
   harm(parseArgs = list(augment = 'A', diminish = 'd'), inPlace = TRUE, natural = '#', implicitSpecies = FALSE) |>  #implicitSpecies =TRUE, natural = '#'
   unfilter(complement = 'Token') -> bbharm

bbharm |> filter(Exclusive == 'harmony') |> 
  within( Harm=gsub('^[1-9][0-9]*\\.*|[0-9]*%[0-9]*', '', gsub(';', '', Harm)), 
        Harmony = gsub('^[1-9][0-9]*\\.*|[0-9]*%[0-9]*', '', gsub(';', '', Token))) |> 
   select(Filename, Harm, Harmony, Key) |> 
   pull_data.table() |> 
   unique() -> checktab

checktab[, Root := tertianSet(Harm)@Root]
setorder(checktab, -Root)

checktab <- checktab[!Filename %in% c("CheapTrick_DreamPolice_1979.hum",
                                      "PeachesAndHerb_ShakeYourGrooveThing_1978.harm",
                                      "LesleyGore_CaliforniaNights_1967.varms.hum",
                                      "RitaCoolidge_TheWayYouDoTheThingsYouDo_1978.harm",
                                      "StevieWonder_DoIDo_1982.harm",
                                      "TheElectricPrunes_IHadTooMuchToDream_1967.hum",
                                      "DavidBowie_GoldenYears_1976.harm",
                                      "FreddieJackson_HaveYouEverLovedSomebody_1987.harm",
                                      "BlueCheer_SummertimeBlues_1968.harm",
                                      "TheRitchieFamily_TheBestDiscoInTown_1976.harm",
                                      " NatalieCole_Unforgettable_1991.harm",
                                      "TheSopwithCamel_HelloHello_1967.harm",
                                      "ToddRundgren_ADreamGoesOnForever_1974.harm",
                                      "WildCherry_PlayThatFunkyMusic_1976.harm"
                                      
                                      )]
checktab[!is.na(Root)][1:40]

bbharm |> within(Harm2 <- {
   inversion <- str_extract(Token[Exclusive == 'harte'], '/.*') |> str_extract('[1-7]') |> chartr(old = '1234567', new = 'aebfcgd')
   
   harm <- Exclusive == 'harmony'
   Harm[harm] <- paste0(Harm[harm], ifelse(is.na(inversion), '', inversion))
   Harm
   }
  ) -> bbharm


writeHumdrum(bbharm, prefix = 'harm_')


bb2 <- readHumdrum('~/Bridge/Research/Data/CoCoPops/Billboard/Data/^harm.*hum')