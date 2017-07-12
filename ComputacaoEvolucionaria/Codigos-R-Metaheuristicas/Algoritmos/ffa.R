library(compiler)
ffa <- cmpfun( function( dim, fn, numIter=500, lower=0, upper=1,
                popSize=25, gama=1/((upper-lower)^2), alpha0=0.01, alphaF=10^-5, beta=1,
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
  
  moveFirefly <- function( i, j=0, random=FALSE ){
    lambda=1.5
    sigma <- (gamma(1+lambda)*sin(pi*lambda/2)/(gamma((1+lambda)/2)*lambda*2^((lambda-1)/2)))^(1/lambda)
    u <- rnorm(dim) * sigma
    v <- rnorm(dim)
    randomStep <- alpha * (upper - lower) * rnorm(dim) * (u / abs(v) ^ (1/lambda))
    if( random == FALSE ){
      pop[i,] <<- pop[i,] + beta * exp( -gama * sum((pop[i,] - pop[j,])^2) ) * ( pop[j,] - pop[i,] ) + randomStep  
    } else{
      pop[i,] <<- pop[i,] + randomStep
    }
    pop[i,] <<- ifelse( pop[i,] < lower, lower, pop[i,] )
    pop[i,] <<- ifelse( pop[i,] > upper, upper, pop[i,] )     
    if( clustering ){
      pop[i,] <<- fixSolution(pop[i,])
    }
    popEval[i] <<- fn(pop[i,]) 
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
  
  alphaVector <- seq( alpha0, alphaF, length.out=numIter )
  alpha <- alpha0
  for( i in 2:numIter ){
    
    alpha <- alphaVector[i]
      
    for( j in 1:popSize ){
      for( k in 1:popSize ){
        if( popEval[k] < popEval[j] ){
          moveFirefly(j,k)
        }
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