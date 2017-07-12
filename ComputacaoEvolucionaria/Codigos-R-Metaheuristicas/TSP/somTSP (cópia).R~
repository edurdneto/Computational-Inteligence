library(ggplot2)
library(animation)
library(compiler)
source("./functionsTSP.R")

set.seed(123)
numNodes <- nrow(nodes)

step_0 <- 0.5
step_f <- 0.01
step <- step_0
sigma_0 <- 0.5
sigma_f <- 0.01
sigma <- sigma_0

numIter <- 1000#10*numNodes

neurons <- matrix( runif(numNodes*2), nrow=numNodes, ncol=2 )

buildGrid <- function( numNodes ){
  ang <- 2*pi / numNodes
  grid <- matrix( 0, nrow=numNodes, ncol=2 )
  for( i in 1:numNodes ){
    grid[i,1] <- 0.5 + 0.5*cos( ang * i )
    grid[i,2] <- 0.5 + 0.5*sin( ang * i )
  }  
  grid
}

calcDist2 <- cmpfun( function( x1, x2 ){
  sum((x1 - x2)^2)  
} )

neighbourFunction <- cmpfun( function( winnerIndex, i ){
  exp( -0.5*distGrid[winnerIndex,i] / (sigma^2) )
} )

plotNeurons <- function( neurons ){
  indexClosed <- c( 1:numNodes, 1 )
  plot( nodes[,1], nodes[,2], pch="*", main="", xlab="", ylab=""  )
  points( neurons[,1], neurons[,2] )
  lines( neurons[indexClosed, 1], neurons[indexClosed, 2], cex.main=1.4, cex.axis=1.4, lwd=2.5 )
}

grid <- buildGrid( numNodes )
distGrid <- calcDistMatrix( grid )
solutionHistory <- vector("list", length=numIter)
solutionHistory[[1]] <- neurons 
stepFactor <- step_0*(step_f/step_0)
sigmaFactor <- sigma_0*(sigma_f/sigma_0)
for( k in 2:numIter ){
  print(k)  
  sampIndex <- sample(numNodes) 
  
  pastWinners <- rep( 0, numNodes-1 )
  for( j in 1:numNodes ){    
    pastIndex <- pastWinners[ pastWinners > 0 ]
    x <- nodes[sampIndex[j],]
    if( j == 1 ){
      winnerIndex <- which.min( apply( neurons, 1, function(w) calcDist2(w,x) ) ) 
    } else{
      winnerIndex <- (1:numNodes)[-pastIndex][which.min( apply( neurons[-pastIndex,, drop=FALSE], 1, function(w) calcDist2(w,x) ) )]
    }       
        
    pastWinners[j] <- winnerIndex
    
    neurons <- t(sapply( 1:numNodes, function(i) neurons[i,] + step * neighbourFunction( winnerIndex, i ) * (x - neurons[i,]) )) 
  }
  
  step <- stepFactor^(k/numIter) 
  sigma <- sigmaFactor^(k/numIter)  
    
  solutionHistory[[k]] <- neurons 
}

dist <- apply( nodes, 1, function(x) apply( neurons, 1, function(w) sum((w - x)^2) ) )
sol <- apply( dist, 1, which.min )
fsol <- evaluatePath( nodes, distMatrix, sol )

print("Best solution:", quote=FALSE); print( sol )
print("Best function evaluation:", quote=FALSE); print( fsol )    

if( flagVideo ){
  ani.options( outdir=getwd(), ani.width=600, ani.height=600, interval=30/length(solutionHistory) )
  saveVideo(      
    for( j in 1:length(solutionHistory) ){ 
     plotNeurons( solutionHistory[[j]] )  
    }, video.name=paste("tsp_som.mp4", sep=""), clean=TRUE )
} else{
  plotNeurons( neurons )   
}


