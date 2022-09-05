# Library of Random Variate Generation Routines. 
#
# Discrete Distributions included: Bernoulli, Binomial, Negative Binomial, 
#   Geometric, Poisson
#
# Continuous Distributions included: Uniform, Exponential, Normal, Erlang, 
#   Triangular, Gamma, Weibull

# Clear Environment and load relevant libraries
rm(list=ls())
seed.number <- 42
set.seed(seed.number)
library(ggplot2)
library(dplyr)
library(clean)
library(nortest)

#Function definition


# User Input
RVG <- function(){
  
  #Uniform Distribution function
  unif <- function(seed.number, q) {
    x1 <- numeric(q+3)
    x1[1]<-seed.number+1
    x1[2]<-seed.number+2
    x1[3]<-seed.number+3
    
    x2 <- numeric(q+3)
    x2[1]<-seed.number+4
    x2[2]<-seed.number+5
    x2[3]<-seed.number
    
    Y <- numeric(q)
    counter <- seq(from=4, to=q+3, by=1)
    
    for (i in counter) {
      x1[i]<- (1403580*x1[i-2]-810728*x1[i-3])%%((2^32)-209)
      x2[i]<- (527612*x2[i-1]-1370589*x2[i-3])%%((2^32)-22853)
      Y[i-3]<- (x1[i]-x2[i])%%((2^32)-209)
    }
    RV <- Y/((2^32)-209)
    return(RV)
  }
  dst <- menu(c("Bernoulli", "Binomial", "Geometric", "Poisson", "Uniform", 
                "Exponential", "Normal", "Erlang", "Triangular", "Gamma", "Weibull"), 
              title="Please select which distribution from which to generate random variates. ")
  
  q <- as.integer(readline(prompt = "Please enter the number of random variates you would like generated: "))

#################################################################  
  #Bernoulli
  if (dst == 1){
    p <- as.numeric(readline(prompt = "Please enter the probability of success: "))
    std.unif <- unif(seed.number, q)
    #RV Generation
    RV <- as.integer(std.unif <= p)
#################################################################     
  #Binomial
  } else if ( dst == 2){
    n <- as.numeric(readline(prompt = "Please enter the number of Bernoulli trials: "))
    p <- as.numeric(readline(prompt = "Please enter the probability of success: "))
    #RV Generation
    RV <- numeric(q)
    for (j in 1:q){
      std.unif <- unif(sample.int(1, n=(2^(16))), n)
      #Bernoulli
      RV.b <- as.integer(std.unif <= p)
      RV[j] <- sum(RV.b)
    }
#################################################################     
  #Geometric  
  } else if (dst == 3){
    p <- as.numeric(readline(prompt = "Please enter the probability of success: "))
    #RV Generation
    std.unif <- unif(seed.number, q)
    RV <- ceiling(log(std.unif)/(log(1-p)))
################################################################# 
    #################################################################
  #Poisson
  } else if (dst == 4){
    lambda <- as.numeric(readline(prompt = "Please enter lambda: "))
    RV <- numeric(q)
    #RV Generation
    a <- exp(-lambda)
    RV <- numeric(q)
    for (i in 1:q){
      p <- 1
      X <- -1
      while (p >= a){
        std.unif <- unif(sample.int(1, n=(2^(16))),1)
        p<-p*std.unif
        X<- X+1
      }
      RV[i] <- X
    }
###########################################################   
  #Uniform  
  } else if (dst == 5){
    #Uniform
    a <- as.numeric(readline(prompt = "Please enter the lower bound: "))
    b <- as.numeric(readline(prompt = "Please enter the upper bound: "))
    #RV Generation
    std.unif <- unif(seed.number, q)
    RV <- ((b-a)*std.unif) + a
#################################################################  
  #Exponential
  } else if (dst == 6){
    lambda <- as.numeric(readline(prompt = "Please enter lambda: "))
    #RV Generation
    std.unif <- unif(seed.number,q)
    RV <- (-1/lambda)*log(1-std.unif)
#################################################################  
  #Normal
  } else if (dst == 7){
    #Normal
    mu <- as.numeric(readline(prompt = "Please enter the mean: "))
    sigma <- as.numeric(readline(prompt = "Please enter the standard deviation: "))
    #RV Generation
    w<- q/2
    u1 = unif(seed.number, w)
    u2 = unif(seed.number*25, w)
    
    z1=rep(0,w)
    z2=rep(0,w)
    
    for (i in 1:w){
      z1[i] = sqrt(-2*log(u1[i]))*cos(2*pi*u2[i])
      z2[i] = sqrt(-2*log(u1[i]))*sin(2*pi*u2[i])
    }
    std.RV <- c(z1,z2)
    RV <- mu + sigma*std.RV
#################################################################  
  } else if (dst == 8){
    #Erlang
    k <- as.numeric(readline(prompt = "Please enter k: "))
    lambda <- as.numeric(readline(prompt = "Please enter lambda:  "))
    RV <- numeric(q)
    #RV Generation
    for (i in 1:q){
      std.unif <- unif(sample.int(1, n=(2^(16))), k)
      RV[i] <-(-1/lambda)*log(prod(std.unif))
    }
################################################################# 
  } else if (dst == 9){
    #Triangular
    a <- as.numeric(readline(prompt = "Please enter the lower bound: "))
    b <- as.numeric(readline(prompt = "Please enter the upper bound: "))
    c <- as.numeric(readline(prompt = "Please enter the mean: "))
    #RV Generation
    std.unif <- unif(seed.number, q)
    RV <- numeric(q)
    Fc <- (c-a)/(b-a)
    for (i in 1:q) {
      if (std.unif[i] < Fc){
        RV[i] <- a+(std.unif[i]*(b-a)*(c-a))^.5
      } else {
        RV[i] <- b-((1-std.unif[i])*(b-a)*(b-c))^.5
      }
    }
################################################################# 
  } else if (dst == 10){
    #Gamma
    alpha <- as.numeric(readline(prompt = "Please enter alpha:  "))
    beta <- as.numeric(readline(prompt = "Please enter the shape parameter (integers only): "))
    RV <- numeric(q)
    #RV Generation
    for (i in 1:q){
      std.unif <- unif(seed.number*i, beta)
      RV[i] <- (-alpha)*log(prod(std.unif))
    }
#################################################################
  } else if (dst == 11){
    #Weibull
    lambda <- as.numeric(readline(prompt = "Please enter lambda:  "))
    beta <- as.numeric(readline(prompt = "Please enter beta: "))
    #RV Generation
    std.unif <- unif(seed.number, q)
    RV <- (1/lambda)*(-log(1-std.unif))^(1/beta)
  }
  return(RV)
}

RV <- RVG()

#Graph
RV.df <- data.frame(RV)
ggplot(RV.df, aes(x=RV)) + 
  geom_histogram(binwidth = .1, colour = 'black', fill = 'cyan')



