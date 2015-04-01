t#### roxygen2 comments ################################################
#
#' Get asset prices from price relatives
#' 
#' calculates the asset prices of according price relatives; that is the 
#' cumulative product of the price relatives 
#' 
#' @param x Vector or matrix of price relatives
#' 
#' @return Vector or matrix of prices
#'  
#' @examples 
#' # load return data (price relatives)
#' data(NYSE)
#' # get asset prices
#' get_asset_prices(NYSE$kinar)
#' 
#' @export
#' 
#########################################################################
get_asset_prices <- function(x){
  if(is.vector(x)){
    p <- c(1, cumprod(x))
  }
  else
  {
    p <- apply(x, 2, cumprod) 
    p <- rbind(rep(1, ncol(x)), p)
  }
  return(p)
}
