# --- FUNCTION print.OLP ---------------------------------------
#
# Usage:    print(x), print.OLP(x)
# Purpose:  modifies the default print routine 
#           for objects of class "OLP"
# Input:    Object of class "OLP"
# Output:   -
#
# -------------------------------------------------------------


#### roxygen2 comments ################################################
#' Print OLP objects
#' 
#' print method for objects of the class "\code{OLP}"
#' 
#' @param x an object of class \code{OLP}
#' @param ... additional arguments
#' 
#' @return 
#' The function returns a short summary of the OLP object containing
#' \item{Assets}{names of the assets in the portfolio}
#' \item{weights}{portfolio weights; only shown if weights remain constant 
#'                during trading horizon}
#' \item{Terminal Wealth}{final cumulative wealth achieved by the algorithm}
#' \item{expected log-return}{annualized expected log return}
#' \item{expected risk}{annualized standard deviation of expected log-returns}
#' \item{Return-to-Risk}{ratio of exp. log-return and exp. risk}
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
#' print(CRP)
#' 
#' @S3method print OLP
#' @export
#' 
#########################################################################
print.OLP <- function(x, ...){
  pw <- c("BH", "BH_best", "CRP", "BCRP")
  
  cat("SUMMARY of", x$Alg, ":\n")
  cat("\n")
  
  cat("Assets               ", x$Names, "\n")
  if(x$Alg %in% pw){
    cat("weights              ", x$Weights, "\n")
  }
  cat("\n")
  cat("Terminal Wealth      ", x$Wealth[length(x$Wealth)], "\n")
  cat("expected log-Return  ", x$Return, "\n")
  cat("expected Risk        ", x$Risk, "\n")
  cat("Return-to-Risk       ", x$Return/x$Risk, "\n")
  cat("\n")
}