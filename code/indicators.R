add.indicator(strategy.st, name='EntrySignal',
              arguments = list(
                dat=quote(mktdata),
                threshold = .threshold
              ),
              label="EntrySignal"
)
# Fast EMA
add.indicator(strategy.st, name = "EMA",
              arguments = list(
                x = quote(Cl(mktdata)[,1]),
                n = fastEMA_n
              ),
              label="fastEMA"
)
# Slow EMA 
add.indicator(strategy.st, name="EMA",
              arguments = list(
                x = quote(Cl(mktdata)[,1]),
                n = slowEMA_n
              ),
              label="slowEMA"
)
add.indicator(strategy.st, name="EMA",
              arguments = list(
                x = quote(Cl(mktdata)[,1] + .threshold),
                n = slowEMA_n
              ),
              label="slowEMAplus"
)
add.indicator(strategy.st, name="EMA",
              arguments = list(
                x = quote(Cl(mktdata)[,1] - .threshold),
                n = slowEMA_n
              ),
              label="slowEMAminus"
)
# Exit level -- SMA 60
add.indicator(strategy.st, name="SMA",
              arguments = list(
                x = quote(Cl(mktdata)[,1]),
                n = 60
              ),
              label="sma60"
)
add.indicator(strategy.st, name="SMA",
              arguments = list(
                x = quote(Cl(mktdata)[,1] + .threshold),
                n = 60
              ),
              label="sma60plus"
)

add.indicator(strategy.st, name="SMA",
              arguments = list(
                x = quote(Cl(mktdata)[,1] - .threshold),
                n = 60
              ),
              label="sma60minus"
)

