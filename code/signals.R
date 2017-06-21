# Buy / Sell Signals
add.signal(strategy.st, name="sigThreshold",
           arguments=list(column="EntrySignal",
                          threshold=0,
                          relationship='gt'),
           label="BuySignal")
add.signal(strategy.st, name="sigThreshold",
           arguments=list(column="EntrySignal",
                          threshold=0,
                          relationship='lt'),
           label="SellSignal")



# Close crosses below EMA 40
add.signal(strategy.st, name='sigCrossover',
           arguments = list(
             columns=c('CLOSE', 'slowEMA'),
             relationship='lt'
           ),
           label='crossBelowSlowEMA')

# Close crosses above EMA 40
add.signal(strategy.st, name='sigCrossover',
           arguments = list(
             columns=c('CLOSE', 'slowEMA'),
             relationship='gt'
           ),
           label='crossAboveSlowEMA')


# Signal to Exit the whol position
add.signal(strategy.st, name='sigComparison',
           arguments=list(
             columns=c('CLOSE','sma60plus'),
             relationship='gte'
           ),
           label='isAboveThreshExit')

add.signal(strategy.st, name='sigComparison',
           arguments=list(
             columns=c('CLOSE','sma60minus'),
             relationship='lte'
           ),
           label='isBelowThreshExit')


