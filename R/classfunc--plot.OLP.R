# --- FUNCTION plot.OLP ---------------------------------------
#
# Usage:    plot(OLP), plot.OLP(OLP)
# Purpose:  modifies the default plot routine 
#           for objects of class "OLP"
# Input:    Object of class "OLP"
# Output:   -
#
# -------------------------------------------------------------


#### roxygen2 comments ################################################
#' Plot OLP objects
#' 
#' plot method for objects of the class "\code{OLP}"
#' 
#' @param x an object of class \code{OLP}
#' @param ... additional arguments
#' 
#' @return 
#' plots the achieved wealth of an online portfolio selection algorithm
#' 
#' @examples
#' library(OLPS)
#' #load data
#' data(NYSE)
#' # select stocks
#' returns <- NYSE[,c("kinar", "iroqu")]
#' weights <- c(0.5, 0.5)
#'  
#' #calc_CRP
#' CRP <- calc_CRP(returns, weights)
#' plot(CRP)
#' 
#' @S3method plot OLP
#' @export
#' 
#########################################################################
plot.OLP <- function(x, ...){
  plot(x$Wealth, type = "l", 
                 xlab = "trading period", 
                 ylab = "Wealth", 
                 main = x$Alg)
}