# Thanks Ilya Kipinis https://quantstrattrader.wordpress.com/2015/03/20/rolling-sharpe-ratios/
runCumRets <- function(R, n = 252, annualized = FALSE, scale = NA) {
  R <- na.omit(R)
  if (is.na(scale)) {
    freq = periodicity(R)
    switch(freq$scale, minute = {
      stop("Data periodicity too high")
    }, hourly = {
      stop("Data periodicity too high")
    }, daily = {
      scale = 252
    }, weekly = {
      scale = 52
    }, monthly = {
      scale = 12
    }, quarterly = {
      scale = 4
    }, yearly = {
      scale = 1
    })
  }
  cumRets <- cumprod(1+R)
  if(annualized) {
    rollingCumRets <- (cumRets/lag(cumRets, k = n))^(scale/n) - 1 
  } else {
    rollingCumRets <- cumRets/lag(cumRets, k = n) - 1
  }
  return(rollingCumRets)
}
runSharpe <- function(R, n = 252, scale = NA, volFactor = 1) {
  if (is.na(scale)) {
    freq = periodicity(R)
    switch(freq$scale, minute = {
      stop("Data periodicity too high")
    }, hourly = {
      stop("Data periodicity too high")
    }, daily = {
      scale = 252
    }, weekly = {
      scale = 52
    }, monthly = {
      scale = 12
    }, quarterly = {
      scale = 4
    }, yearly = {
      scale = 1
    })
  }
  rollingAnnRets <- runCumRets(R, n = n, annualized = TRUE)
  rollingAnnSD <- sapply(R, runSD, n = n)*sqrt(scale)
  rollingSharpe <- rollingAnnRets/rollingAnnSD ^ volFactor
  return(rollingSharpe)
}

plotRunSharpe <- function(R, n = 252, ...) {
  sharpes <- runSharpe(R = R, n = n)
  sharpes <- sharpes[!is.na(sharpes[,1]),]
  chart.TimeSeries(sharpes,  main=paste("Rolling", n, "period Sharpe Ratio"),
                   date.format="%Y-%m", yaxis=TRUE, ylab="Sharpe Ratio", auto.grid=TRUE, ...)
  #meltedSharpes <- do.call(c, data.frame(sharpes))
  # axisLabels <- pretty(meltedSharpes, n = 10)
  # axisLabels <- unique(round(axisLabels, 1))
  # axisLabels <- axisLabels[axisLabels > min(axisLabels) & axisLabels < max(axisLabels)]
  # axis(side=2, at=axisLabels, label=axisLabels, las=1)
}