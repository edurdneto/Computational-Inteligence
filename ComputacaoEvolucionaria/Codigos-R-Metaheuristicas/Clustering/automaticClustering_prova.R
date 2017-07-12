library(cluster)
library(clusterSim)
library(ggplot2)
library(animation)
library(compiler)
source("../Algoritmos/sa.R")
source("../Algoritmos/hs.R")
source("../Algoritmos/ga.R")
source("../Algoritmos/de.R")
source("../Algoritmos/cs.R")
source("../Algoritmos/pso.R")
source("../Algoritmos/fa.R")
source("../Algoritmos/abc.R")

optimizeFlag <- TRUE
k <- 5
findK <- TRUE
kMax <- 10

extractCentr <- cmpfun( function( x ){
  if( findK ){
    activeClusterIndex <- which( x[1:kMax] > 0.5 )
    k <- length( activeClusterIndex )
  }
  centrMatrix <- matrix( 0, k, d )
  for( j in 1:k ){
    if( findK ){
      centrMatrix[j,] <- x[((activeClusterIndex[j]-1)*d+1+kMax):(activeClusterIndex[j]*d+kMax)]  
    } else{
      centrMatrix[j,] <- x[((j-1)*d+1):(j*d)]      
    }    
  }        
  centrMatrix
} )

findCentr <- cmpfun( function( data, centrMatrix ){
  apply( apply( centrMatrix, 1, function(centr) apply( data, 1, function(p) sum( (p - centr)^2 ) ) ), 1, which.min )
} )

fixSolution <- cmpfun( function( x ){
  if( findK ){
    # Verifica se há pelo menos 2 clusters ativos
    activeClusterIndex <- which( x[1:kMax] > 0.5 )
    k <- length( activeClusterIndex )  
    if( k == 0 ){
      activeClusterIndex <- sample(kMax,2) 
      x[activeClusterIndex] <- runif(2, min=0.5, max=1)
      k <- 2
    } else if( k == 1){
      activeClusterIndex <- sample((1:kMax)[-activeClusterIndex],1)
      x[activeClusterIndex] <- runif(1, min=0.5, max=1)
      k <- 2
    } 
  }
  
  # Verifica se cada cluster possui pelo menos 2 elementos
  centrMatrix <- extractCentr(x)
  clusterIndex <- findCentr( data, centrMatrix )
  
  if( sum( table(clusterIndex) < 2 ) || length(table(clusterIndex)) < k ){
    nK <- floor( nrow(data) / k )
    while( sum( table(clusterIndex) < 2 ) || length(table(clusterIndex)) < k ){
      #       randomIndex <- sample(nrow(data))
      #       for( i in 1:length(activeClusterIndex) ){
      #         x[(kMax+1+d*(activeClusterIndex[i]-1)):(kMax+d*activeClusterIndex[i])] <- colMeans( data[randomIndex[((i-1)*nK+1):(nK*i)], ,drop=FALSE] )  
      #       }  
      if( findK ){
        for( i in 1:length(activeClusterIndex) ){        
          x[(kMax+1+d*(activeClusterIndex[i]-1)):(kMax+d*activeClusterIndex[i])] <- data[ sample(nrow(data),1), ]  
        }  
      } else{
        for( i in 1:k ){        
          x[(1+d*(i-1)):(d*i)] <- data[ sample(nrow(data),1), ]  
        }    
      }
      centrMatrix <- extractCentr(x)
      clusterIndex <- findCentr( data, centrMatrix )
    }
    
    #     kMeansClusterIndex <- kmeans( data, length(activeClusterIndex) )$centers
    #     for( i in 1:length(activeClusterIndex) ){
    #       x[(kMax+1+d*(activeClusterIndex[i]-1)):(kMax+d*activeClusterIndex[i])] <- kMeansClusterIndex[i,]
    #     }  
  }
  
  x
} )

