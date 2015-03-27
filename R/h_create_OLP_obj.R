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
# ---------------------------------------------------------
h_create_OLP_obj <- function(alg, returns, weights, wealth){
  gr <- get_growth_rate(wealth)
  
  # Calculate Performance Measures
  # average log-return
  r  <- gr[length(gr)]
  # annualized return
  R  <- (exp(r)-1) * 252
  # annualized portfolio risk (volatility risk)
  x = get_price_relatives(wealth)
  risk = sd(x) * sqrt(252)
  # APY (annualized percantage yield)
  y = length(wealth) / 252
  APY = wealth[length(wealth)]^(1/y) - 1
  # MDD (maximum draw down)
  # DD (draw down; measures the decline from a historical peak in the cumulative wealth at time t)
  DD = sapply(1:length(wealth), function(t){ 
    m = max( wealth[1:t] );
    max( 0, m - wealth[t] ) / m 
  } )
  # MDD (maximum draw down)
  MDD = max(DD)
  
  ret <- list(Alg=alg,
              Names=colnames(returns), 
              Weights=weights, 
              Wealth=wealth,
              GrowthRate=gr,
              Return=R,
              Risk=risk,
              APY=APY,
              MDD=MDD)
  class(ret) <- "OLP"
  return(ret)  
}
