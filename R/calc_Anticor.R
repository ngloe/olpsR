# ---- Anticor Algorithm (Borodin et al. 2004) -------------------------- #
#
#### roxygen2 comments ####################################################
#
#' Anticor Algorithm
#' 
#' computes the Anticor algorithm by Borodin et al. 2004
#' 
#' @param returns Matrix of price relatives, i.e. the ratio of the closing
#'                (opening) price today and the day before (use function 
#'                \code{get_price_relatives} to calculate from asset prices).
#' @param w window size (\code{\eqn{w \ge 2}})
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
#' @details The idea of \code{Anticor} is to exploit the mean-reversion property 
#' of asset prices. Based on two consecutive market windows of size \code{w} 
#' wealth is transferred from asset i to asset j if the growth rate of asset i
#' is greater than the growth rate of asset j in the most recent window. 
#' Additionally, the correlation between asset i in the second last window 
#' and asset j in the last window must to be positive. The amount of wealth 
#' transferred from asset i to j depends on the strength of correlation between
#' the assets and the strength of "self-anti-correlations" between each asset i.
#' 
#' @references 
#' Borodin, A.; El-Yaniv, R. & Gogan, V. 
#' Can we learn to beat the best stock,
#' Journal of Artificial Intelligence Research, 2004
#' \url{http://arxiv.org/abs/1107.0036}
#'  
#' @examples 
#' library(OLPS)
#' # load data
#' data(NYSE)
#' # select stocks
#' x <- cbind(iroqu=NYSE$iroqu, kinar=NYSE$kinar)
#' 
#' # calculate Anticor algorithm
#' Anticor <- calc_Anticor(x, 30)
#' plot(Anticor)
#' 
#' @export
#' 
#########################################################################
calc_Anticor = function(returns, w){
  # Input
  alg = "Anticor"
  x   = as.matrix(returns)
  
  # initialize portfolio b
  b = matrix( nrow=nrow(x), ncol=ncol(x) )
  b[1,] = rep(1/ncol(x), ncol(x))
  
  for( t in 1:(nrow(x)-1) ){
    
    if( t<(2*w) ){
      
      # return current portfolio
      b[t+1,] = 1/(b[t,] %*% x[t,]) * b[t,] * x[t,]    
      #b[t+1,] = b[t,]
      next
      
    } else {
      
      # compute LX1 and LX2
      LX1 = log( x[ ( t-2*w+1 ):( t-w ), ] )
      LX2 = log( x[ ( t-w+1 ):( t ), ] )
      
      # averages of columns of LX
      mu_LX1 = apply(LX1, 2, mean)
      mu_LX2 = apply(LX2, 2, mean)
      # standard deviations of columns of LX
      #sigma_LX1 = apply(LX1, 2, sd)
      #sigma_LX2 = apply(LX2, 2, sd)
      # calculate M_cov
      #M_cov = matrix( nrow=ncol(b), ncol=ncol(b) )
      #for( i in 1:nrow(M_cov) ){
      #  for( j in 1:ncol(M_cov) ){
      #    M_cov[i,j] = 1/(w-1) * ( LX1[,i] - mu_LX1[i] ) %*% ( LX2[,j] - mu_LX2[j] )
      #  }
      #}
      #M_cov = cov(LX1, LX2)
      
      # calculate M_cor
      #M_cor = matrix( nrow=ncol(b), ncol=ncol(b) )
      #for( i in 1:nrow(M_cor) ){
      #  for( j in 1:ncol(M_cor) ){
      #    num = M_cov[i,j]
      #    denom = sigma_LX1[i] * sigma_LX2[j]
      #    if( denom==0 ){
      #      M_cor[i,j] = 0
      #    } else {
      #      M_cor[i,j] = num / denom  
      #    }
      #  }
      #}
      M_cor = suppressWarnings( cor(LX1, LX2) )
      # if sd=0 set cor=0
      M_cor[is.na(M_cor)] = 0
      
      # calculate claims
      claim = matrix(0, nrow=ncol(b), ncol=ncol(b) )
      for( i in 1:nrow(claim) ){
        for( j in 1:ncol(claim) ){
          if( (mu_LX2[i] >= mu_LX2[j]) & (M_cor[i,j] > 0) ){
            claim[i,j] = M_cor[i,j] - min( 0, M_cor[i,i] ) - min( 0, M_cor[j,j] )  
          } 
        }
      }
      
      # calculate transfers
      transfer = matrix(0, nrow=ncol(b), ncol=ncol(b) )
      for( i in 1:nrow(transfer) ){
        claim_total = sum( claim[i,] )
        if( claim_total != 0 ){
          for( j in 1:ncol(transfer) ){  
            transfer[i,j] = b[t,i] * claim[i,j] / claim_total
          }
        }
      }
      
      # update portfolio
      b_c = 1/(b[t,] %*% x[t,]) * b[t,] * x[t,]
      for( i in 1:ncol(b) ){
        b[t+1,i] = b_c[i] - sum(transfer[i,]) + sum(transfer[,i])
      }
      
    } 
  }
  
  # calc wealth
  W = get_wealth(x,b)
  
  # crreate OLP object
  ret <- h_create_OLP_obj(alg, x, b, W)
  
  return(ret)
}


