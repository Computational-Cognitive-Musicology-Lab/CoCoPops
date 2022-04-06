# library(humdrumR)
readHumdrum('~/Bridge/Research/Data/CoCoPops/RollingStoneCorpus/Humdrum/.*hum') -> rs


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


rs$Token %hum>% c(where ~ Spine == 3, do~delta(tonalInterval(Token, memoize=FALSE, Key=diatonicSet(Key), implicitSpecies=TRUE)@Fifth + diatonicSet(Key)@Root), by ~ File) -> rs$DFifth

rs$Token %hum>% c(where ~ Spine == 3, do ~ sigma(ifelse(DFifth == -6 & seq_along(DFifth) > 1 & (DSemit2 %% 12) == 6, DSemit2 + 12, DSemit2)), by ~ File) -> rs$Semit3


if (FALSE) {
    


rs[88] %humT% (do ~ {
    plot(Semit3 ~ Record, col ='blue', type='o',# xlim = c(1400,1800),
                          ylim=c(-48,24), main = OTL[1])
    points(Semit2 ~ Record, col ='red')
    # text(sigma(DFifth)~Record, labels=sigma(DFifth),col='green',pch=16,cex=.5)
    })

for (i in c(-12,-5,0,7,12,19)) abline(i,0, lty='dashed')



rs %hum<% c(by ~ File, ~data.frame(Mean=mean(Semit3), Range = diff(range(Semit3)), 
                                   Min = min(Semit3), Max = max(Semit3), MaxInterval = max(abs(delta(Semit3))),
                                   MeanInterval = mean(delta(Semit3)), MeanAbsInt = mean(abs(delta(Semit3))),
                                   File= File[1], OTL=OTL[1],COC=COC[1])) -> ms
setorder(ms,  Mean, Max, Min)

ms[,plot(Mean,type='l', lwd=2, ylim = c(-30,30))]
ms[,points(Min,type='l')]
ms[,points(Max, type='l')]


setorder(ms, MaxInterval)
ms[ , plot(MaxInterval)]
}

## make kern
rs$Token %hum>% c(~kern(Token, memoize=FALSE, parse(implicitSpecies=TRUE)), where ~ Spine == 3, by ~ File) -> rs$Kern1

rs %hum>% c(~Kern1 + (octave * ((Semit3-Semit) / 12)) , where ~ Spine == 3, elsedo ~ Token) -> rs$Kern


rs$Token %hum>% c(do~Kern, ordo ~ Token, where ~ Spine == 3,recordtypes ~ 'GLIMDd') -> rs$Output

writeHumdrum(rs, affix=)
