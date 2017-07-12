plotPath <- function( nodes, solution, title="Mapa das cidades", method="plot" ){
  numNodes <- nrow( nodes )
  bestPath <- c( solution[1:numNodes], solution[1] )
  if( method != "ggplot" ){
    plot( nodes[bestPath, 1], nodes[bestPath, 2], type="l", main=title, xlab="", ylab="", cex.main=1.4, cex.axis=1.4, lwd=2.5 )
  } else{
    ggplot() +
      geom_point( aes(x=x,y=y), data.frame(x=nodes[,1],y=nodes[,2]) ) +
      geom_path( aes(x=x,y=y), data.frame(x=nodes[bestPath, 1], y=nodes[bestPath, 2] ) ) +
      ggtitle(title) + xlab("") + ylab("")    
  }
}

calcDistMatrix <- function( nodes ){
  apply( nodes, 1, function(p1) apply( nodes, 1, function(p2) sqrt(sum((p1 - p2)^2)) ) )  
}

evaluatePath <- function( nodes, distMatrix, solution ){
  numNodes <- nrow( nodes )
  res <- 0    
  for( i in 1:(numNodes-1) ){
    res <- res + distMatrix[solution[i], solution[i+1]]       
  }
  res + distMatrix[solution[numNodes], solution[1]] 
}
