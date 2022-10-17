rm(list = ls())
#install.packages("fitdistrplus")
library(ggplot2)
library(fitdistrplus)

#### Needed Functions
start_time <- Sys.time()

pot_change <- function(A,B,pot){
  a_die <- sample(1:6, 1, replace=TRUE)
  b_die <-sample(1:6, 1, replace=TRUE)
  run_history <- setNames(data.frame(matrix(ncol = 3, nrow = 0)), c("Player A", "Player B", "Pot"))
  
  ##Action for A
  if (a_die == 2) {
    A <- A+pot
    pot<- 0
  }
  if(a_die==3){
    A <- A+floor(pot/2)
    pot <- ceiling(pot/2)
  }
  if(a_die==4 | a_die==5 | a_die==6){
    A <- A-1
    pot <- pot+1
  }
  
##Action for B
if (b_die == 2) {
  B <- B+pot
  pot<- 0
}
if(b_die==3){
  B <- B+floor(pot/2)
  pot <- ceiling(pot/2)
}
if(b_die==4 | b_die==5 | b_die==6){
  B <- B-1
  pot <- pot+1
}
run_final<-c(A, B, pot)
run_history<-rbind(run_history,run_final)
return(run_final)
}

run_sim <-function(x){
  run_count <-0
  
  while(x[1]>=0 && x[2]>=0 && x[3]>=0){
    y<-pot_change(x[1],x[2],x[3])
    x<-y
    run_count<- run_count+1
  }
  
  return(run_count)
}

#####
##### Initialize and Run

x<-c(4,4,2)
runs <- c()
set.seed(42)

for (i in 1:5000){
  current_run <- run_sim(x)
  runs<-append(runs,current_run)
}



hist(runs, breaks = 0:150, main = "Number of Runs Before End of Game", xlab = "Number of Runs", col = "cyan")
summary(runs)

end_time <- Sys.time()
end_time - start_time

runs.g <- fitdist(runs, "gamma")
runs.ln <- fitdist(runs, "lnorm")
runs.w <- fitdist(runs, "weibull")
runs.geo <- fitdist(runs, "geom")

#plot.legend <- c("Gamma", "LogNorm", "Weibull")
#denscomp(list(runs.g, runs.ln, runs.w), legendtext = plot.legend, plotstyle = "ggplot", breaks = 1:150)

runs.g
runs.ln
runs.w
runs.geo

plot(runs.geo, breaks = 0:150)
#plot(runs.ln, breaks = 0:150)




