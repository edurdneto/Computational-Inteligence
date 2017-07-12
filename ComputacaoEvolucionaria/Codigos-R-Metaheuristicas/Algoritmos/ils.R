library(compiler)
ils <- cmpfun( function( dim, fn, numIter=100, lower=0, upper=1, pertubationStep=0.1,
                 doLocalSearch=TRUE, localSearchStep=0.01, numIterLocal=50,
                 comb=FALSE, maximization=FALSE, verbose=TRUE, history=TRUE, ...){
    
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
      sapply( 1:dim, function(i) runif( 1, min=lower[i], max=upper[i] ) )    
    } else{
      sample(dim)
    }
  }
    
  pertubation <- function( x, step=pertubationStep ){    
    if( comb == FALSE ){
      x <- x + (upper-lower) * sapply( 1:dim, function(i) runif( 1, min=-step, max=step ) ) 
      x <- ifelse( x < lower, lower, x )
      x <- ifelse( x > upper, upper, x )
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
  
  localSearch <- function( x, step = localSearchStep ){    
    bestLocal <- x
    bestFLocal <- fn( x )
    
    testLocal <- function( new ){
      fnew <- fn( new )
      if( fnew < bestFLocal ){
        bestLocal <<- new
        bestFLocal <<- fnew
      }  
    }
    
    if( comb == FALSE ){
      for( i in 1:numIterLocal ){         
          new <- pertubation( x, step ) 
          testLocal( new )
      }  
    } else{
      for( i in 1:dim ){
        new <- x
        index <- sample(dim,1)
        aux <- new[i]        
        new[i] <- new[index]
        new[index] <- aux
        testLocal( new )                
      }
    }
    bestLocal
  }
  
  sol <- generateRandomSolution()  
  if( doLocalSearch ){ sol <- localSearch( sol ) }
  fsol <- fn( sol )
  
  if( history ){
    solHistory <- vector( "list", numIter )
    fsolHistory <- rep(0, numIter)  
    solHistory[[1]] <- sol
    fsolHistory[1] <- fsol
  }
  
  for( i in 2:numIter ){  
    
    x <- pertubation( sol )
    if( doLocalSearch ){ x <- localSearch( x ) }
    
    fx <- fn( x )
    if( fx < fsol  ){
      sol <- x
      fsol <- fx
    }    
    if( history ){
      solHistory[[i]] <- sol
      fsolHistory[i] <- fsol
    }
  }
  
  if( verbose ){
    print("Best solution:", quote=FALSE); print( sol )
    print("Best function evaluation:", quote=FALSE); print( fsol )  
  }
  if( history ){
    ob <- list( sol=sol, fsol=fsol,
                solHistory=solHistory, fsolHistory=fsolHistory,
                bestSolHistory=solHistory, bestfSolHistory=fsolHistory )
  } else{
    ob <- list( sol=sol, fsol=fsol )  
  }
  ob
} )