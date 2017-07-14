pedVals <- c(0.1,1.0,5.0,10.0,40.0)
mu0 <- 4 * pi * 10^(-7)

speeds = 1 / pedVals / mu0

df = data.frame(pedVals=pedVals,speed=1/mu0/pedVals/1000)



