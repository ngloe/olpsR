#### roxygen2 comments ################################################
#
#' Buy-and-Hold best asset (BHbest)
#' 
#' copmutes the portfolio consisting only of the best asset. 
#' 
#' @param returns Matrix of price relatives, i.e., the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
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
#' # load data
#' data(NYSE)
#' # select stocks
#' returns = cbind(comme=NYSE$comme, kinar=NYSE$kinar)
#' 
#' # calculate best Buy-and-Hold portfolio
#' BHbest = alg_BHbest(returns)
#' BHbest
#' BHbest$Wealth
#' 
#' @export
#' 
#########################################################################
alg_BHbest <- function(returns){
  alg <-"BHbest"
  x   <- as.matrix(returns)
  b   <- rep(0, ncol(x))
  # Wealth of assets
  S_assets <- apply(x, 2, prod)
  # find asset b that achieves max wealth S
  b[which(S_assets==max(S_assets))] <- 1
  # Wealth
  S   <- get_wealth(x, b)
  # create OLP object
  ret <- h_create_OLP_obj(alg, x, b, S)
  return(ret)
}
