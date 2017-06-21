library(quantstrat)
library(IKTrading) # devtools::install_github('IlyaKipnis/IKTrading')
library(xts)
library(readxl)
library(xlsx)
source('code/RollingSharpeFunctions.R')
source('code/EntrySignals.R')
Sys.setenv(TZ="UTC")
filename <- 'data/G10_240.xlsx'
sheets <- excel_sheets(filename)
meta <- data.frame(file=filename,
                   sheet=2:9,
                   curr=sheets[2:9],
                   pipvalue=c(rep(1e4, 5), 1e2, 1e4, 1e4),
                   stringsAsFactors=FALSE)


# This loop will call the function in runStrategy.R and save stats about the backtests
for(this.row in 1:nrow(meta)) {
  this.meta <- meta[this.row, ]
  dat <- read_excel(this.meta$file, sheet=this.meta$sheet, skip=2)
  names(dat)[names(dat)=='LAST_PRICE'] <- 'CLOSE'
  dat <- xts(OHLC(dat), order.by=dat$Date)
  curr <- this.meta$curr
  pipvalue <- this.meta$pipvalue
  
  source('code/RunStrategy.R')
}

ret <- xts(0, order.by=xts::first(index(dat))-86400)
for(this.curr in meta$curr) {
  file <- paste0('objs/', this.curr, '_stats.Rdata')
  load(file)
  file_out <- paste0('reports/', this.curr, '_output.xlsx')
  write.xlsx2(orderbook, file=file_out, sheetName='OrderBook')
  write.xlsx2(tradeStats_trades, file=file_out, sheetName='TradeStats', append=TRUE)
  returns <- cbind(portRet, cumsum(portRet))
  names(returns) <- c('Returns', 'Cumulative Returns')
  write.xlsx2(returns, file=file_out, sheetName='PnL_Returns', append=TRUE)
  PnL <- cbind(portRet*initEq, cumsum(portRet*initEq))
  names(PnL) <- c('PnL_USD', 'Cumulative_PnL_USD')
  write.xlsx2(PnL, file=file_out, sheetName='PnL_USD', append=TRUE)

  # Overall returns
  ret <- cbind.xts(ret, portRet)
}
ret <- ret[-1, -1] 
names(ret) <- substr(names(ret), 1, 6)
ret_all <- xts(rowSums(ret, na.rm=TRUE), order.by=index(ret))

maxDD <- round(100 * maxDrawdown(ret), 2)
maxDD_all <- round(100 * maxDrawdown(ret_all), 2)
pdf(file='figs/Whole_Portfolio.pdf', width=6, height=4)
  plot(100 * cumsum(ret_all[,1]), 
       main=paste0('All Currencies -- % Return | Max Drawdown: ', maxDD_all, '%'))
  plotRunSharpe(ret_all[,1], n=30)
  for(this.curr in meta$curr) {
    print(plot(100 * cumsum(ret[ ,this.curr]),
         main=paste0(this.curr, ' -- % Return | Max Drawdown: ', maxDD[, this.curr], '%')))
  }
dev.off()
