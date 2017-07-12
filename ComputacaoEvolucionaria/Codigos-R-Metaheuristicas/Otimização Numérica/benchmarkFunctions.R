suppressMessages( library(hydroPSO) )
library(compiler)

## Função de Bohachevsky 1
# x[1] e x[2] devem pertencer ao intervalo [-50,50]
# Valor mínimo é 0
bohachevsky_1 <- cmpfun( function( x ){
  x[1]^2 + 2*x[2]^2 - 0.3*cos(3*pi*x[1]) - 0.4*cos(4*pi*x[2]) + 0.7    
} )

## Função de Colville:
# x[1], x[2], x[3], x[4] devem pertencer ao intervalo [-10,10]
# Valor mínimo é 0
colville <- cmpfun( function( x ){
  100*(x[2] - x[1]^2)^2 + (1 - x[1])^2 + (1 - x[3])^2 + 90*(x[4] - x[3]^2)^2 +
    10.1*( (x[2] - 1)^2 + (x[4] - 1)^2 ) +
    19.8*(x[2] - 1)*(x[4] - 1)
} )

benchmarkFunctions <- list( fn=c( bohachevsky_1),
                            name=c( "Bohachevsky 1"),
                            dim=c( 2),
                            lower=c( -50),
                            upper=c( 50),
                            best=list(c(0,0,0))
)