calcDB <- cmpfun( function( x=NULL, centrMatrix=NULL, centrFromData=FALSE ){
  if( is.null(centrMatrix) ){
    centrMatrix <- extractCentr(x)
  }
  clusterIndex <- findCentr( data, centrMatrix )
  k <- nrow(centrMatrix)
  
  if( centrFromData == TRUE ){
    centrMatrix <- matrix( 0, nrow=k, ncol=ncol(data) ) 
    for( i in 1:k ){
      centrMatrix[i,] <- colMeans( data[ clusterIndex == i, , drop=FALSE ] )
    }   
  }
  distClusterCentr <- as.matrix( dist( centrMatrix ) )
  
  sVector <- rep(0, k)
  for( i in 1:k ){  
    dataK <- data[ clusterIndex == i, , drop=FALSE ]
    nK <- nrow(dataK)
    centr <- centrMatrix[i,]
    for( j in 1:nK ){
      sVector[i] <- sVector[i] + sum( ( dataK[j,] - centr )^2 )
    }
    sVector[i] <- sqrt( sVector[i] / nK )
  }
  
  rVector <- rep(0, k)
  for( i in 1:k ){  
    rVector[i] <- max( (sVector[i] + sVector[-i]) / distClusterCentr[i, (1:k)[-i]] )
  }
  
  metric <- mean(rVector)
  metric
} )

calcSI <- cmpfun( function( x=NULL, centrMatrix=NULL ){
  if( is.null(centrMatrix) ){
    centrMatrix <- extractCentr(x)
  }
  k <- nrow(centrMatrix)
  clusterIndex <- findCentr( data, centrMatrix )
  
  listIndexCentr <- list()
  for( i in 1:k ){
    listIndexCentr[[i]] <- which( clusterIndex == i )
  }
  
  s <- 0
  for( i in 1:k ){  
    indexK <- listIndexCentr[[i]]
    a <- sapply( 1:length(indexK), function(j) mean(distMatrix[ indexK[j], indexK[-j] ])  )
    b <- matrix(0,  k, length(indexK))
    for( p in (1:k)[-i] ){
      b[p,] <- sapply( 1:length(indexK), function(j) mean(distMatrix[ indexK[j], listIndexCentr[[p]] ])  )  
    }    
    b <- apply( b[-i,,drop=FALSE], 2, min )
    s <- s + sum( ifelse( a < b, 1 - a/b, b/a - 1 ) )
  }
  metric <- s / nrow(data)
  -metric  
} )

plotClustering <- function( x=NULL, centrMatrix=NULL, title="" ){
  if( is.null(centrMatrix) ){
    centrMatrix <- extractCentr( x )
  }
  k <- nrow(centrMatrix)
  clusterIndex <- findCentr( data, centrMatrix )
  
  df <- data.frame( x=data[,1], y=data[,2] )
  dfCentr <- data.frame( x=centrMatrix[,1], y=centrMatrix[,2] )
  g <- ggplot() +
    geom_point( aes(x,y), df, size=2, colour=factor(clusterIndex) ) + 
    geom_point( aes(x,y), dfCentr, size=6, colour=factor(1:k) ) +
    ggtitle(title)
  g
}

fn <- calcDB
optimizationAlgorithm <- list( fn=pso, name="PSO", numIter=300 )
# optimizationAlgorithm <- list( fn=abc, name="ABC", numIter=300 )
# optimizationAlgorithm <- list( fn=fa, name="FA", numIter=50 )
# optimizationAlgorithm <- list( fn=de, name="DE", numIter=300 )
# optimizationAlgorithm <- list( fn=ga, name="GA", numIter=50 )
# optimizationAlgorithm <- list( fn=cs, name="CS", numIter=50 )
# optimizationAlgorithm <- list( fn=hs, name="HS", numIter=1000 )
# optimizationAlgorithm <- list( fn=sa, name="SA", numIter=2000 )

# Dados para teste
data <- as.matrix( read.table("./dataset1.dat") )

distMatrix <- as.matrix( dist( data ) )
d <- ncol(data)

set.seed(123)

# Parâmetros para os gráficos
theme_set( theme_gray( base_size = 20 ) ) 
theme_update( axis.title.y=element_text( angle=90, vjust=0.3 ),
              axis.title.x=element_text( vjust=0.3 ) )

