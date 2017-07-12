library(compiler)
de <- cmpfun( function( dim, fn, numIter=500, lower=0, upper=1,
                popSize=100, crossOverRate=0.9, mutationStep=0.8,
                comb=FALSE, maximization=FALSE, clustering=TRUE,
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

  crossover <- function( originalIndex ){    
    
    newSol <- rep(0, dim)
    p0 <- pop[ originalIndex, ]
    index1 <- sample((1:popSize)[-originalIndex], 1 )
    p1 <- pop[ index1, ]
    index2 <- sample((1:popSize)[-c(originalIndex,index1)], 1 )
    p2 <- pop[ index2, ]
    index3 <- sample((1:popSize)[-c(originalIndex,index1,index2)], 1 )
    p3 <- pop[ index3, ]
    
#     crossPoints <- runif(dim) < crossOverRate
#     crossPoints[ sample(dim,1) ] <- TRUE
    
          crossPoints <- rep( FALSE, dim )
          randPoint <- sample(0:(dim-1),1)
          j <- randPoint 
          while( runif(1) < crossOverRate && sum(crossPoints) != dim ){
            crossPoints[ j + 1 ] <- TRUE
            j <- j + 1
            if( j > (dim-1) ){ j <- j - (dim-1) }
          }
    
    if( comb == FALSE ){       
      newSol <- (! crossPoints) * p0 + crossPoints * ( p1 + mutationStep * ( p2 - p3 ) )            
      newSol <- ifelse( newSol < lower, lower, newSol )
      newSol <- ifelse( newSol > upper, upper, newSol )   
      if( clustering ){
        newSol <- fixSolution(newSol)
      }
      
    } else{        
      for( j in 1:dim ){        
        if( crossPoints[j] ){
          if( runif(1) > 0.5){
            index <- j
            while( j != 1 && sum(newSol[1:(j-1)] == p1[index]) != 0 ){
              index <- index + 1
              if( index > dim ){ index <- index - dim }              
            }
            newSol[j] <- p1[index]
          } else{
            index <- j
            while( j != 1 && sum(newSol[1:(j-1)] == p2[index]) != 0 ){
              index <- index + 1
              if( index > dim ){ index <- index - dim }
            }
            newSol[j] <- p2[index]        
          }
        } else{
          index <- j
          while( j != 1 && sum(newSol[1:(j-1)] == p0[index]) != 0 ){
            index <- index + 1
            if( index > dim ){ index <- index - dim }
          }
          newSol[j] <- p0[index]     
        }
      }      
      
    }
    
    newSol        
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
    
    newPop <- matrix( 0, nrow=popSize, ncol=dim )
    newPopEval <- rep( 0, popSize )
    for( j in 1:popSize ){
      newSol <- crossover(j)
      newF <- fn( newSol )

      if( newF < popEval[j] ){
        newPop[j,] <- newSol
        newPopEval[j] <- newF
      } else{
        newPop[j,] <- pop[j,]
        newPopEval[j] <- popEval[j]        
      }
    }
    pop <- newPop
    popEval <- newPopEval
        
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