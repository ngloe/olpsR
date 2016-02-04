# --- Helper function h_create_OLP_obj ------------------------
#
# Usage:    h_create_OLP_obj(alg, returns, weights, wealth)
# Purpose:  creates an object of class OLP
# Input:    alg     --> Name of the algorithm
#           returns --> Matrix; relative Returns, that is the Ratio of the 
#                       Return today and the day before
#           weights --> Vector or Matrix
#           wealth  --> wealth of algorithm
# Output:   object of class OLP
#
# Note: Performance measures are calculated according to 
#       Dochow, Leppek, Schmidt: A framework for automated performance evaluation of portfolio selection algorithms, 2005
# ---------------------------------------------------------
h_create_OLP_obj = function(alg, returns, weights, wealth){
  #gr = get_growth_rate(wealth)
  x  = get_price_relatives(wealth) 
  # log-return
  r  = log(x)
  
  # Calculate Performance Measures
  
  # exponential growth rate
  mu = mean(r)
  
  #### annual percentage yield (APY) ####
  # annualization of exponential growth rate
  y = length(wealth) / 252
  APY = tail(wealth, n=1)^(1/y) - 1
  
  # standard deviation of the exponential growth rate
  sigma = sd(r)
  
  # annualized standard deviation (ASTDV)
  ASTDV = sigma * sqrt(252)
  
  # MDD (maximum draw down)
  # DD (draw down; measures the decline from a historical peak in the cumulative wealth at time t)
  DD = sapply(1:length(wealth), function(t){ 
    m = max( wealth[1:t] );
    max( 0, m - wealth[t] ) / m 
  } )
  # MDD (maximum draw down)
  MDD = max(DD)
  
  # Sharpe ratio (SR)
  SR = APY / ASTDV
  
  # Calmar ratio (CR)
  CR = APY / MDD
  
  # create return of function
  ret <- list(Alg=alg,
              Names       = colnames(returns), 
              Weights     = weights, 
              Wealth      = wealth,
              #GrowthRate  = gr,
              mu          = mu,
              APY         = APY,
              sigma       = sigma,
              ASTDV       = ASTDV,
              MDD         = MDD,
              SR          = SR,
              CR          = CR)
  class(ret) = "OLP"
  return(ret)  
}
