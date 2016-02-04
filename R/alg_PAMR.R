#### roxygen2 comments ####################################################
#
#' Passive Aggressive Mean Reversion Algorithm (PAMR)
#' 
#' computes the Passive Aggressive Mean Reversion algorithm
#' by Li et al. 2012
#' 
#' @param returns Matrix of price relatives, i.e. the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param epsilon sensitivity parameter
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
#' @details The idea of \code{PAMR} is to exploit the mean-reversion property 
#' of asset prices. Based on a loss function \code{PAMR} passively maintains 
#' the last portfolio if the loss is zero and otherwise aggressively aproaches 
#' a new portfolio that can force the loss to be zero.
#' 
#' As the algorithm can lead to negative portfolio weights which are not 
#' permitted by the definition of on-line portfolio selection a simplex 
#' projection step is needed. The simplex projection is implemented according 
#' to Duchi et al. 2008 (see also \code{\link{projsplx}}).
#' 
#' @references 
#' Li, B.; Zhao, P.; Hoi, S. C. H. & Gopalkrishnan, V. 
#' PAMR: Passive aggressive mean reversion strategy for portfolio selection,
#' Machine Learning, 2012
#' 
#' Duchi, J.; Shalev-Shwartz, S.; Singer, Y. & Chandra, T. 
#' Efficient projections onto the l 1-ball for learning in high dimensions, 
#' Proceedings of the 25th international conference on Machine learning, 2008
#' 
#' @examples 
#' # load data
#' data(NYSE)
#' # select stocks
#' x = cbind(kinar=NYSE$kinar, iroqu=NYSE$iroqu)
#' 
#' # compute PAMR algorithm
#' PAMR = alg_PAMR(x, epsilon=0.5)
#' plot(PAMR)
#' 
#' @export
#' 
#########################################################################
alg_PAMR = function(returns, epsilon=0.5){
  alg   <- "PAMR"
  x     <- as.matrix(returns)
  b     <- matrix(nrow=nrow(x), ncol=ncol(x))

  b <- matrix( nrow=nrow(x), ncol=ncol(x) )
  b[1,] <- rep( 1/ncol(x), ncol(x) )

  for( t in 1:(nrow(x)-1) ){
    l = b[t,] %*% x[t,] - epsilon
    l = max(0, l)
    tao = l / ( sqrt( sum( abs( x[t,] - mean( x[t,] ) )^2 ) ) )^2
    # What if denominator = 0:
    if( !(tao==Inf) ){
      # calc new portfolio: negative weights allowed!
      b_tmp <- b[t,] - tao * ( x[t,] - mean(x[t,]) )
      # Normalize portfolio to non-negative weights
      b[t+1,] = projsplx(b_tmp)
    } else {
      b[t+1,] = b[t,]
    }
  }
  
  # Wealth
  W <- get_wealth(x, b)
  
  # create OLP object
  ret <- h_create_OLP_obj(alg, x, b, W)
  return(ret)  
}
