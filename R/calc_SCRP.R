#### roxygen2 comments ################################################
#
#' Successive Constant Rebalanced Portfolio Algorithm (SCRP)
#' 
#' SCRP directly adopts the Best Constant Rebalanced Portfolio until time t.
#' 
#' @param returns Matrix of price relatives, i.e. the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param method The method used to calculate BCRP. "\code{rand}" generates 
#'               random CRPs to find BCRP. By default the number of random 
#'               portfolios is "\code{samplings=1000}". "\code{approx}" limits 
#'               the set of CRPs to the portfolios of the form \eqn{b=(b_1, 1-b_1)}, 
#'               where \eqn{b_1} runs from 0 to 1 in steps of length "\code{step=0.05}".
#' @param ... further arguments (\code{samplings}, \code{step}) dependend 
#'            on the "\code{method}" argument.
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
#' @details For the "\code{approx}" method the calculation may require very much 
#'          memory dependend on the number of assets and the "\code{step}" argument. 
#'          If an error occurs due to memory problems the "\code{rand}" method may work.
#'          
#' @references          
#' Gaivoronski & Stella 2000, Stochastic Nonstationary Optimization for Finding Universal Portfolios
#' \url{http://mpra.ub.uni-muenchen.de/21913/}
#' 
#' @examples 
#' library(OLPS)
#' # load data
#' data(NYSE)
#' # select stocks
#' returns <- cbind(comme=NYSE$comme, kinar=NYSE$kinar)
#' 
#' # calculate BCRP
#' calc_SCRP(returns, method="rand", samplings=1000)
#' SCRP <- calc_SCRP(returns, method="approx", step=0.05)
#' plot(SCRP)
#' plot(SCRP$Weights, type="l")
#' plot(SCRP$GrowthRate, type="l")
#' 
#' @export
#' 
#########################################################################

calc_SCRP <- function(returns, method="rand", ...){
  alg <- "SCRP"
  x   <- as.matrix(returns)
  
  # additional arguments
  addargs <- list(...)
  
  
  # verify 'method' arguement
  
  if(method=="approx"){
    # check 'step' argument
    if(hasArg(step)){
      portfolios_weights <- gen_sample_portfolios(n_assets=ncol(x), step=addargs$step)
    } 
    else{
      portfolios_weights <- gen_sample_portfolios(n_assets=ncol(x))
    } 
  }
  
  else if(method=="rand"){
    # check 'samplings' argument
    if(hasArg(samplings)){
      portfolios_weights <- gen_rand_portfolios(addargs$samplings, n_assets=ncol(x))
    } 
    else{
      portfolios_weights <- gen_rand_portfolios(n_portfolios=1000, n_assets=ncol(x))
    }
  } 
  
  else{
    stop("Choose proper method.")
  } 


  # calculate terminal wealth of sample portfolios
  portfolios_wealth <- matrix(nrow=nrow(x), ncol=nrow(portfolios_weights))
  for( i in 1:nrow(portfolios_weights) ){
    portfolios_wealth[,i] <- h_get_wealth_CRP(x, portfolios_weights[i,])
  }  

  # Find max CRP-Value at time t
  BCRP_ind = vector(length=nrow(portfolios_wealth))
  for( t in 1:nrow(portfolios_wealth) ){
    BCRP_ind[t] <- which.max(portfolios_wealth[t,])
  }

  # BCRP weights
  b <- portfolios_weights[BCRP_ind,]
  b <- rbind( rep( 1/ncol(x), ncol(x)), b[1:nrow(x)-1,] )
  
  # Wealth
  S <- get_wealth(x, b)

  # create OLP object
  ret <- h_create_OLP_obj(alg, x, b, S)
  return(ret)
}
