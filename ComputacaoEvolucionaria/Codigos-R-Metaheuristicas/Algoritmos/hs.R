library(compiler)
hs <- cmpfun( function( dim, fn, numIter=500, lower=0, upper=1,
                memSize=20, considRate=0.95, maxAdjustRate=0.1, minAdjustRate=0.5, maxRange=0.1, minRange=10^-3,
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
  
  generateRandomHarmony <- function( n ){
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
  
  createHarmony <- function(){    
    if( comb == FALSE ){
      
      newHarmony <- rep( 0, dim )
      for( i in 1:dim ){
        if( runif(1) < considRate ){
          value <- memory[ sample(memSize,1), i ]
          if( runif(1) < adjustRate ){
#             value <- value + range * ( upper[i] - lower[i] ) * runif( 1, min=-1, max=1 )   
            value <- value + range[i] * runif( 1, min=-1, max=1 )   
            if( value < lower[i] ){ value <- lower[i] }
            if( value > upper[i] ){ value <- upper[i] }
          }          
          newHarmony[i] <- value
        } else{
          newHarmony[i] <- runif( 1, min=lower[i], max=upper[i] )  
        } 
      }
      
      if( clustering ){
        newHarmony <- fixSolution(newHarmony)
      }
      
    } else{
      
      newHarmony <- rep( 0, dim )
      for( i in 1:dim ){
        if( runif(1) < considRate ){
          if( i == 1 ){
            memIndex <- sample(memSize,1)
            value <- memory[ memIndex, i ]
          } else{            
            lastValue <- newHarmony[i-1]
            memIndex <- sample(memSize,1)
            nextIndex <- which( memory[ memIndex, ] == lastValue ) + 1
            if( nextIndex > dim ){ nextIndex <- nextIndex - dim }
            
            while( sum( newHarmony[1:(i-1)] == memory[ memIndex, nextIndex ] ) != 0 ){
              nextIndex <- nextIndex + 1
              if( nextIndex > dim ){ nextIndex <- nextIndex - dim }  
            }
            value <- memory[ memIndex, nextIndex ]
          }
          if( runif(1) < adjustRate ){                
            index <- which( memory[ memIndex, ] == value )
            newIndex <- index + sample( c(-3,-2,-1,1,2,3), 1 )
            if( newIndex < 1 ){ newIndex <- dim - newIndex }
            if( newIndex > dim ){ newIndex <- newIndex - dim }
            if( sum( newHarmony[1:(i-1)] == memory[ memIndex, newIndex ] ) == 0 ){
              value <- memory[ memIndex, newIndex ]
            }
          }
          newHarmony[i] <- value
          
        } else{
          if( i == 1 ){
            newHarmony[i] <- sample( dim, 1 )    
          } else{      
            closestDist <- min( distMatrix[ newHarmony[i-1], ][ - newHarmony[1:(i-1)] ] ) 
            newHarmony[i] <- which( distMatrix[ newHarmony[i-1], ] == closestDist )
          }          
        } 
      } 
    }
    newHarmony
  }
  
  localSearch <- function( x ){    
    bestLocal <- x
    bestFLocal <- fn( x )
    
    testLocal <- function( new ){
      fnew <- fn( new )
      if( fnew < bestFLocal ){
        bestLocal <<- new
        bestFLocal <<- fnew
      }  
    }
    
    for( i in 1:dim ){      
      new <- x
      indexChange <- i
      indexChange <- c( indexChange, sample((1:dim)[-i],1) )
      if( indexChange[1] > indexChange[2] ){
        indexChange <- c(indexChange[2], indexChange[1])   
      }
      while( indexChange[2] > indexChange[1] ){
        aux <- new[indexChange[1] + 1]
        new[indexChange[1] + 1] <- new[indexChange[2]]
        new[indexChange[2]] <- aux
        indexChange[1] <- indexChange[1] + 1
        indexChange[2] <- indexChange[2] - 1
      }
      testLocal( new )                
    }
    bestLocal
  }
    
  memory <- generateRandomHarmony( memSize )  
  memoryEval <- apply( memory, 1, fn )  
  
  bestHarmonyIndex <- which.min( memoryEval )  
  if( history ){
    solHistory <- vector( "list", numIter )
    fsolHistory <- vector( "list", numIter )
    solHistory[[1]] <- memory
    fsolHistory[[1]] <- memoryEval
    bestSolHistory <- vector( "list", numIter )
    bestfSolHistory <- rep(0, numIter)  
    bestSolHistory[[1]] <- memory[ bestHarmonyIndex, ]
    bestfSolHistory[1] <- memoryEval[ bestHarmonyIndex ]
  }
  globalBest <- memory[bestHarmonyIndex,]
  fGlobalBest <- memoryEval[bestHarmonyIndex]
  
  scale <- upper - lower
  for( i in 2:numIter ){  
    
    range <- maxRange * exp( log(minRange/maxRange)*i/numIter ) * scale
    adjustRate <- minAdjustRate + (maxAdjustRate - minAdjustRate) * i / numIter
    
    harmony <- createHarmony()    
    if( comb == TRUE ){
      harmony <- localSearch( harmony )
    }
    harmonyEval <- fn( harmony )
    
    index <- which.max( memoryEval )
    if( harmonyEval < memoryEval[ index ] ){
      memory[ index, ] <- harmony
      memoryEval[ index ] <- harmonyEval
      if( harmonyEval < memoryEval[ bestHarmonyIndex ]  ){      
        bestHarmonyIndex <- index
      } 
    }
    
    bestHarmonyIndex <- which.min( memoryEval )  
    if( memoryEval[ bestHarmonyIndex ]  <  fGlobalBest ){
      globalBest <- memory[ bestHarmonyIndex, ]
      fGlobalBest <- memoryEval[ bestHarmonyIndex ] 
    }
    if( history ){
      bestSolHistory[[i]] <- globalBest
      bestfSolHistory[i] <- fGlobalBest     
      solHistory[[i]] <- memory
      fsolHistory[[i]] <- memoryEval 
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