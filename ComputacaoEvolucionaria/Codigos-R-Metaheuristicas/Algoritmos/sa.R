library(compiler)
sa <- cmpfun( function( dim, fn, numIter=10000, lower=0, upper=1, pertubationStep=0.1, finalPertubationStep=0.001,
                tMax=1000, tChange=0.98,
                restartCooling=TRUE, restartCount=1000,
                comb=FALSE, maximization=FALSE, clustering=FALSE,
                verbose=TRUE, history=TRUE, ...){
  
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
  
  generateRandomSolution <- function(){
    if( comb == FALSE ){
      res <- sapply( 1:dim, function(i) runif( 1, min=lower[i], max=upper[i] ) )    
      if( clustering ){
        res <- fixSolution(res)
      }
    } else{
      res <- sample( dim )  
    }
    res
  }
    
  pertubation <- function( x, step=pertubationStep ){    
    if( comb == FALSE ){
      x <- x + (upper-lower) * sapply( 1:dim, function(i) runif( 1, min=-step, max=step ) ) 
      x <- ifelse( x < lower, lower, x )
      x <- ifelse( x > upper, upper, x )
      if( clustering ){
        x <- fixSolution(x)
      }
    } else{
      indexChange <- sample(dim,2)
      if( indexChange[1] > indexChange[2] ){
        indexChange <- c(indexChange[2], indexChange[1])   
      }
      while( indexChange[2] > indexChange[1] ){
        aux <- x[indexChange[1] + 1]
        x[indexChange[1] + 1] <- x[indexChange[2]]
        x[indexChange[2]] <- aux
        indexChange[1] <- indexChange[1] + 1
        indexChange[2] <- indexChange[2] - 1  
      }        
      x
    }
  }
    
  sol <- generateRandomSolution()  
  fsol <- fn( sol )
  bestSol <- sol
  bestfSol <- fsol
  tAnt <- tMax
  t <- tAnt
  step <- pertubationStep
  
  if( history ){
    solHistory <- vector( "list", numIter )
    fsolHistory <- rep(0, numIter)  
    bestSolHistory <- vector( "list", numIter )
    bestfSolHistory <- rep(0, numIter)  
    solHistory[[1]] <- sol
    fsolHistory[1] <- fsol
    bestSolHistory[[1]] <- sol
    bestfSolHistory[1] <- fsol
  }
  
  countReject <- 0  
  for( i in 2:numIter ){  
    
    if( verbose ){
      print(paste("Generation:", i, ", Best:", bestfSol), quote=FALSE)
    }
    
    x <- pertubation( sol, step )
    
    fx <- fn( x )
    if( fx < fsol  ){
      sol <- x
      fsol <- fx
      if( fsol < bestfSol ){
        bestSol <- sol
        bestfSol <- fsol   
      }
    } else{
      if( exp( (fsol - fx) / t ) > runif(1) ){
        sol <- x
        fsol <- fx  
      } else if( restartCooling ){
        countReject <- countReject + 1
        if( countReject >= restartCount ){
          sol <- bestSol 
          fsol <- bestfSol
          t <- tMax
          tAnt <- t
          countReject <- 0
        }
      } 
    }     
    
    #step <- (finalPertubationStep - pertubationStep)*(i-1) / (numIter-1) + pertubationStep
    step <- pertubationStep * (finalPertubationStep/pertubationStep)^(i/numIter)     
    
    t <- tAnt * tChange
    tAnt <- t
    
    if( history ){
      solHistory[[i]] <- sol
      fsolHistory[i] <- fsol
      bestSolHistory[[i]] <- bestSol
      bestfSolHistory[i] <- bestfSol
    }
  }
  
  if( verbose ){
    print("Best solution:", quote=FALSE); print( bestSol )
    print("Best function evaluation:", quote=FALSE); print( bestfSol )    
  }
  if( history ){
    ob <- list( sol=bestSol, fsol=bestfSol,
                solHistory=solHistory, fsolHistory=fsolHistory,
                bestSolHistory=bestSolHistory, bestfSolHistory=bestfSolHistory ) 
  } else{
    ob <- list( sol=bestSol, fsol=bestfSol )   
  }
  ob
} )