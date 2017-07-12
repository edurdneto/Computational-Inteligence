library(ggplot2)
library(combinat)
source("./functionsTSP.R")

# Escolhe uma semente para o gerador de números aleatórios
set.seed(123)

# Parâmetros para os gráficos
theme_set( theme_gray( base_size = 20 ) ) 
theme_update( axis.title.y=element_text( angle=90, vjust=0.3 ),
              axis.title.x=element_text( vjust=0.3 ) )

numNodes <- 4:10
listNodes <- vector("list", length(numNodes))
for( i in 1:length(listNodes) ){
  listNodes[[i]] <- matrix( runif( 2*numNodes[i] ), nrow=numNodes[i], ncol=2 )  
}

exaustSearch <- function( nodes, fn=function(sol) evaluatePath(nodes, sol) ){
  dim <- nrow(nodes)
  possibleRoutes <- permn(dim)
  x <- possibleRoutes[[1]]
  xBest <- x
  fBest <- fn( xBest )
  for( i in 1:length(possibleRoutes) ){
    fNew <- fn( possibleRoutes[[i]] )  
    if( fNew < fBest ){
      xBest <- possibleRoutes[[i]] 
      fBest <- fNew
    }
  }
  print(paste("Searched:", length(possibleRoutes), "solutions." ), quote=FALSE)
  print("Best solution:", quote=FALSE); print( xBest )
  print("Best function evaluation:", quote=FALSE); print( fBest )    
  ob <- list( sol=xBest, fsol=fBest, lengthSearch=length(possibleRoutes))
}

t <- rep(0, length(listNodes))
lengthSearch <- rep(0, length(listNodes))
for( i in 1:length(listNodes) ){
  t[i] <- system.time( ob <- exaustSearch( listNodes[[i]] ) )[3]
  lengthSearch[i] <- ob$lengthSearch
}

ggplot(data.frame(x=numNodes,y=t), aes(x=x, y=y)) + geom_line() +
  xlab("Número de cidades") + ylab("Tempo de processamento (s)")

ggplot(data.frame(x=numNodes,y=lengthSearch), aes(x=x, y=y)) + geom_line() +
  xlab("Número de cidades") + ylab("Número de caminhos testados")

ggplot(data.frame(x=1:100,y=log10(factorial(1:100))), aes(x=x, y=y)) + geom_line() +
  xlab("Número de cidades") + ylab("Número de avaliações (log10)")


  
