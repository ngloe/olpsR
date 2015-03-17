# --- Function Wealth -------------------------------------
# 
# Usage:    get_wealth(Returns, weights, cr)
# Purpose:  Calculates the Wealth of given portfolio weights
# Input:    returns --> Matrix; relative Returns, that is the Ratio of the 
#                       Return today and the day before
#           weights --> Vector or Matrix
#           cr      --> commission rate charged for each transaction
#                       (both buying and selling)
# Output:   Vector of CRP Wealth
#
# Transaction costs model: Borodin, A. & El-Yaniv, R., Online computation and competitive analysis. Cambridge University Press, 1998, Chapter 14.5.4, pp. 296-302
# ---------------------------------------------------------


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
#' library(OLPS)
#' # load data
#' data(NYSE)
#' # select stocks
#' x <- NYSE[,c("kinar", "iroqu")]
#' # specify portfolio weights
#' b <- c(0.05, 0.05)
#' # calculate wealth
#' get_wealth(x, b)
#' get_wealth(x, b)
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