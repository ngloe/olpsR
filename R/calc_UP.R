# --- FUNCTION calc_UP ----------------------------------
#
# Usage:    calc_UP(returns, method, ...)
# Purpose:  calculates the Universal Portfolio (see: Cover 1991)
# Input:    returns --> Matrix; relative returns (the ratio of 
#                       the closing (opening) price today and 
#                       the day before)
#           method  --> Method used to calculate BCRP; posiible values:
#                       - "approx"  --> limits the set of CRPs, e.g. in the two asset
#                                       case to the portfolios of the form 
#                                       b = (b_1, 1-b_1), where b_1 runs from 
#                                       0 to 1 in steps of length "step=0.05"
#                       - "rand"    --> Calculation is approximative using random portfolios 
#                                       (see: Ishijima 2001, Numerical Methods for Universal
#                                       Portfolios (unpublished)). 
#                                       By default the number of random portfolios is 
#                                       "samplings=1000". 
#           ...   --> further arguments (samplings, step) dependend on the 
#                                       "method" argument.
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
#' Universal Portfolio Algorithm (UP)
#' 
#' approximates the Universal Portfolio Algorithm by Cover, 1991
#' 
#' @param returns Matrix of price relatives, i.e. the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param method The method used to calculate UP. "\code{rand}" generates 
#'               random CRPs to find UP. By default the number of random 
#'               portfolios is "\code{samplings=1000}". "\code{approx}" limits 
#'               the set of CRPs to the portfolios of the form \eqn{b=(b_1, 1-b_1)}, 
#'               where \eqn{b_1} runs from 0 to 1 in steps of length "\code{step=0.05}".          
#' @param ... further arguments (\code{samplings}, \code{step}) dependend 
#'            on the "\code{method}" argument.
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
#' @details For the "\code{approx}" method the calculation may require very much 
#'          memory dependend on the number of assets and the "\code{step}" argument. 
#'          If an error occurs due to memory problems the "\code{rand}" method may work.
#' 
#' @references 
#' Cover & Ordentlich 1991, Universal Portfolios. Mathematical Finance, 1991, 1, 1-29
#' 
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
#' # calculate Universal Portfolio algorithm
#' calc_UP(returns, method="rand", samplings=1000)
#' UP <- calc_UP(returns, method="approx", step=0.05)
#' plot(UP$Wealth, type="l")
#' plot(UP$GrowthRate, type="l")
#' 
#' @export
#' 
#########################################################################
calc_UP <- function(returns, method="rand", ...){
  alg     <- "UP"
  x       <- as.matrix(returns)
  # additional arguments
  addargs <- list(...)
  
  
  # verify 'method' arguement
  
  if(method=="rand"){
    # check for 'samplings' argument
    if(hasArg(samplings)){
      portfolios_weights <- gen_rand_portfolios(n_portfolios=addargs$samplings,
                                                n_assets=ncol(x))
    } 
    else{
      portfolios_weights <- gen_rand_portfolios(n_portfolios=1000, 
                                                n_assets=ncol(x)) 
    }
  }
  
  else if(method=="approx"){
    # check for 'step' argument
    if(hasArg(step)){
      portfolios_weights <- gen_sample_portfolios(n_assets=ncol(x), 
                                                  step=addargs$step)
    }
    else{
      portfolios_weights <- gen_sample_portfolios(n_assets=ncol(x)) 
    }
  }
  
  else{
    stop("Choose proper method.")
  }
  
  
  
  # Wealth of CRPs
  portfolios_wealth <- matrix(nrow=nrow(x), ncol=nrow(portfolios_weights))
  for(i in 1:nrow(portfolios_weights)){
    portfolios_wealth[,i] <- h_get_wealth_CRP(x, portfolios_weights[i,])
  }
  
  
  # calc UP weights
  b <- matrix(nrow=nrow(x), ncol=ncol(x))
  b[1,] <- rep(1/ncol(x), times=ncol(x))
  
  for(t in 2:nrow(x)){
    for(i in 1:ncol(portfolios_weights)){
      b[t,i] <- sum( portfolios_wealth[t-1,] * portfolios_weights[,i]) /
                     sum(portfolios_wealth[t-1,])
    }
  }
    
  # Wealth
  S <- get_wealth(x, b)

  # create OLP object
  ret <- h_create_OLP_obj(alg, x, b, S)
  return(ret)
}
