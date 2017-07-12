library(ggplot2)
library(animation)
source("./functionsTSP.R")
source("../Algoritmos/ils.R")
source("../Algoritmos/sa.R")
source("../Algoritmos/hs.R")
source("../Algoritmos/ga.R")
source("../Algoritmos/de.R")

flagVideo <- TRUE

# Escolhe uma semente para o gerador de números aleatórios
set.seed(123)

# Parâmetros para os gráficos
theme_set( theme_gray( base_size = 20 ) ) 
theme_update( axis.title.y=element_text( angle=90, vjust=0.3 ),
              axis.title.x=element_text( vjust=0.3 ) )

numNodes <- 500

nodes <- matrix( runif( 2*numNodes ), nrow=numNodes, ncol=2 )
distMatrix <- calcDistMatrix( nodes )

optimizationAlgorithm <- NULL
# optimizationAlgorithm[[length(optimizationAlgorithm)+1]] <- list( fn=ils, name="ILS", numIter=10*numNodes )
# optimizationAlgorithm[[length(optimizationAlgorithm)+1]] <- list( fn=sa, name="SA", numIter=10*numNodes*numNodes )
optimizationAlgorithm[[length(optimizationAlgorithm)+1]] <- list( fn=ga, name="GA", numIter=30*numNodes )
# optimizationAlgorithm[[length(optimizationAlgorithm)+1]] <- list( fn=de, name="DE", numIter=10*numNodes )

for( i in 1:length(optimizationAlgorithm) ){
  ob <- optimizationAlgorithm[[i]]$fn( dim=numNodes, fn=function(sol) evaluatePath(nodes, distMatrix, sol),
                                      comb=TRUE, numIter=optimizationAlgorithm[[i]]$numIter,
                                      restartCooling=TRUE, restartCount=optimizationAlgorithm[[i]]$numIter/4 )  

  if( is.list( ob$fsolHistory ) ){
    df <- data.frame( iterations=1:optimizationAlgorithm[[i]]$numIter, evaluations=ob$bestfSolHistory )  
  } else{
    df <- data.frame( iterations=1:optimizationAlgorithm[[i]]$numIter, evaluations=ob$fsolHistory )
  }
  
  g <- ggplot( df, aes( x=iterations, y=evaluations ) ) +
        geom_line( size=I(1.5) ) +
        ggtitle( paste( "Otimização via", optimizationAlgorithm[[i]]$name) ) +
        xlab( "Iterações" ) + 
        ylab( "Função objetivo" )    
  print(g)
  print( plotPath( nodes, ob$sol, paste("Mapa das", numNodes,"cidades -", optimizationAlgorithm[[i]]$name), method="ggplot" ) )

  if( flagVideo ){
    while(dev.cur() != 1){dev.off()}    
    graphics.off()
    ani.options( outdir=getwd(), ani.width=600, ani.height=600, interval=20/length(ob$solHistory) )
    saveVideo(     
      
      if( is.list( ob$fsolHistory ) ){
        for( j in 1:length(ob$bestSolHistory) ){  
          plotPath( nodes, ob$bestSolHistory[[j]], paste("Mapa das", numNodes,"cidades -", optimizationAlgorithm[[i]]$name, "- Iteração", j) )    
        }        
      } else{
        for( j in 1:length(ob$solHistory) ){  
          plotPath( nodes, ob$solHistory[[j]], paste("Mapa das", numNodes,"cidades -", optimizationAlgorithm[[i]]$name, "- Iteração", j) )    
        }  
      }
      , video.name=paste("tsp_", optimizationAlgorithm[[i]]$name, ".mp4", sep=""), clean=TRUE )
  }
}

# source("./somTSP.R")
                  
