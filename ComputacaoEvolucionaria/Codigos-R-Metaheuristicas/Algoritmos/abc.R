library(compiler)
abc <- cmpfun( function( dim, fn, numIter=500, lower=0, upper=1,
                        popSize=40, limit=popSize*dim, step=1,
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
  
  employedBeesPhase <- function( randIndex=NULL ){          
    if( is.null(randIndex) ){
      indexVector <- 1:popSize 
    } else{
      indexVector <- randIndex   
    }
    for( i in indexVector ){
      newSol <- pop[i,]
      k <- sample(dim, 1)
      j <- sample((1:popSize)[-i], 1)
      newSol[k] <- newSol[k] + runif(1, min=-step, max=step) * (newSol[k] - pop[j,k])
      if( newSol[k] > upper[k] ){
        newSol[k] <- upper[k]  
      } else if( newSol[k] < lower[k] ){
        newSol[k] <- lower[k]  
      }
      
      if( clustering ){
        newSol <- fixSolution(newSol)
      }
      newEval <- fn(newSol)      
      if( newEval < popEval[i] ){
        pop[i,] <<- newSol
        popEval[i] <<- newEval
      } else{
        countLimitVector[i] <<- countLimitVector[i] + 1
      }
    }
  }
  
  onlookerBeesPhase <- function(){
    probabilityVector <- rep(0, popSize)
    if( maximization == FALSE ){
      for( i in 1:popSize ){
        if( popEval[i] < 0 ){
          probabilityVector[i] <- 1 + abs(popEval[i]) 
        } else{
          probabilityVector[i] <- 1 / (popEval[i] + 1)   
        }
      }
    } else{
      probabilityVector <- popEval / sum(popEval)
    }
    randIndexVector <- sample( popSize, popSize, replace=TRUE, prob=probabilityVector )          
    employedBeesPhase( randIndexVector )
  }
  
  abandonAndScout <- function(){          
    abandonIndex <- which( countLimitVector >= limit )
    if( length(abandonIndex) ){
      pop[abandonIndex,] <<- generateRandomSolution( length(abandonIndex) )   
      popEval[abandonIndex] <<- apply( pop[abandonIndex,,drop=FALSE], 1, fn ) 
      countLimitVector[abandonIndex] <<- 0
    } else{
      worstIndex <- which.max( popEval )
      pop[worstIndex,] <<- generateRandomSolution(1)   
      popEval[worstIndex] <<- fn(pop[worstIndex,])
      countLimitVector[worstIndex] <<- 0    
    }
  }
  
  pop <- generateRandomSolution( popSize )  
  popEval <- apply( pop, 1, fn )  
  countLimitVector <- rep(0, popSize)
  
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
    
    employedBeesPhase()
    onlookerBeesPhase()
    abandonAndScout()
    
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