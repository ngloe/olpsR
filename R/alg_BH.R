#### roxygen2 comments ################################################
#
#' Buy-and-Hold (BH)
#' 
#' computes Buy-and-Hold portfolio for given weigths.
#' 
#' @param returns Matrix of price relatives, i.e., the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param weights vector of portfolio weights for the Buy-and-Hold portfolio
#' 
#' @return Object of class OLP containing
#'         \item{Alg}{Name of the Algorithm}
#'         \item{Names}{vector of asset names in the portfolio}
#'         \item{Weights}{calculated portfolio weights as a vector}
#'         \item{Wealth}{wealth achieved by the portfolio as a vector}
#'         \item{mu}{exponential growth rate}
#'         \item{APY}{annual percantage yield (252 trading days)}
#'         \item{sigma}{standard deviation of exponential growth rate}
#'         \item{ASTDV}{annualized standard deviation (252 trading days)}
#'         \item{MDD}{maximum draw down (downside risk)}
#'         \item{SR}{Sharpe ratio}
#'         \item{CR}{Calmar ratio}
#'         see also \code{\link{print.OLP}}, \code{\link{plot.OLP}}
#'  
#' @note The print method for \code{OLP} objects prints only a short summary.
#'       
#' @examples 
#' # load data
#' data(NYSE)
#' # select stocks
#' returns = cbind(comme=NYSE$comme, kinar=NYSE$kinar)
#' # portfolio weights
#' weights = c(0.5, 0.5)
#' 
#' # compute Buy-and-Hold portfolio
#' BH = alg_BH(returns, weights)
#' BH
#' BH$Wealth
#' 
#' @export
#' 
#########################################################################
alg_BH <- function(returns, weights){
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
