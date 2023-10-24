filename <- commandArgs(trailingOnly = TRUE)[1]

xml <- readLines(filename)

divs <- c()

m1s <- grep('measure number="1"', xml)

measurerest<- '<note>
        <rest/>
        <duration>xxxx</duration>
        <voice>1</voice>
        <notations>
          <fermata type="upright"/>
          </notations>
        </note>'
origlen <- length(xml)
n <- 1

while (n <= length(m1s)) {
  i <- m1s[n]

  closes <- grep('</attributes', xml)
  close <- closes[closes > i][1]

  m0 <- xml[i:close]
  m0 <- c('<measure number="0" implicit="yes">', 
          m0[-1],
          measurerest,
          '</measure>')

  dur <- as.numeric(gsub('[^0-9]', '', grep('divisions', m0, value= TRUE))) * 4
  divs <- c(divs, dur)
  gsub('xxxx', dur, m0) -> m0
   


  xml <- xml[c(1:i, (close + 1):length(xml))]

  xml <- append(xml, m0, after = (i - 1))





  
  m1s <- m1s + (length(xml) - origlen)
  origlen <- length(xml)
n <- n + 1

}

#################### two measures at end

pends <- grep('</part>', xml)


n <- 1

while (n <= length(pends)) {
   i <- pends[n]

   mx <- c('<measure number="X1" implicit="yes">',
           measurerest,
           '</measure>')          
   mx <- gsub('xxxx', divs[n], mx)

  mx <- c(mx, gsub('X1', 'X2', mx))

  xml <- append(xml, mx, after = i -1)

## remove weighted barline in last measure

   open <- grep('<barline', xml)
   open <- tail(open[open < i], 1)
   close <- grep('</barline>', xml)
   close <- tail(close[close < i], 1)

   xml <- xml[c(1:(open -1), (close +1):length(xml))]

   
  pends <- pends + (length(xml) - origlen)
  origlen <- length(xml)
  n <- n + 1


}
writeLines(xml, paste0(filename))