# Otimiza pelo algoritmo escolhido
if( optimizeFlag ){
  print(paste("Otimizando clusters via", optimizationAlgorithm$name), quote=FALSE)
  lower <- apply( data, 2, min )
  upper <- apply( data, 2, max )
  if( findK ){
    ob <- optimizationAlgorithm$fn( dim=kMax+kMax*d, fn=fn, numIter=optimizationAlgorithm$numIter, clustering=TRUE, ringTopology=TRUE,
                                    lower=c( rep(0, kMax), rep(lower, kMax) ), upper=c( rep(1, kMax), rep( upper, kMax)) )
  } else{
    ob <- optimizationAlgorithm$fn( dim=k*d, fn=fn, numIter=optimizationAlgorithm$numIter, clustering=TRUE, ringTopology=TRUE,
                                    lower=c( rep(lower, k) ), upper=c( rep( upper, k)) )  
  }
}

if( exists( "centrMatrix" ) == FALSE ){
  centrMatrix <- extractCentr( ob$sol )
}
clusterIndex <- findCentr( data, centrMatrix )

print( paste( optimizationAlgorithm$name, "número de clusters:", nrow(centrMatrix) ), quote=FALSE )
print( sort(table(clusterIndex)) )
print( printSummary(centrMatrix) )
if( exists("ob$sol") ){
  print( paste( optimizationAlgorithm$name, "DB:", calcDB(ob$sol, centrFromData=TRUE ) ), quote=FALSE )
  print( paste( optimizationAlgorithm$name, "CS:", calcCS(ob$sol, centrFromData=TRUE) ), quote=FALSE )
  print( paste( optimizationAlgorithm$name, "Silhouette:", -calcSI(ob$sol) ), quote=FALSE )
  print( paste( optimizationAlgorithm$name, "Trace:", -calcTR(ob$sol, centrFromData=TRUE) ), quote=FALSE )
} else{
  print( paste( optimizationAlgorithm$name, "DB:", calcDB(centrMatrix=centrMatrix, centrFromData=TRUE ) ), quote=FALSE )
  print( paste( optimizationAlgorithm$name, "CS:", calcCS(centrMatrix=centrMatrix, centrFromData=TRUE) ), quote=FALSE )
  print( paste( optimizationAlgorithm$name, "Silhouette:", -calcSI(centrMatrix=centrMatrix) ), quote=FALSE )
  print( paste( optimizationAlgorithm$name, "Trace:", -calcTR(centrMatrix=centrMatrix, centrFromData=TRUE) ), quote=FALSE )  
}

if( optimizeFlag ){
  if( is.list( ob$fsolHistory ) ){
    df <- data.frame( iterations=1:optimizationAlgorithm$numIter, evaluations=ob$bestfSolHistory )  
  } else{
    df <- data.frame( iterations=1:optimizationAlgorithm$numIter, evaluations=ob$fsolHistory )  
  }  
  g <- ggplot( df, aes( x=iterations, y=evaluations ) ) +
    geom_line( size=I(1.5) ) +
    ggtitle( paste( "Otimização via", optimizationAlgorithm$name) ) +
    xlab( "Iterações" ) + 
    ylab( "Função objetivo" )    
  print( g )
  print("", quote=FALSE)
}

if(d == 2){
  print(plotClustering(ob$sol, title=paste("Clustering via", optimizationAlgorithm$name)) )
}

kMeansNumCluster <- nrow(centrMatrix)
kMeans <- kmeans( data, kMeansNumCluster )
kMeansClusterIndex <- findCentr( data, kMeans$centers )
if(d == 2){
  print(plotClustering( centrMatrix=kMeans$centers, title="Clustering via K-Means" ))
}
print( paste( "K-Means número de clusters:", kMeansNumCluster ), quote=FALSE )
print( sort(table(kMeansClusterIndex)) )
print( printSummary(centrMatrix) )
print( paste( "K-Means DB:", calcDB(centrMatrix=kMeans$centers, centrFromData=TRUE) ), quote=FALSE )
print( paste( "K-Means CS:", calcCS(centrMatrix=kMeans$centers, centrFromData=TRUE) ), quote=FALSE )
print( paste( "K-Means Silhouette:", -calcSI(centrMatrix=kMeans$centers) ), quote=FALSE )
print( paste( "K-Means Trace:", -calcTR(centrMatrix=kMeans$centers, centrFromData=TRUE) ), quote=FALSE )


