# --- Helper function h_get_wealth_CRP ------------------------
#
# Usage:    .Wealth.CRP(Returns, weights)
# Purpose:  Wealth of Constantly Rebalanced Portfolios
# Input:    returns --> Matrix; relative Returns, that is the Ratio of the 
#                       Return today and the day before
#           weights --> Vector (for CRP) or Matrix
# Output:   Vector of CRP Wealth
#
# ---------------------------------------------------------
h_get_wealth_CRP <- function(returns, weights){
  w_returns <- matrix(nrow=dim(returns)[1], ncol=length(weights))
  for(i in 1:length(weights)){
    w_returns[,i] <- returns[,i] * weights[i]
  }
  p_returns <- rowSums(w_returns)
  S_CRP <- cumprod(p_returns)
  return(S_CRP)
}