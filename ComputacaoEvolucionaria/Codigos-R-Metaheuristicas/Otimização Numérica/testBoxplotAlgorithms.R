# Carrega os scripts necessários
library(reshape2)
library(ggplot2)
source("../..//Common/figuresFunctions.R")
source("./benchmarkFunctions.R")
source("../Algoritmos/ils.R")
source("../Algoritmos/sa.R")
source("../Algoritmos/hs.R")
source("../Algoritmos/ga.R")
source("../Algoritmos/de.R")
source("../Algoritmos/cs.R")
source("../Algoritmos/pso.R")
source("../Algoritmos/fa.R")
source("../Algoritmos/abc.R")
source("../Algoritmos/ffa.R")

# Métodos de otimização
optimizationAlgorithm <- vector("list", 10)
optimizationAlgorithm[[1]] <- list( fn=sa, name="SA", numIter=20000 )
optimizationAlgorithm[[2]] <- list( fn=hs, name="HS", numIter=20000 )
optimizationAlgorithm[[3]] <- list( fn=ga, name="GA", numIter=1000 )
optimizationAlgorithm[[4]] <- list( fn=de, name="DE", numIter=1000 )
optimizationAlgorithm[[5]] <- list( fn=cs, name="CS", numIter=1000 )
optimizationAlgorithm[[6]] <- list( fn=pso, name="PSO-G", numIter=1000 )
optimizationAlgorithm[[7]] <- list( fn=pso, name="PSO-L", numIter=1000 )
optimizationAlgorithm[[8]] <- list( fn=fa, name="FA", numIter=1000 )
optimizationAlgorithm[[9]] <- list( fn=abc, name="ABC", numIter=1000 )
optimizationAlgorithm[[10]] <- list( fn=ffa, name="FFA", numIter=1000 )
algorithmsNames <- sapply( optimizationAlgorithm, function(l) l$name )

# Funções a serem otimizadas
objFunctions <- benchmarkFunctions
for( i in 1:length(objFunctions$dim) ){
  if( objFunctions$name[i] != "Colville" )
  objFunctions$dim[i] <- 30
}

maxRepet <- 20
res <- list()
for( i in 1:length(objFunctions$fn) ){
# for( i in 1:1 ){
  
  resProblem <- matrix(0, nrow=length(optimizationAlgorithm), ncol=maxRepet)
  for( j in 1:length(optimizationAlgorithm) ){
    
    resRepet <- rep(0, maxRepet) 
    for( k in 1:maxRepet ){      
      ob <- optimizationAlgorithm[[j]]$fn( objFunctions$dim[i], objFunctions$fn[[i]], numIter=optimizationAlgorithm[[j]]$numIter,
                                      lower=objFunctions$lower[i], upper=objFunctions$upper[i], restartCount=4000,
                                      crossOverRate=0.9, mutationRate=0.1, ringTopology=optimizationAlgorithm[[j]]$name=="PSO-L",
                                      verbose=FALSE, history=FALSE )      
      resRepet[k] <- ob$fsol
    }
    
    resProblem[j,] <- resRepet
    print(paste("Função", objFunctions$name[i], "via", optimizationAlgorithm[[j]]$name, "=", mean(resProblem[j,])), quote=FALSE)
  }
  res[[objFunctions$name[i]]] <- data.frame( t(resProblem), row.names=1:maxRepet )
  names( res[[objFunctions$name[i]]] ) <- algorithmsNames
}

# Parâmetros para os gráficos
theme_set( theme_gray( base_size = 25 ) ) 
theme_update( axis.title.y=element_text( angle=90, vjust=0.3 ),
              axis.title.x=element_text( vjust=0.3 ) )

countBest <- rep( 0, length(algorithmsNames) )
for( i in 1:length(res) ){
  df <- melt( res[[i]], value.name="value", variable.name=c("algorithm") )
  meanValues <- colMeans(res[[i]])
  meanValues <- meanValues[order(meanValues)]
  countBest <- countBest + sapply( algorithmsNames, function(n) which( names(meanValues) == n ) )
  df$algorithm <- factor( df$algorithm, levels=names(meanValues), ordered=TRUE )
  g <- ggplot( data=df, aes(algorithm, value)) + geom_boxplot( size=1 ) +
    geom_line( data=data.frame( x=1:length(meanValues), y=meanValues ), aes( x=x, y=y ), size=1, col="red" ) + 
    xlab("Algoritmo") + ylab("Função objetivo") + theme(legend.position="none") +
    ggtitle(paste( "Função", objFunctions$name[i] ))
  saveFigure(g, figName=paste("Boxplot -", objFunctions$name[i]))
}

countBest <- countBest[ order(countBest) ]
g <- ggplot( data=data.frame( x=1:length(countBest), y=countBest ), aes(x=x,y=y) ) + geom_line(size=1) + geom_point(size=3) +
  scale_x_continuous(breaks=1:length(countBest), labels=names(countBest)) + xlab("Algoritmos") + ylab("Soma dos rankings")
saveFigure(g, figName="Soma dos rankings")

save( res, file="results.dat" )

