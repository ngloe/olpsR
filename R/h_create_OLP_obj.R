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
  # annualized log-return
  r  <- gr[length(gr)] * 252
  # annualized return
  R  <- exp(r)-1
  # annualized portfolio risk (volatility risk)
  x = get_price_relatives(wealth)
  risk = sd(x) * sqrt(252)
  
  ret <- list(Alg=alg,
              Names=colnames(returns), 
              Weights=weights, 
              Wealth=wealth,
              GrowthRate=gr,
              Return=R,
              Risk=risk)
  class(ret) <- "OLP"
  return(ret)  
}
