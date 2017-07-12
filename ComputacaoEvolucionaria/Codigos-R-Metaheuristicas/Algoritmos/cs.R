library(compiler)
cs <- cmpfun( function( dim, fn, numIter=500, lower=0, upper=1,
                popSize=25, pa=0.25, alpha=0.01, lambda=1.5,
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
  
  sigma <- (gamma(1+lambda)*sin(pi*lambda/2)/(gamma((1+lambda)/2)*lambda*2^((lambda-1)/2)))^(1/lambda)
  
  generateRandomSolution <- function( n ){
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
  
  generateLevyFlight <- function( x ){    
    u <- rnorm(dim) * sigma
    v <- rnorm(dim)
    step <- alpha * rnorm(dim) * (u / abs(v) ^ (1/lambda))
    x <- x + step * ( globalBest - x )
    x <- ifelse( x < lower, lower, x )
    x <- ifelse( x > upper, upper, x )
    if( clustering ){
      x <- fixSolution(x)
    }
  }
  
  emptyNests <- function( pop ){
    randomFlags <- runif(popSize) > pa
    stepsize <- runif(popSize) * ( pop[sample(popSize),] - pop[sample(popSize),] )
    pop <- pop + stepsize * randomFlags
    for( j in 1:popSize ){
      if( randomFlags[j] ){
        pop[j,] <- ifelse( pop[j,] < lower, lower, pop[j,] )
        pop[j,] <- ifelse( pop[j,] > upper, upper, pop[j,] )
        if( clustering ){
          pop[j,] <- fixSolution(pop[j,])
        }
      }
    }
    pop
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
    
    newPop <- t( apply( pop, 1, function(x) generateLevyFlight(x) ) )
    newPopEval <- apply( newPop, 1, fn )  
    for( j in 1:popSize ){
      if( newPopEval[j] < popEval[j] ){
        pop[j,] <- newPop[j,]  
        popEval[j] <- newPopEval[j]
      }
    }
        
    newPop <- emptyNests( pop )
    newPopEval <- apply( newPop, 1, fn )  
    for( j in 1:popSize ){
      if( newPopEval[j] < popEval[j] ){
        pop[j,] <- newPop[j,]  
        popEval[j] <- newPopEval[j]
      }
    }
          
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