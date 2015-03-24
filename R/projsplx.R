# ====================================== #
# Projection onto a simplex
# Yunmei Chen, Xiaojing Ye
# Paper link: 
#  http://ufdc.ufl.edu/IR00000353/
#  http://arxiv.org/abs/1101.6081
#
#### roxygen2 comments ################################################
#
#' Projection onto a simplex
#' 
#' computes the projection of a vector onto the simplex 
#' \eqn{\Delta^n}
#' 
#' @param y vector to project onto the simplex
#' 
#' @return Vector
#'  
#' @details The algorithm is based on a mini-paper by Chen and Ye (see refereneces)
#'
#' @references 
#' Yunmei Chen, Xiaojing Ye 2011. Projection Onto A Simplex
#' \url{http://arxiv.org/abs/1101.6081v2}
#'       
#' @examples 
#' library("OLPS")
#' y = runif(100, -10, 10)
#' projsplx(y)
#' 
#' @export
#' 
#########################################################################
projsplx = function(y){
  n = length(y)
  s = sort(y, decreasing = TRUE)
  tmpsum = cumsum(s[1:(n-1)])
  tmp = ( tmpsum - 1 ) / (1:(n-1))
  ind = which( tmp >= s[2:n] )[1]
  if( !is.na(ind) ){
    t = tmp[ind]
  } else {
    t = ( tmpsum[n-1] + s[n] - 1 ) / n
  }
  x = apply(cbind( y-t, 0 ), 1, max)
  return(x)
}

