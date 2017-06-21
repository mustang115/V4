#____________________________
# BUY RULES
#____________________________
# Enter Long -- open 2 positions (there's got to be a better way, but this is driving me nutty)
add.rule(strategy.st, name='ruleSignal',
         arguments=list(sigcol='BuySignal' , sigval=TRUE,
                        orderside='long' ,
                        ordertype='market',
                        orderqty=+.orderqty,
                        TxnFees=.txnfees,
                        replace=TRUE
         ),
         type='enter',
         label='EnterLong'
)

# Exit the rest if below SMA60
add.rule(strategy.st, name='ruleSignal',
         arguments=list(sigcol='isBelowThreshExit',
                        sigval=TRUE,
                        orderside='long',
                        ordertype='market',
                        orderqty=quote(
                          ifelse(getPosQty('forex', symbol, timestamp) > 0,
                                 'all',
                                 0)
                        ),
                        TxnFees=0,
                        orderset='closeLong',
                        replace=TRUE
         ),
         type='exit', 
         label='CloseAllLong')

# Exit half position when goes below 40 EMA
add.rule(strategy.st, name='ruleSignal',
         arguments=list(sigcol='crossBelowSlowEMA',
                        sigval=TRUE,
                        orderside='long',
                        ordertype='market',
                        orderqty=quote(
                          ifelse(getPosQty('forex', symbol, timestamp)==.orderqty,
                                 -.5*.orderqty,
                                 0)
                        ),
                        TxnFees=0,
                        orderset='closeLong',
                        replace=FALSE
         ),
         type='exit', 
         label='CloseHalfLong')

#_______________________
# Sell Rules
#_______________________

# Enter Short
add.rule(strategy.st, name='ruleSignal',
         arguments=list(sigcol='SellSignal', sigval=TRUE,
                        orderside='short',
                        ordertype='market',
                        orderqty=-.orderqty,
                        TxnFees=.txnfees,
                        replace=TRUE
         ),
         type='enter',
         label='EnterShort'
)

# Exit half position when goes above 40 EMA
add.rule(strategy.st, name='ruleSignal',
         arguments=list(sigcol='crossAboveSlowEMA',
                        sigval=TRUE,
                        orderside='short',
                        ordertype='market',
                        orderqty=quote(
                          ifelse(getPosQty('forex', symbol, timestamp)== -.orderqty,
                                 +.5*.orderqty,
                                 0)
                        ),
                        orderset='closeShort',
                        TxnFees=0,
                        replace=FALSE
         ),
         type='exit', 
         label='CloseHalfShort')
# Exit the rest if above SMA60
add.rule(strategy.st, name='ruleSignal',
         arguments=list(sigcol='isAboveThreshExit',
                        sigval=TRUE,
                        orderside='short',
                        ordertype='market',
                        orderqty=quote(
                          ifelse(getPosQty('forex', symbol, timestamp) < 0,
                                 'all',
                                 0)
                        ),
                        TxnFees=0,
                        orderset='closeShort',
                        replace=TRUE
         ),
         type='exit', 
         label='CloseAllShort')






