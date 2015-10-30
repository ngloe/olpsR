# --- FUNCTION gen_virtual_market() ---------------------------------------
#
# Usage:    gen_virtual_market(t, ret="x")
# Purpose:  generates the synthetic market described in [CG86]. The market consists of 
#           two assets where one remains constants and the other doubles and halfs by turns.
# Input:    t        --> number of periods
#           ret      --> return method: specifies whether returns (price relatives) (ret="x") or prices (ret="q")
#                        are returned
# Output:   Matrix with asset prices or returns (price relatives)
#
#-------------------------------------------------------------------------


#### roxygen2 comments ################################################
#
#' Generate virtual market
#' 
#' generates a virtual market consisting of two assets, where one remains constant and 
#' the other doubles and halfs by turns.
#' 
#' @param t number of periods
#' @param ret return method: specifies whether returns (price relatives) (\code{ret="x"}) or prices (\code{ret="q"}) are returned
#' 
#' @return Matrix with asset prices or returns (price relatives)
#'       
#' @details  
#' The virtual market is often used to illustrate the idea of online portfolio selection algorithms. 
#' For details see Cover and Gluss 1986 and Li and Hoi 2014.
#' 
#' @references 
#' Li, B.; Hoi, S.
#' Online Portfolio Selection: A Survey,
#' ACM Comput. Surv., 2014
#' 
#' Cover, T. M.; Gluss, D.H.
#' Empirical Bayes stock market portfolios,
#' Advances in Applied Mathematics, 1986
#' 
#' @examples 
#' gen_virtual_market(10, ret="x")
#' gen_virtual_market(10, ret="q")  
#' 
#' @export
#' 
#########################################################################
gen_virtual_market = function(t, ret="x"){
  # investment horizon
  H=t
  # returns
  x_1 = c(1,1)
  x_2 = c(2,0.5)
  
  x = cbind( rep(x_1, (H+1)/2), rep(x_2, (H+1)/2) )
  x = rbind(c(1,1), x[1:(H-1),])
  q = apply(x, 2, cumprod)
  
  if(ret=="x"){
    return(x[2:H,])
  }else if(ret=="q"){
    return(q)
  }else{
    cat("ERROR: choose proper return method ret")
  }
}
