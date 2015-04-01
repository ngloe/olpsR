#### roxygen2 comments ################################################
#
#' Get portfolio wealth
#' 
#' calculates the achieved cumulative wealth of a steadily rebalanced
#' portfolio
#' 
#' @param returns Matrix of price relatives, i.e. the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param weights vector or matrix containing portfolio weights.
#' 
#' @return vector of the portfolio's cumulative wealth
#' 
#' @examples 
#' # load data
#' data(NYSE)
#' # select stocks
#' x = cbind(comme=NYSE$comme, kinar=NYSE$kinar)
#' # specify portfolio weights
#' b = c(0.05, 0.05)
#' # calculate wealth
#' W = get_wealth(x, b); W
#'  
#' @export
#' 
#########################################################################
get_wealth <- function(returns, weights){
  x <- as.matrix(returns)
  if(is.vector(weights)){
    b <- matrix(rep(weights, nrow(x)), nrow=nrow(x), byrow=TRUE)
  }
  else{
    b <- weights  
  }
  S <- cumprod(rowSums(b*x))
  S <- c(1, S)
  return(S)
}
