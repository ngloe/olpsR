#### roxygen2 comments ################################################
#
#' Volatility Timing Algorithm (VT)
#' 
#' computes the Volatility Timing Algorithm by Kirby and Ostdiek (see references).
#' 
#' @param prices Matrix of asset prices
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
#' @references
#' Kirby, C. & Ostdiek, B., It's All in the Timing: Simple Active Portfolio 
#' Strategies that Outperform Naive Diversification. Journal of Financial 
#' and Quantitative Analysis, 2012, 47, 437-467
#' 
#' @examples 
#' # load data
#' data(NYSE)
#' x = cbind(comme=NYSE$comme, kinar=NYSE$kinar)
#' q = get_asset_prices(x)
#' # compute Volatility Timing algorithm
#' VT = alg_VT(q); VT
#' plot(VT)
#' 
#' @export
#' 
#########################################################################
alg_VT <- function(prices){
  alg <- "VT"
  # Prices
  p_x <- prices
  # log-returns
  r_x <- apply(log(p_x), 2, diff)
  # mu (sample mean), var (sample variance); from period 1 to t
  # see: http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
  mu_x <- matrix(nrow=nrow(r_x), ncol=ncol(r_x))
  mu_x[1,] <- r_x[1,]
  var_x <- matrix(nrow=nrow(r_x), ncol=ncol(r_x))
  var_x[2,] <- apply(r_x[1:2,], 2, var)
  for(t in 2:nrow(mu_x)){
    # mu
    mu_x[t,] <- mu_x[t-1,] + ( (r_x[t,] - mu_x[t-1,]) / t )
    # var
    if(t > 2){
      var_x[t,] <- (t-2) / (t-1) * var_x[t-1,] + ( r_x[t,] - mu_x[t-1,] )^2 / t  
    }  
  }
  # VT-Algorithm
  b <- matrix(nrow=nrow(r_x), ncol=ncol(r_x))
  b[1:2,] <- rep(1/ncol(r_x), times=ncol(r_x))
  for( t in 3:nrow(r_x) ){
    for(i in 1:ncol(r_x)){
      b[t,i] <- 1/var_x[t-1,i] / sum( 1/var_x[t-1,] )
    }
  }
  
  # Wealth
  S <- get_wealth(get_price_relatives(p_x), b)

  # create OLP object
  ret <- h_create_OLP_obj(alg, returns=prices, b, S)
  
  return(ret)
}
