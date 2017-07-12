library(compiler)
pso <- cmpfun( function( dim, fn, numIter=500, lower=0, upper=1,
                popSize=40, ringTopology=FALSE, 
                c1=1.193, c2=1.193, w=0.721,
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
    } else{
      res <- t( replicate( n, sample(dim) ) )
    }
    res
  }

  updatePosition <- function(){  
    phi1 <- c1 * runif(dim)
    phi2 <- c2 * runif(dim)
    for( i in 1:popSize ){
      if( ringTopology ){      
        vPop[i,] <<- w * vPop[i,] + phi1*(pBest[i,] - pop[i,]) + phi2*(lBest[i,] - pop[i,])
      } else{  
        vPop[i,] <<- w * vPop[i,] + phi1*(pBest[i,] - pop[i,]) + phi2*(gBest - pop[i,])
      }  
    }

    pop <- pop + vPop    
    for( i in 1:popSize ){
      for( j in 1:dim ){
        if( pop[i,j] < lower[j] ){
          pop[i,j] <- lower[j]
          vPop[i,j] <<- 0
        } else if( pop[i,j] > upper[j] ){
          pop[i,j] <- upper[j]
          vPop[i,j] <<- 0
        }
      }
      if( clustering ){
        pop[i,] <- fixSolution(pop[i,]) 
      }
    }
    pop
  }
  
  updateBestMemory <- function(){    
    for( i in 1:popSize ){      
      if( popEval[i] < pBestEval[i] ){
        pBest[i,] <<- pop[i,]
        pBestEval[i] <<- popEval[i]       
      }      
    }
    
    bestIndex <- which.min( pBestEval ) 
    if( pBestEval[bestIndex] < gBestEval ){
      gBest <<- pBest[bestIndex,]
      gBestEval <<- pBestEval[bestIndex]       
    }  
    
    if( ringTopology ){
      updateBestLocal()
    }
  }
  
  updateBestLocal <- function(){
    for( i in 1:popSize ){
      localIndex <- c( ifelse(i-1 == 0, popSize, i-1), i, ifelse(i+1 > popSize, 1, i+1) )      
      bestLocalIndex <- localIndex[ which.min( pBestEval[localIndex] ) ]    
      if( pBestEval[bestLocalIndex] < lBestEval[i] ){
        lBest[i,] <<- pBest[bestLocalIndex,]
        lBestEval[i] <<- pBestEval[bestLocalIndex]      
      }
    }
  }
    
  pop <- generateRandomSolution( popSize )  
  if( clustering ){
    pop <- t( apply( pop, 1, fixSolution ) )
  }
  popEval <- apply( pop, 1, fn )  
  vPop <- (generateRandomSolution( popSize ) - pop)/2
  pBest <- pop
  pBestEval <- popEval
  if( ringTopology ){
    lBest <- pop
    lBestEval <- popEval 
    updateBestLocal() 
  }
  gBest <- rep(0, dim)
  gBestEval <- 0 
  
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
  gBest <- pop[ bestIndex, ]
  gBestEval <- popEval[ bestIndex ]

  for( i in 2:numIter ){  
    
    if( verbose ){
      print(paste("Generation:", i, ", Best:", gBestEval), quote=FALSE)
    }
    
    pop <- updatePosition()    
    popEval <- apply( pop, 1, fn )  
    updateBestMemory()
    
    if( history ){
      bestSolHistory[[i]] <- gBest
      bestfSolHistory[i] <- gBestEval     
      solHistory[[i]] <- pop
      fsolHistory[[i]] <- popEval 
    } 
  }
  
  if( verbose ){
    print("Best solution:", quote=FALSE); print( gBest )
    print("Best function evaluation:", quote=FALSE); print( gBestEval )    
  }
  if( history ){
    ob <- list( sol=gBest, fsol=gBestEval,
                solHistory=solHistory, fsolHistory=fsolHistory,
                bestSolHistory=bestSolHistory, bestfSolHistory=bestfSolHistory )
  } else{
    ob <- list( sol=gBest, fsol=gBestEval )    
  }
  ob
} )