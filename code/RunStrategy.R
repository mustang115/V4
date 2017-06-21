

# Move our data into an object with our currencies name
assign(curr, dat, envir=.GlobalEnv)

# Split our currency into each side of the exchange rate
curr1 <- substr(curr, 1, 3)
curr2 <- substr(curr, 4, 6)

# Quantstrat stuff
currency(c(curr1, curr2))
exchange_rate(curr, tick_size=pipvalue)
#exchange_rate(currency=curr1, counter_currency=curr2,
#              tick_size=pipvalue)
# Using this we see that it reversed our currency
symbol <- curr
if(exists('portfolio.st')){
  rm.strat(portfolio.st)
  rm.strat(account.st)
}
strategy.st <- 'forex'
portfolio.st <- 'forex'
account.st <- 'forex'

# We need to adjust .orderqty, this is very unintuitive, but it's the best I could think of
if(curr1=='USD'){
  .orderqty <- 100000 / Op(dat)[[1]]
  .txnfees <- -4.5 / Op(dat)[[1]]
} else {
  .orderqty <- 100000
  .txnfees <- -4.5
}
initEq <- 1e6
.threshold <- 5 * 1/pipvalue

### blotter
initPortf(portfolio.st, symbols=symbol, currency='USD')
initAcct(account.st, portfolios=portfolio.st, currency='USD', initEq = initEq)
addPortfInstr(portfolio.st, symbol)
### quantstrat
initOrders(portfolio.st, symbol)

### define strategy
strategy(strategy.st, store=TRUE)

# Add indicators
fastEMA_n <- 20
slowEMA_n <- 40
source('code/indicators.R')

# Define signals
source('code/signals.R')

# Add Rules
source('code/rules.R')

applyStrategy(strategy.st, portfolio.st)

 indicators <- applyIndicators(strategy.st, mktdata=dat)
 signals <- applySignals(strategy.st, mktdata=indicators)

updatePortf(portfolio.st, Symbols=symbol)

orderbook <- getOrderBook(portfolio.st)[[1]][[1]]
if(curr1=='USD') {
  qty <- as.numeric(orderbook$Order.Qty)
  qty <- round(qty * Op(dat)[[1]])
  qty[orderbook$Order.Qty=='all'] <- 'all'
  orderbook$Order.Qty <- qty
  
  fees <- as.numeric(orderbook$Txn.Fees)
  fees <- fees * Op(dat)[[1]]
  orderbook$Txn.Fees <- fees
}
portRet <- PortfReturns('forex')
tradeStats_txns <- t(tradeStats(portfolio.st, symbol, use='txns'))
tradeStats_trades <- t(tradeStats(portfolio.st, symbol, use='trades'))

# Plots
drawdown <- round(100 * maxDrawdown(portRet), 2)
cumPercRet <- 100 * cumsum(portRet[,1])
title <- paste0(curr, ' -- % Return',' | Max Drawdown: ', drawdown, '%')


pdf(paste0('figs/', curr,'_chartPosn.pdf'),width=6,height=4, onefile=TRUE)
  if(NROW(tradeStats(portfolio.st, symbol, use='trades'))==0){
    plot(1:3, 1:3, type='n', xlab=NA, ylab=NA)
    text(2, 2, 'No trades made', cex=3)
  } else {
    chart.Posn(portfolio.st, symbol, Prices=dat['2017-01-12'],
               TA='add_EMA(20); add_EMA(40, col="red"); add_EMA(60, col="green")')
    print(plot(cumPercRet, main=title))
    plotRunSharpe(portRet[,1], n=30)
  }
dev.off()

save(orderbook, portRet, tradeStats_txns, tradeStats_trades,
     file=paste0('objs/', curr, '_stats.Rdata'))

rm.strat(portfolio.st)
rm.strat(account.st)
rm(list=curr)
  
