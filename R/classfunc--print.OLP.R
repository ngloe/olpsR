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
#' \item{return}{annualized portfolio return (252 trading days)}
#' \item{risk}{portfolio risk defined as the annualized standard deviation of returns (252 trading days)}
#' \item{APY}{annualized percantage yield (252 trading days)}
#' \item{MDD}{maximum draw down (downside risk)}
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
print.OLP = function(x, ...){
  
  # Heading with algorithm's name
  cat("SUMMARY:\n")
  cat("--------\n")
  
  # print algorithm
  cat("  Algorithm  ", x$Alg, "\n")
  
  # print asset names (max. 5)
  len = length(x$Names)
  if( len <= 5){ 
    cat("  Assets     ", x$Names, "\n")
  } else {
    cat("  Assets     ", x$Names[1:5], "... \n")
  }
  
  # print portfolio weights (max. 5) if ALG=(BH, BHbest, CRP, BCRP)
  bh_strat  = c("BH", "BHbest")
  crp_strat = c("CRP", "BCRP")
  if(x$Alg %in% bh_strat){
    if( len <= 5 ){
      cat("  weights    ", round(x$Weights, 3), "\n")
    } else {
      cat("  weights    ", round(x$Weights[1:5], 3), "... \n")
    }
  }
  if(x$Alg %in% crp_strat){
    if( len <= 5 ){
      cat("  weights    ", round(x$Weights[1,], 3), "\n")
    } else {
      cat("  weights    ", round(x$Weights[1,1:5], 3), "... \n")
    }
  }
  cat("\n")
  
  cat("  Terminal Wealth  ", round( x$Wealth[length(x$Wealth)], 3), "\n")
  cat("\n")
  cat("  Return [%]  ", round( x$Return * 100, 3 ), "\t\t\t")
  cat("  APY [%]  ", round( x$APY * 100, 3 ), "\n")
  cat("  Risk   [%]  ", round( x$Risk * 100, 3), "\t\t\t")
  cat("  MDD [%]  ", round( x$MDD * 100, 3 ), "\n")
  cat("--------\n")
}
