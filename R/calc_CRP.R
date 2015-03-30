# --- FUNCTION calc_CRP ------------------------------------#
#
# Usage:    calc_CRP(returns, weights)
# Purpose:  calculates the constant rebalanced portfolio (CRP) 
#           for given weights
# Input:    returns --> Matrix; relative returns (the ratio of 
#                       the closing (opening) price today and 
#                       the day before)
#           weights --> vector containing portfolio weights
# Output:   object of class OLP, containing 
#           - algorithm name
#           - weights
#           - wealth
#           - growth rate
#           - expected annual log-return (return)
#           - standard deviation of exp. ann. log-return (risk)
#
#----------------------------------------------------------#


#### roxygen2 comments ################################################
#
#' Constant Rebalanced Portfolio Algorithm (CRP)
#' 
#' computes the constant rebalanced portfolio algorithm (CRP) 
#' 
#' @param returns Matrix of price relatives, i.e., the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param weights vector containing portfolio weights
#' 
#' @return Object of class OLP containing
#'         \item{Alg}{Name of the Algorithm}
#'         \item{Names}{vector of asset names in the portfolio}
#'         \item{Weights}{calculated portfolio weights as a vector}
#'         \item{Wealth}{wealth achieved by the portfolio as a vector}
#'         \item{GrowthRate}{exponential growth rate achieved by the portfolio as a vector}
#'         \item{Return}{annualized portfolio return (252 trading days)}
#'         \item{Risk}{portfolio risk defined as the annualized standard deviation of returns (252 trading days)}
#'         \item{APY}{annualized percantage yield (252 trading days)}
#'         \item{MDD}{maximum draw down (downside risk)}
#'         see also \code{\link{print.OLP}}, \code{\link{plot.OLP}}
#'  
#' @note The print method for \code{OLP} objects prints only a short summary.
#' 
#' @examples 
#' library(OLPS)
#' # load data
#' data(NYSE)
#' # select stocks
#' returns <- NYSE[,c("kinar", "iroqu")]
#' weights <- c(0.5, 0.5)
#'  
#' # calculate Constant Rebalanced Portfolio
#' CRP <- calc_CRP(returns, weights)
#' CRP
#' plot(CRP$Wealth, type="l")
#' plot(CRP$GrowthRate, type="l")
#' 
#' @export
#' 
#########################################################################
calc_CRP <- function(returns, weights){
  alg <- "CRP"
  # if naive diversification: ALG-name = UCRP
  if( weights[1] == 1/ncol(returns) ){
    alg <- "UCRP"
  }
  x   <- as.matrix(returns)
  b   <- weights
  b   <- matrix( rep(b, nrow(x)), nrow=nrow(x), ncol=ncol(x), byrow=TRUE)
  # Wealth
  S   <- get_wealth(x, b)
  # create OLP object
  ret <- h_create_OLP_obj(alg, x, b, S)
  return(ret)
}
