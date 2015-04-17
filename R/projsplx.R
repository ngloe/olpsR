# ====================================== #
# Projection onto a simplex
# Implemented according to the paper: Efficient projections onto the
# l1-ball for learning in high dimensions, John Duchi, et al. ICML 2008.
# Paper link: 
#  https://web.stanford.edu/~jduchi/projects/DuchiShSiCh08.pdf
#  https://dl.acm.org/citation.cfm?id=1390191
#
#### roxygen2 comments ################################################
#
#' Projection onto simplex
#' 
#' computes the Euclidean projection of points onto the simplex domain
#' \eqn{\Delta^n} of specified radius
#' 
#' @param v vector of points to project onto the simplex domain
#' @param b radius
#' 
#' @return Projection vector
#'  
#' @details The algorithm is implemented according to Duchi et al. 2008.
#' The original Matlab implementation by John Duchi (\email{jduchi@@cs.berkeley.edu})
#' can be found on \url{https://web.stanford.edu/~jduchi/projects/DuchiShSiCh08/ProjectOntoSimplex.m}
#'
#' @references 
#' Duchi, J.; Shalev-Shwartz, S.; Singer, Y. & Chandra, T. 
#' Efficient projections onto the l 1-ball for learning in high dimensions, 
#' Proceedings of the 25th international conference on Machine learning, 2008, 272-279
#' \url{https://dl.acm.org/citation.cfm?id=1390191}
#'       
#' @examples 
#' x = runif(100, -10, 10)
#' projsplx(x)
#' 
#' @export
#' 
#########################################################################
projsplx = function(v, b=1){
  v[v<0] = 0
  u = sort(v, decreasing = TRUE)
  sv = cumsum(u)
  
  rho = which(u > (sv-b) / (1:length(v)))
  theta = max(0, (sv[rho] - b) / rho )
  w = v - theta
  w[w<0] = 0
  return(w)
}
