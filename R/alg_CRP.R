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
#' weights = c(0.5, 0.5)
#'  
#' # compute Constant Rebalanced Portfolio
#' CRP = alg_CRP(returns, weights); CRP
#' plot(CRP)
#' plot(CRP$Weights[,1], type="l")
#' 
#' @export
#' 
#########################################################################
alg_CRP <- function(returns, weights){
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
