#### roxygen2 comments ####################################################
#
#' Peservation Price Policy for Portfolio Selection (RPP)
#' 
#' computes the Reservation Price Policy Algorithm by El-Yaniv applied to the 
#' portfolio selection problem
#'  
#' @param returns Matrix of price relatives, i.e. the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param PR preemption rule: possible values are \code{"uni"} and \code{"maxQ"}.
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
#' @details 
#' The idea of \code{RPP} is to decide for each asset whether to convert it into another asset at at each time 
#' instant t = 1, ..., T based the Reservation Price algorithm by El-Yaniv. For more details see Gloeckner et al.
#' 
#' @references 
#' El-Yaniv, R.: Competitive Solutions for Online Financial Problems. In: ACM Comput. Surv. 30.1 (Mar. 1998), pp. 28-69.
#' 
#' Gloeckner, N.; Dochow, R.; Schmidt, G.: Reservation Price Policy for the Conversion and
#' Portfolio Selection Problem, working paper, 2016.
#' 
#' @examples 
#' # load data
#' data(NYSE)
#' # select stocks
#' x = cbind(kinar=NYSE$kinar, iroqu=NYSE$iroqu)
#' 
#' # compute RPP algorithm
#' RPP = alg_RPP_theoretical(x); RPP
#' plot(RPP)
#' 
#' @export
#' 
#########################################################################
alg_RPP_theoretical = function(returns, PR="uni"){
  alg   <- "RPP_theoretical"
  x = as.data.frame(returns)
  q = get_asset_prices(x)
  n = ncol(q)
  H = nrow(x)
  # calculate conversion rates
  Q = get_conversion_rates(q[2:nrow(q),])  
  
  #### Base and counter assets ####
  
  # (1) Conversion criterion - Reservation Price
  Q_rp = matrix(nrow=n, ncol=n)
  for(i in 1:n){
    for(j in 1:n){
      M = max(Q[i,j,1:H])
      m = min(Q[i,j,1:H])
      Q_rp[i,j] = sqrt(M*m)
    }
  }
  
  # (2) determine base and counter assets
  # counter assets
  C = array(dim=c(n,n,H))
  for(t in 1:H){
    C[,,t] = (Q[,,t] >= Q_rp)
  }

  
  if(PR=="maxQ"){
    # conversion rates of counter assets only, i.e., set to zero if not counter asset
    C_tmp = C * Q  
    # number of counter assets with highest conversion rate. Each row represents the
    # number of assets with max conversion rates for converting A_i to A_j, where j=1,...,n
    no_Q_max = apply(C_tmp, c(3,1), function(y) sum(y==max(y)))
    # determine preemption factor
    gamma = array(dim=c(n,n,H))
    for(t in 1:H){
      for(i in 1:n){
        for(j in 1:n){
          if(C_tmp[i,j,t] == max(C_tmp[i,,t])){
            gamma[i,j,t] = 1/no_Q_max[t,i]
          }else{
            gamma[i,j,t] = 0
          }
        }
      }
    }
  }
  
  # PR = uni
  if(PR=="uni"){
    # number of counter assets
    no_counter_assets = apply(C, c(3,1), function(y) sum(y, na.rm=TRUE))
    gamma = array(dim=c(n,n,H))
    for(t in 1:H){
      for(i in 1:n){
        for(j in 1:n){
          if(C[i,j,t] == TRUE){
            gamma[i,j,t] = 1/no_counter_assets[t,i]
          }else{
            gamma[i,j,t] = 0
          }
        }
      }
    }
  }
  
  
  # (3) determine b
  b = matrix(nrow=H, ncol=n)
  b[1,] = rep(1/n, n)
  for(t in 1:(H-1)){
    b_tmp = matrix(nrow=n, ncol=n)
    # b_t after the market has revealed prices
    b_bh = (b[t,] * x[t,]) / sum(b[t,] * x[t,])
    for(i in 1:n){
      for(j in 1:n){
        b_tmp[i,j] = gamma[j,i,t] * b_bh[j]
      }
      # new b
      b[t+1,i] = sum(b_tmp[i,])
    }
  }
  
  # Wealth
  S <- get_wealth(x, b)
  
  # create OLP object
  ret <- h_create_OLP_obj(alg, x, b, S)
  return(ret)
  
}
