library(compiler)
fa <- cmpfun( function( dim, fn, numIter=500, lower=0, upper=1,
                 popSize=5, totalSparks=50, numGaussianSparks=5,
                 minRatioSparks=0.04, maxRatioSparks=0.8, maxAmplitudeExposion=40,
                 comb=FALSE, maximization=FALSE, clustering=FALSE,
                 verbose=TRUE, history=TRUE, ... ){
  
  if( exists("fixSolution") == FALSE ){
    fixSolution <- NULL
  }
  if( comb == FALSE ){
    if( length(lower) != dim ){ lower <- rep( lower, dim ) }
    if( length(upper) != dim ){ upper <- rep( upper, dim ) }
  }
  if( maximization ){
    originalFn <- fn
    fn <- function(x) -originalFn(x)
  }
  
  generateRandomSolution <- function( n, l=lower, u=upper ){
    if( comb == FALSE ){
      res <- t( replicate( n, sapply( 1:dim, function(i) runif( 1, min=lower[i], max=upper[i] ) ) ) )
      if( clustering ){
        res <- t( apply( res, 1, fixSolution ) )
      }
    } else{
      res <- t( replicate( n, sample(dim) ) )
    }
    res
  }
  
  calculateNumberOfSparks <- function(){    
    eps <- 10^-20
    worstEval <- max(popEval)    
    numSparks <- ceiling( totalSparks * (worstEval - popEval + eps) / (popSize*worstEval - sum(popEval) + eps)  )
    numSparks <- ifelse( numSparks < minRatioSparks*totalSparks, ceiling(minRatioSparks*totalSparks), numSparks )    
    numSparks <- ifelse( numSparks > maxRatioSparks*totalSparks, ceiling(maxRatioSparks*totalSparks), numSparks )
    numSparks
  }
  
  calculateAmplitudeOfSparks <- function(){
    eps <- 10^-20
    bestEval <- min(popEval)    
    amplitudeSparks <- maxAmplitudeExposion * (popEval - bestEval + eps) / (sum(popEval) - popSize*bestEval + eps)
    amplitudeSparks  
  }
  
  locateSparks <- function( numSparks, amplitudeSparks, gaussian=FALSE, sparksFireworksIndex=NULL ){
    if( is.null(sparksFireworksIndex) ){
      sparksFireworksIndex <- 1:popSize
    }
    
    sparksList <- vector("list", length(sparksFireworksIndex))
    for( i in 1:length(sparksFireworksIndex) ){ 
      index <- sparksFireworksIndex[i]
      sparksList[[i]] <- matrix(0, nrow=numSparks[index], ncol=dim)
      for( j in 1:numSparks[index] ){
        spark <- pop[index,]        
        if( gaussian ){
          displacement <- rnorm(1, mean=1, sd=1)  
        } else{
          displacement <- amplitudeSparks[index] * (2*runif(1)-1)  
        }        
        for( k in 1:dim ){
          if( round(runif(1)) == 1 ){
            if( gaussian ){
              spark[k] <- spark[k] * displacement
            } else{
              spark[k] <- spark[k] + displacement  
            }
            if( spark[k] < lower[k] || spark[k] > upper[k] ){
              spark[k] <- lower[k] + abs(spark[k]) %% (upper[k] - lower[k]) 
            }    
          }
        }
        if( clustering ){
          spark <- fixSolution(spark)
        }
        sparksList[[i]][j,] <- spark
      }      
    }
    sparksList
  }
  
  selectLocations <- function( sparksList, gaussianSparksList ){    
    allSparks <- rbind( do.call(rbind, sparksList), do.call(rbind, gaussianSparksList) )
    allSparks <- rbind( pop, allSparks )
    numAllSparks <- nrow(allSparks)
    allSparksEval <- c( popEval, apply( allSparks[(popSize+1):numAllSparks,], 1, fn ) )
    bestIndex <- which.min( allSparksEval )
    
    locationVector <- sapply( 1:numAllSparks, function(i) sum(sapply( 1:numAllSparks, function(j) sum((allSparks[i,] - allSparks[j,])^2) )) )   
    probabilityVector <- locationVector / sum(locationVector)
            
    randIndex <- rep(0, popSize)
    randIndex[1] <- bestIndex
    randIndex[2:popSize] <- sample( numAllSparks, popSize-1, prob=probabilityVector )
    while( sum(randIndex[2:popSize] == bestIndex) > 0 ){
      randIndex[2:popSize] <- sample( numAllSparks, popSize-1, prob=probabilityVector )  
    }
        
    allSparks <<- allSparks
    allSparksEval <<- allSparksEval
    pop <<- allSparks[randIndex, ] 
    popEval <<- allSparksEval[randIndex]    
  }
    
  pop <- generateRandomSolution( popSize )  
  popEval <- apply( pop, 1, fn )  
  
  bestIndex <- which.min( popEval )  
  if( history ){
    solHistory <- vector( "list", numIter )
    fsolHistory <- vector( "list", numIter )
    solHistory[[1]] <- pop
    fsolHistory[[1]] <- popEval
    bestSolHistory <- vector( "list", numIter )
    bestfSolHistory <- rep(0, numIter)  
    bestSolHistory[[1]] <- pop[ bestIndex, ]
    bestfSolHistory[1] <- popEval[ bestIndex ]
  }
  globalBest <- pop[bestIndex,]
  fGlobalBest <- popEval[bestIndex]
  
  for( i in 2:numIter ){  
    
    if( verbose ){
      print(paste("Generation:", i, ", Best:", fGlobalBest), quote=FALSE)
    }
    
    numSparks <- calculateNumberOfSparks()
    amplitudeSparks <- calculateAmplitudeOfSparks()
    
    sparksList <- locateSparks( numSparks, amplitudeSparks )    
    gaussianFireworksIndex <- sample(popSize)[1:numGaussianSparks]    
    gaussianSparksList <- locateSparks( numSparks, amplitudeSparks, gaussian=TRUE, gaussianFireworksIndex )
        
    selectLocations( sparksList, gaussianSparksList )
    
    bestIndex <- which.min( popEval )    
    if( popEval[ bestIndex ]  <  fGlobalBest ){
      globalBest <- pop[ bestIndex, ]
      fGlobalBest <- popEval[ bestIndex ] 
    }
    if( history ){
      bestSolHistory[[i]] <- globalBest
      bestfSolHistory[i] <- fGlobalBest     
      solHistory[[i]] <- pop
      fsolHistory[[i]] <- popEval 
    } 
  }
  
  if( verbose ){
    print("Best solution:", quote=FALSE); print( globalBest )
    print("Best function evaluation:", quote=FALSE); print( fGlobalBest )    
  }
  if( history ){
    ob <- list( sol=globalBest, fsol=fGlobalBest,
                solHistory=solHistory, fsolHistory=fsolHistory,
                bestSolHistory=bestSolHistory, bestfSolHistory=bestfSolHistory )
  } else{
    ob <- list( sol=globalBest, fsol=fGlobalBest )    
  }
  ob
} )