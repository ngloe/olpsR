#### roxygen2 comments ################################################
#
#' Exponential Gradient Algorithm (UP)
#' 
#' computes the Exponential Gradient Algorithm by Helmbold et al., 1998
#' 
#' @param returns Matrix of price relatives, i.e. the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param eta learning rate          
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
#' @references 
#' Helmbold, D. P.; Schapire, R. E.; Singer, Y. & Warmuth, M. K.,
#' On-Line Portfolio Selection Using Multiplicative Updates, 
#' Mathematical Finance, Blackwell Publishers Inc, 1998, 8, 325-347
#' 
#' @examples 
#' # load data
#' data(NYSE)
#' # select stocks
#' returns = cbind(kinar=NYSE$kinar, iroqu=NYSE$iroqu)
#' 
#' # compute Exponential Gradient algorithm
#' EG = alg_EG(returns, eta=0.05)
#' 
#' # plot portfolio wealth
#' plot(EG)
#' # plot portfolio weights of kinar
#' plot(EG$Weights[,1], type="l")
#' 
#' @export
#' 
#########################################################################
alg_EG <- function(returns, eta){
  alg   <- "EG"
  x     <- as.matrix(returns)
  w     <- matrix(nrow=nrow(x), ncol=ncol(x))
  w[1,] <- rep(1/ncol(x), times=ncol(x))
  
  for(t in 1:(nrow(x)-1)){
    w_tmp <- w[t,] * exp( (eta * x[t,]) / sum(w[t,]*x[t,]) )  
    Z     <- sum( w[t,] * exp( (eta * x[t,]) / sum(w[t,]*x[t,]) ) )
        
    w[t+1,] <- w_tmp / Z
  }
  
  # Wealth
  S <- get_wealth(x, w)

  # create OLP object
  ret <- h_create_OLP_obj(alg, x, w, S)
  return(ret)
}  


