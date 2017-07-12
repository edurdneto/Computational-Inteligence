library(cluster)
library(readMLData)
library(ggplot2)
library(animation)
library(compiler)
source("../Algoritmos/ils.R")
source("../Algoritmos/sa.R")
source("../Algoritmos/hs.R")
source("../Algoritmos/ga.R")
source("../Algoritmos/de.R")
source("../Algoritmos/cs.R")
source("../Algoritmos/pso.R")
source("../Algoritmos/fa.R")
source("../Algoritmos/abc.R")

flagVideo <- FALSE
# optimizationAlgorithm <- list( fn=pso, name="PSO", numIter=50 )
optimizationAlgorithm <- list( fn=abc, name="ABC", numIter=500 )
# optimizationAlgorithm <- list( fn=fa, name="FA", numIter=50 )
# optimizationAlgorithm <- list( fn=de, name="DE", numIter=50 )
# optimizationAlgorithm <- list( fn=ga, name="GA", numIter=50 )
# optimizationAlgorithm <- list( fn=cs, name="CS", numIter=50 )
# optimizationAlgorithm <- list( fn=sa, name="SA", numIter=2500 )

# Dados para teste
# data <- as.matrix( iris[,1:4] ); k <- 3
data <- as.matrix( iris[,3:4] ); k <- 3
# data <- as.matrix( ruspini ); k <- 4
# data <- as.matrix(read.table("../../../../R//UCI_ML_DataFolders/glass//glass.data", sep=","))[,2:10]; k=6
# data <- as.matrix(read.table("../../../../R//UCI_ML_DataFolders/breast-cancer-wisconsin/breast-cancer-wisconsin.data", sep=","))[,2:10]; k=2
# data <- as.matrix(read.table("../../../../R//UCI_ML_DataFolders/vowel-indian/vowel-indian.data"))[,2:4]; k=6

d <- ncol(data)

set.seed(123)

# Parâmetros para os gráficos
theme_set( theme_gray( base_size = 20 ) ) 
theme_update( axis.title.y=element_text( angle=90, vjust=0.3 ),
              axis.title.x=element_text( vjust=0.3 ) )

extractCentr <- cmpfun( function( x ){
  k <- length(x) / d    
  centrMatrix <- matrix( 0, k, d)
  for( j in 1:k ){
    centrMatrix[j,] <- x[((j-1)*d+1):(j*d)]
  }
  centrMatrix
} )

findCentr <- cmpfun( function( data, centrMatrix ){
  apply( apply( centrMatrix, 1, function(centr) apply( data, 1, function(p) sum( (p - centr)^2 ) ) ), 1, which.min )
} )

calcTRW <- cmpfun( function( x ){
  centrMatrix <- extractCentr(x)
  clusterIndex <- findCentr( data, centrMatrix )
  wMatrix <- matrix(0, nrow=d, ncol=ncol(data))
  for( i in 1:nrow(centrMatrix) ){
    dataK <- data[clusterIndex == i, , drop=FALSE]
    nK <- nrow( dataK )
    if( nK > 0 ){
      xK <- colMeans( dataK )
      for( j in 1:nK ){        
        p <- dataK[j,,drop=FALSE] - xK
        wMatrix <- wMatrix + t(p) %*% p
      }  
    } #else{
#       return( 10^8 )
#     }
  }
  sum(diag(wMatrix))
} )

# Otimiza pelo algoritmo escolhido
print(paste("Otimizando clusters via", optimizationAlgorithm$name), quote=FALSE)
lower <- apply( data, 2, min ); lower <- 0.6*lower
upper <- apply( data, 2, max ); upper <- 1.4*upper
ob <- optimizationAlgorithm$fn( dim=k*d, fn=calcTRW, numIter=optimizationAlgorithm$numIter, ringTopology=TRUE,
                                lower=rep( lower, k), upper=rep( upper, k) )

centrMatrix <- extractCentr( ob$sol )   
clusterIndex <- findCentr( data, centrMatrix )

if( is.list( ob$fsolHistory ) ){
  df <- data.frame( iterations=1:optimizationAlgorithm$numIter, evaluations=ob$bestfSolHistory )  
} else{
  df <- data.frame( iterations=1:optimizationAlgorithm$numIter, evaluations=ob$fsolHistory )  
}  
g <- ggplot( df, aes( x=iterations, y=evaluations ) ) +
  geom_line( size=I(1.5) ) +
  ggtitle( paste( "Otimização via", optimizationAlgorithm$name) ) +
  xlab( "Iterações" ) + 
  ylab( "TRW" )    
print( g )
print("", quote=FALSE)

if(d == 2){
  df <- data.frame( x=data[,1], y=data[,2] )
  dfCentr <- data.frame( x=centrMatrix[,1], y=centrMatrix[,2] )
  g2 <- ggplot() +
    geom_point( aes(x,y), df, size=3, shape=8, colour=factor(clusterIndex) ) + 
    geom_point( aes(x,y), dfCentr, size=6, colour=factor(1:k) ) + xlab("") + ylab("")
  print(g2)
  
  if( flagVideo ){
    while(dev.cur() != 1){dev.off()}    
    graphics.off()
    ani.options( outdir=getwd(), ani.width=600, ani.height=600, interval=20/length(ob$solHistory) )
    saveVideo( 
      for( i in seq(1, optimizationAlgorithm$numIter ) ){         
        centrMatrix <- extractCentr( ob$bestSolHistory[[i]] )
        clusterIndex <- findCentr( data, centrMatrix )   
        plot( data[,1], data[,2], pch=19, cex=0.8, col=clusterIndex,
              xlim=c(lower[1], upper[1]), ylim=c(lower[2], upper[2]), xlab="", ylab="" )      
        title( paste( "Evolução da busca por", optimizationAlgorithm$name, "- Iteração ", i ) )
        points( centrMatrix[,1], centrMatrix[,2], pch=19, cex=1.3, col=1:nrow(centrMatrix) )
       
        for( j in 1:nrow(ob$solHistory[[i]]) ){
          x <- ob$solHistory[[i]][j,]  
          centrMatrix <- extractCentr( x )  
          points( centrMatrix[,1], centrMatrix[,2], pch=19, cex=.4 )        
        }
      }, video.name=paste( optimizationAlgorithm$name, ".mp4", sep=""), clean=TRUE )
  }
}


