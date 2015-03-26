# --- FUNCTION calc_BAH --------------------------------
#
# Usage:    calc_BH(returns, weights)
# Purpose:  calculates Buy-and-Hold portfolio for given weigths
# Input:    returns --> Matrix; price relatives (the ratio of 
#                       the closing (opening) price today and 
#                       the day before)
# Output:   object of class OLP, containing 
#           - algorithm name
#           - weights
#           - wealth
#           - growth rate
#           - expected annual log-return (return)
#           - standard deviation of exp. ann. log-return (risk)
#
#----------------------------------------------------------


#### roxygen2 comments ################################################
#
#' Buy-and-Hold (BH)
#' 
#' calculates Buy-and-Hold portfolio for given weigths.
#' 
#' @param returns Matrix of price relatives, i.e., the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param weights vector of portfolio weights for the Buy-and-Hold portfolio
#' 
#' @return Object of class OLP containing
#'         \item{Alg}{Name of the Algorithm,}
#'         \item{Names}{vector of asset names in the portfolio,}
#'         \item{Weights}{calculated portfolio weights as a vector,}
#'         \item{Wealth}{wealth achieved by the portfolio as a vector,}
#'         \item{GrowthRate}{growth rate achieved by the portfolio as a vector,}
#'         \item{Return}{expected annual log-return,}
#'         \item{Risk}{standard deviation of log returns (annualized).}
#'  
#' @note The print method for \code{OLP} objects prints only a short summary.
#'       
#' @examples 
#' library(OLPS)
#' # load data
#' data(NYSE)
#' # select stocks
#' returns <- NYSE[,c("kinar", "iroqu")]
#' # portfolio weights
#' weights <- c(0.5, 0.5)
#' 
#' # calculate Buy-and-Hold portfolio
#' BH <- calc_BH(returns, weights)
#' BH
#' BH$Wealth
#' 
#' @export
#' 
#########################################################################
calc_BH <- function(returns, weights){
  alg <- "BH"
  x   <- as.matrix(returns)
  b   <- weights
  # Wealth of assets
  S_assets <- apply(x, 2, cumprod)
  # Wealth
  S <- rowSums(S_assets * b)
  S <- c(1, S)
  # crreate OLP object
  ret <- h_create_OLP_obj(alg, x, b, S)
  return(ret)
}
