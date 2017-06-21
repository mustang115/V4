EntrySignal <- function(dat, threshold){
  # Get differences btween EMAs
  cross <- EMA(Cl(dat), 20) - EMA(Cl(dat), 40)
  names(cross) <- 'cross'
  # sign tells us whether it's pos or neg, diff subtract the prev row from the current row
  # do this so we can see when there's a switch from pos -> neg or vice versa.
  cross$isCross <- sign(diff(sign(cross$cross)))
  # This part will convert 0 to NA then fill it with the prev cross symbol 1 or -1
  cross$isCrossFill <- cross$isCross
  cross$isCrossFill[cross$isCrossFill==0] <- NA
  cross$isCrossFill <- na.locf(cross$isCrossFill)
  # Our buy signal
  cross$BuySignal <- cross$cross > threshold & cross$isCrossFill==1
  # Keep only the first in a series of signals
  cross$BuySignal <- diff(cross$BuySignal) > 0
  # same for sell
  cross$SellSignal <- cross$cross < -threshold & cross$isCrossFill==-1
  cross$SellSignal <- (diff(cross$SellSignal) > 0) * -1
  
  # Merge these 2 columns into 1 signal with 1 and -1
  signal <- cross$BuySignal + cross$SellSignal
  colnames(signal) <- 'EntrySignal'
  return(signal)
}