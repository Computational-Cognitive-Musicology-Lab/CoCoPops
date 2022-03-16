# library(humdrumR)
readHumdrum('~/Bridge/Research/Data/CoCoPops/RollingStoneCorpus/Humdrum/Sly.*hum') -> rs


# rs %hum<% c(~unique(data.frame(Key, KeySignature, Sig2= signature(Key),File, COC, OTL)), where ~ Spine == 3,by ~ File) -> keys


rs$Token %hum>% c(~semit(Token, memoize=FALSE, parse(implicitSpecies=TRUE)), where ~ Spine == 3, by ~ File) -> rs$Semit

octaves <- rs$Token %hum<% c(by ~ File,  recordtypes ~'L',
                             ~{
                                 oct <- as.numeric(gsub('.*=', '', grep('OCT', Token[Type =='L'], value = TRUE))) - 4
                                 if(length(oct) > 0) data.frame(Oct=oct, file=File[1]) else c()
                                 })

fixoct <- c(where ~ Spine == 3, by ~ File, 
            do ~ {
                if (!File[1] %in% octaves$file) {
                    b <- Semit
                } else {
                    oct <- octaves[File[1] == file, Oct]
                    first <- Semit[!is.na(Semit)][1]
                    offset <- -(first - (first %% 12)) + 12 * oct
                    b <- Semit + offset
                }
                b
                
            }) 

rs$Token %hum>% fixoct -> rs$Semit2

rs$Token %hum>% c(where ~ Spine == 3, do~delta(Semit2), by ~ File) -> rs$DSemit2


rs$Token %hum>% c(where ~ Spine == 3, do~delta(tonalInterval(Token, memoize=FALSE, implicitSpecies=TRUE)@Fifth + diatonicSet(Key)@Root), by ~ File) -> rs$DFifth

rs$Token %hum>% c(where ~ Spine == 3, do ~ sigma(ifelse(DFifth == -6 & seq_along(DFifth) > 1 & (DSemit2 %% 12) == 6, DSemit2 + 12, DSemit2)), by ~ File) -> rs$Semit3


rs %hum<% c(by ~ File, ~mean(Semit3)) |> sort() |> plot()


rs[126] %humT% (do ~ plot(Semit3 ~ Record, xlim = c(0,680),
                          ylim=c(-24,24), main = OTL[1]))

for (i in c(-12,-5,0,7,12,19)) abline(i,0, lty='dashed')

rs %hum<% c(by ~ File, ~data.frame(File = File[1], Ran = diff(range(Semit3)))) -> ranges
setorder(ranges,Ran)


