# Carrega os scripts necessários
library(ggplot2)
library(rgl)
library(misc3d)
library(animation)
source("/Users/eduardo/Desktop/IC/ComputacaoEvolucionaria/Codigos-R-Metaheuristicas/Otimização\ Numérica/benchmarkFunctions.R")
#source("../Algoritmos/ils.R")
#source("../Algoritmos/sa.R")
#source("../Algoritmos/hs.R")
#source("../Algoritmos/ga.R")
source("/Users/eduardo/Desktop/IC/ComputacaoEvolucionaria/Codigos-R-Metaheuristicas/Algoritmos/de.R")
#source("../Algoritmos/cs.R")
#source("../Algoritmos/pso.R")
#source("../Algoritmos/fa.R")
#source("../Algoritmos/abc.R")
#source("../Algoritmos/ffa.R")

flagVideo <- FALSE
whichVideo <- "Rastrigin"

# Métodos de otimização
# optimizationAlgorithm <- list( fn=ils, name="ILS", numIter=300 )
# optimizationAlgorithm <- list( fn=sa, name="SA", numIter=5000 )
# optimizationAlgorithm <- list( fn=hs, name="HS", numIter=2000 )
# optimizationAlgorithm <- list( fn=ga, name="GA", numIter=100 )
optimizationAlgorithm <- list( fn=de, name="DE", numIter=300 )
# optimizationAlgorithm <- list( fn=cs, name="CS", numIter=300 )
# optimizationAlgorithm <- list( fn=pso, name="PSO", numIter=100 )
# optimizationAlgorithm <- list( fn=fa, name="FA", numIter=100 )
# optimizationAlgorithm <- list( fn=abc, name="ABC", numIter=500 )
# optimizationAlgorithm <- list( fn=ffa, name="FFA", numIter=100 )

# Gera gráficos 3D via OpenGL?
openGl3D <- FALSE

# Escolhe uma semente para o gerador de números aleatórios
set.seed(123)

# Parâmetros para os gráficos
theme_set( theme_gray( base_size = 20 ) ) 
theme_update( axis.title.y=element_text( angle=90, vjust=0.3 ),
              axis.title.x=element_text( vjust=0.3 ) )

# Funções a serem otimizadas
objFunctions <- benchmarkFunctions

for( i in 1:length(objFunctions$fn)){
  
  # Otimiza pelo algoritmo escolhido
  print(paste("Otimizando a função", objFunctions$name[i], "via", optimizationAlgorithm$name), quote=FALSE)
  ob <- optimizationAlgorithm$fn( objFunctions$dim[i], objFunctions$fn[[i]], numIter=optimizationAlgorithm$numIter,
                               lower=objFunctions$lower[i], upper=objFunctions$upper[i],
                                  crossOverRate=0.9, mutationRate=0.1 )
  
  if( is.list( ob$fsolHistory ) ){
    df <- data.frame( iterations=1:optimizationAlgorithm$numIter, evaluations=ob$bestfSolHistory )  
  } else{
    df <- data.frame( iterations=1:optimizationAlgorithm$numIter, evaluations=ob$fsolHistory )  
  }  
  g <- ggplot( df, aes( x=iterations, y=evaluations ) ) +
    geom_line( size=I(1.5) ) +
    ggtitle( paste( "Otimização via", optimizationAlgorithm$name) ) +
    xlab( "Iterações" ) + 
    ylab( paste("Função", objFunctions$name[i]) )    
  print( g )
  print("", quote=FALSE)
  
  # Representa o domínio de busca da função
  if( objFunctions$dim[i] == 2 ){
    
    x <- seq( objFunctions$lower[i], objFunctions$upper[i], length=200 )
    grid <- expand.grid( x, x )
    y <- matrix( apply( grid, 1, objFunctions$fn[[i]] ), nrow=length(x) )
    
    # Gráficos em perspectiva
    res <- persp( x, x, y, theta=20, phi=30, ltheta = 120, expand=0.5,
                  main=paste("Função", objFunctions$name[i]),
                  col="lightblue", shade=0.75, ticktype="detailed" )
    points( trans3d( objFunctions$best[[i]][1], objFunctions$best[[i]][2], objFunctions$best[[i]][3],
                     pmat = res), col = "blue", pch=19, cex=1.5 )
    points( trans3d( ob$sol[1], ob$sol[2], ob$fsol,
                     pmat = res), col = "red", pch=19, cex=1.5 )
        
    # Gráficos de contorno
    contour( x, x, y )
    title( paste( "Evolução da busca por", optimizationAlgorithm$name, "- Função", objFunctions$name[i]) )
    if( is.list( ob$fSolHistory ) ){
      lines( sapply( ob$bestSolHistory, function(p) p[1] ), sapply( ob$bestSolHistory, function(p) p[2] ), lwd=3 )  
    } else{
      lines( sapply( ob$solHistory, function(p) p[1] ), sapply( ob$solHistory, function(p) p[2] ), lwd=3 )  
    }    
    points( objFunctions$best[[i]][1], objFunctions$best[[i]][2], col="red", pch=19, cex=1.5 )
    points( ob$sol[1], ob$sol[2], col="blue", pch=19, cex=1.5 )
    
    # Vìdeo da busca
    if( flagVideo && (whichVideo == -1 || objFunctions$name[i] == whichVideo) ){
      while(dev.cur() != 1){dev.off()}    
      graphics.off()
      ani.options( outdir=getwd(), ani.width=600, ani.height=600, interval=20/length(ob$solHistory) )
      saveVideo(      
        for( j in 1:length(ob$solHistory) ){  
          
          contour( x, x, y )
          title( paste( "Evolução da busca por", optimizationAlgorithm$name, "- Função", objFunctions$name[i], "- Iteração ", j ) )    
          for( k in 1:nrow(ob$solHistory[[j]])  ){
            points( ob$solHistory[[j]][k,1], ob$solHistory[[j]][k,2], pch=19, cex=.5 )
          }
          points( objFunctions$best[[i]][1], objFunctions$best[[i]][2], col="red", pch=19, cex=1 )
          points( ob$bestSolHistory[[j]][1], ob$bestSolHistory[[j]][2], col="blue", pch=19, cex=1 )          
          
        }, video.name=paste( optimizationAlgorithm$name, "_", objFunctions$name[i], ".mp4", sep=""), clean=TRUE )
    }
    
    # Gráficos 3D navegáveis
    #if( openGl3D ){
    #  open3d( windowRect=c(0,0,800,800) )
    #  plot3d( grid[,1], grid[,2], y, alpha=0.5,
    #          main=objFunctions$name[i] )
    #  points3d( objFunctions$best[[i]][1], objFunctions$best[[i]][2], objFunctions$best[[i]][3], col="blue", size=15 )
    #  points3d( ob$sol[1], ob$sol[2], ob$fsol, col="red", size=15 )
    #}
  }
}
