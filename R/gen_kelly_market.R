# --- FUNCTION gen_kelly_market() ---------------------------------------
#
# Usage:    gen_kelly_market(no_assets, t, step=0.01, ret="x")
# Purpose:  generates a Kelly-market, where all assets are decreasing, except one which remains constant.
# Input:    no_assets--> number of assets
#           t        --> number of periods
#           step     --> step by which the return (price relative) of asset A_i differs from asset A_(i+1)
#           ret      --> return method: specifies whether returns (price relatives) (ret="x") or prices (ret="q")
#                        are returned
# Output:   Matrix with asset prices or returns (price relatives)
#
#-------------------------------------------------------------------------


#### roxygen2 comments ################################################
#
#' Generate Kelly-market
#' 
#' generates a Kelly-market, where all assets are decreasing, except one which remains constant.
#' 
#' @param no_assets number of assets
#' @param t number of periods
#' @param step step by which the return (price relative) of asset \eqn{A_i} differs from asset \eqn{A_(i+1)}
#' @param ret return method: specifies whether returns (price relatives) (\code{ret="x"}) or prices (\code{ret="q"}) are returned
#' 
#' @return Matrix with asset prices or returns (price relatives)
#' 
#' @examples 
#' gen_kelly_market(3, 100)
#' gen_kelly_market(5, 1000, ret="q")  
#' 
#' @export
#' 
#########################################################################
gen_kelly_market = function(no_assets, t, step=0.01, ret="x"){
  
  n = no_assets
  x_min = 1-(n*step)  
  
  x_t = seq(1, x_min, length.out = n) 
  x = matrix(rep(x_t, t), nrow = t, byrow=TRUE)
  x_tmp = rbind(rep(1, n), x[1:(t-1),])
  q = apply(x_tmp, 2, cumprod)
  
  if(ret=="x"){
    return(x[2:t,])
  }else if(ret=="q"){
    return(q)
  }else{
    cat("ERROR: choose proper return method ret")
  }
}
