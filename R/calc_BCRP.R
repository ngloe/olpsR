# --- FUNCTION calc_BCRP ----------------------------------
#
# Usage:    calc_BCRP(returns, method, ...)
# Purpose:  calculates the 'best' constant rebalanced Portfolio;
# Input:    returns --> Matrix; returns as price relatives (the ratio of 
#                       the closing (opening) price today and 
#                       the day before)
#           method  --> Method used to calculate BCRP; posiible values:
#                       - "approx"  --> limits the set of CRPs, e.g. in the two asset
#                                       case to the portfolios of the form 
#                                       b = (b_1, 1-b_1), where b_1 runs from 
#                                       0 to 1 in steps of length "step=0.05"
#                       - "rand"    --> Calculation is approximative using random portfolios 
#                                       (see: Ishijima 2001, Numerical methods for Universal
#                                       Portfolios (unpublished)). 
#                                       By default the number of random portfolios is 
#                                       "samplings=1000". 
#         ...       --> further arguments (samplings, step) dependend on the 
#                       "method" argument.
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
#' Best Constant Rebalanced Portfolio Algorithm (BCRP)
#' 
#' calculates the best constant rebalanced portfolio, i.e., the constant 
#' rebalanced portfolio achieving the highest wealth in hindsight.
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
#' Ishijima 2001, Numerical Methods for Universal Portfolios
#' \url{http://www.business.uts.edu.au/qfrc/conferences/qmf2001/Ishijima_H.pdf}
#' 
#' @examples 
#' library(OLPS)
#' # load data
#' data(NYSE)
#' # select stocks
#' returns <- NYSE[,c("kinar", "iroqu")]
#' 
#' # calculate BCRP
#' calc_BCRP(returns, method="rand", samplings=1000)
#' BCRP <- calc_BCRP(returns, method="approx", step=0.05)
#' plot(BCRP$Wealth, type="l")
#' plot(BCRP$GrowthRate, type="l")
#' 
#' @export
#' 
#########################################################################
calc_BCRP <- function(returns, method="rand", ...){
  alg <- "BCRP"
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
  portfolios_wealth <- vector(length=nrow(portfolios_weights))
  for( i in 1:nrow(portfolios_weights) ){
    portfolios_wealth[i] <- h_get_wealth_CRP(x, portfolios_weights[i,])[nrow(x)]
  }
  
  
  # Find max CRP-Value at time T
  BCRP_index <- which.max(portfolios_wealth)
  # BCRP weights
  b <- portfolios_weights[BCRP_index,]
  b <- matrix( rep(b, nrow(x)), nrow=nrow(x), ncol=ncol(x), byrow=TRUE)
  
  # Wealth
  S <- get_wealth(x, b)

  # create OLP object
  ret <- h_create_OLP_obj(alg, x, b, S)
  return(ret)
}