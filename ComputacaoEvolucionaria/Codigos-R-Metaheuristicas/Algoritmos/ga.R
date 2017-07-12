library(compiler)
ga <- cmpfun( function( dim, fn, numIter=500, lower=0, upper=1,
                popSize=100, tournamentSize=2, crossOverRate=0.95, mutationRate=0.05, mutationStep=0.01,
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
  
  tournamentSelection <- function( k=tournamentSize ){
    indexCandadates <- sample( popSize, k )
    candidatesEval <- popEval[ indexCandadates ]    
    winnerIndex <- indexCandadates[ which.min( candidatesEval ) ]
  }
  
  crossover <- cmpfun( function( x1, x2 ){    
    if( runif(1) > crossOverRate ){
      return( rbind( x1, x2 ) )
    }
    
    children <- matrix( 0, nrow=2, ncol=dim )
    
    #SBX crossover - Computational Intelligence, pg 149
    if( comb == FALSE ){
      randomVector <- runif(dim)
      
      y <- ifelse( randomVector <= 0.5, sqrt(2*randomVector), sqrt(0.5/(1-randomVector)) )     
      children[1,] <- 0.5 * ( (1 + y)*x1 + (1 - y)*x2 ) 
      children[2,] <- 0.5 * ( (1 - y)*x1 + (1 + y)*x2 ) 
    
    } else{
      crossPoints <- sample(dim, 2)
      if( crossPoints[2] < crossPoints[1] ){
        crossPoints <- c( crossPoints[2], crossPoints[1] )  
      }
      
      children[1, crossPoints[1]:crossPoints[2] ] <- x1[ crossPoints[1]:crossPoints[2] ]
      children[2, crossPoints[1]:crossPoints[2] ] <- x2[ crossPoints[1]:crossPoints[2] ]
            
      parents <- rbind( x2, x1 )
      for( k in 1:2 ){
        i <- crossPoints[2] + 1
        if( i > dim ){ i <- i - dim }
        while( i != crossPoints[1] ){
          j <- i
          while( sum( children[k,] == parents[k,j] ) != 0 ){
            j <- j + 1
            if( j > dim ){ j <- j - dim }
          }        
          children[k, i] <- parents[k,j]          
          i <- i + 1
          if( i > dim ){ i <- i - dim }
        }      
      }      
    }
    
    children        
  } )
  
  mutation <- cmpfun( function( x ){ 
    
    if( comb == FALSE ){
      randomUniformVector <- runif(dim)
      randomStepVector <- mutationStep * ( (upper - lower) * rnorm(dim) + lower )
          
      x <- x + ( randomUniformVector < mutationRate ) * randomStepVector   
      x <- ifelse( x < lower, lower, x )
      x <- ifelse( x > upper, upper, x )
      if( clustering ){
        x <- fixSolution(x)
      }
    
    } else{
      if( runif(1) < mutationRate ){
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
      } 
    }
    
    x    
  } )
    
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
        
    parentsIndex <- replicate( popSize, tournamentSelection() )
    
    offspring <- matrix( 0, nrow=popSize, ncol=dim  )     
    for( j in seq( 1, popSize, 2 ) ){
      children <- crossover( pop[ parentsIndex[j], ], pop[ parentsIndex[j+1], ] )  
      children <- t( apply( children, 1, mutation ) )      
      offspring[j:(j+1), ] <- children
    }
    
    offspringEval <- apply( offspring, 1, fn )
    
    pop <- rbind( pop, offspring )
    popEval <- c( popEval, offspringEval )
    survivorsIndex <- sort.int( popEval, index.return=TRUE )$ix[1:popSize]
    pop <- pop[ survivorsIndex, ]
    popEval <- popEval[ survivorsIndex ]
            
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