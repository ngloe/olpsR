# ============================================================================ #
# CWMR Algorithm
#
# Li, B.; Hoi, S. C. H.; Zhao, P. & Gopalkrishnan, V.
# Confidence Weighted Mean Reversion Strategy for Online Portfolio Selection
# 2013
#
# Variant: deterministic CWMR-Var 
# ============================================================================ #

#### roxygen2 comments ####################################################
#
#' Confidence Weighted Mean Reversion Algorithm (CWMR)
#' 
#' computes the Confidence Weighted Mean Reversion algorithm
#' by Li et al. 2013
#' 
#' @param returns Matrix of price relatives, i.e. the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param phi confidence parameter (typical values are 1.28, 1.64, 1.95, 2.57
#'            corresponding to a confidence level of 80\%, 90\%, 95\%, 99\%)                
#' @param epsilon sensitivity parameter (typically \eqn{\in [0,1]})
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
#' @details Li et al. provide different versions of their CWMR algorithm. The 
#' implemented version is \code{deterministic CWMR-Var}. Also CWMR requires a
#' normalization step to ensure that the portfolio weights satisfy the 
#' assumptions of on-line portfolio selection (no negative weights). It is 
#' implemented as a siomplex projection according to Chen and Ye 2011.
#' 
#' @references 
#' Li, B.; Hoi, S. C. H.; Zhao, P. & Gopalkrishnan, V. 
#' Confidence Weighted Mean Reversion Strategy for Online Portfolio Selection,
#' ACM, 2013
#' 
#' Chen, Y. & Ye, X. 
#' Projection Onto A Simplex, 
#' ArXiv e-prints, 2011
#' \url{http://arxiv.org/abs/1101.6081v2}
#' 
#' @examples 
#' # load data
#' data(NYSE)
#' # select stocks
#' x = cbind(kinar=NYSE$kinar, iroqu=NYSE$iroqu)
#' 
#' # calculate CWMR algorithm
#' CWMR = alg_CWMR(x, phi=1.96, epsilon=0.5); CWMR
#' plot(CWMR)
#' 
#' @export
#' 
#########################################################################
alg_CWMR = function(returns, phi, epsilon){
  alg = "CWMR"
  x   = as.matrix(returns)
  # number of assets
  m = ncol(x)
  # investment horizon
  t_max = nrow(x)
  
  # Initialization:
  mu          = rep(1/m, m)
  sigma       = 1/(m^2) * diag(1, m, m)
  weights     = matrix(nrow=t_max, ncol=m)
  weights[1,] = mu
    
  for( t in 1:(t_max-1) ){
    # Step 1: calculate variables
    unitvec = rep(1, m)
    M       = t(mu) %*% x[t,]
    V       = t(x[t,]) %*% sigma %*% x[t,]
    W       = t(x[t,]) %*% sigma %*% unitvec
    x_bar   = ( t(unitvec) %*% sigma %*% x[t,] ) / ( t(unitvec) %*% sigma %*% unitvec )
    #x_bar   = mean(x[t,])

    # Step 2: update portfolio distribution (using CWMR-Var)
    # calculate lambda:
    # Let
    a = 2*phi*V^2 - 2*phi*x_bar*V*W
    b = 2*phi*epsilon*V - 2*phi*V*M + V - x_bar*W
    c = epsilon - M - phi*V
    # with
    sqr_tmp = b^2 - 4*a*c
    if( sqr_tmp >= 0 & a != 0 ){
      y1 = (-b + sqrt( sqr_tmp )) / (2*a)
      y2 = (-b - sqrt( sqr_tmp )) / (2*a)
      lambda = max( y1, y2, 0)
    } else if( b != 0 ){
      y3 = -c/b  
      lambda = max( y3, 0)
    } else {
      lambda = 0  
    }
    # calculate new mu and sigma
    mu = mu - lambda * sigma %*% (x[t,] - x_bar * unitvec)
    sigma = solve( solve(sigma) + 2*lambda*phi*diag(x[t,])^2 )
    
    # Step 3: normalize mu and sigma
    mu = projsplx(mu)
    sigma = sigma / ( m * sum(diag(sigma)) )
    
    # update portfolio
    weights[t+1,] = mu
  }

  # Wealth
  W <- get_wealth(x, weights)

  # create OLP object
  ret <- h_create_OLP_obj(alg, x, b, W)
  return(ret)  
}

