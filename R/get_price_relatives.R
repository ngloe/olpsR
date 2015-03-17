# --- FUNCTION PriceRel ---------------------------------------
#
# Usage:    get_price_relatives(prices)
# Purpose:  calculates the price relatives (ratio of the asset 
#           price at t and the asset price at t-1)
# Input:    Object (Vector, Matrix, zoo) of Asset-Prices
# Output:   Matrix of price relatives
#
# -------------------------------------------------------------


#### roxygen2 comments ################################################
#
#' Get price relatives
#' 
#' calculates the price relatives of according asset prices; that is the 
#' closing (opening) price at time t divided by the closing (opening) 
#' price at time t-1.
#' 
#' @param prices Matrix of asset prices, where each column represents
#'               an asset.
#' 
#' @return Matrix of price relatives
#'  
#' @examples 
#' # load stock prices, for more information see quantmod-package
#' library(quantmod)
#' getSymbols("SPY", src="yahoo")
#' # closing prices
#' prices <- Cl(SPY)
#' # get price relatives
#' get_price_relatives(prices)
#' 
#' @export
#' 
#########################################################################
get_price_relatives <- function(prices){
  if(is.vector(prices)){
    returns_log <- diff(log(prices))
    price_relatives <- exp(returns_log)
  }
  else
  {
    #log-returns:
    returns_log <- apply(log(prices), 2, diff)
    # price relatives
    price_relatives <- apply(returns_log, 2, exp)
  }
  
  return(price_relatives)
}
