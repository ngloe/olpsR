# --- Function get_risk --------------------------------
#
# Usage:    get_risk(Wealth)
# Purpose:  Calculates the expected risk defined as 
#           std. dev. of log-returns on annual basis
# Input:    Wealth --> Vector of Wealth
# Output:   annual risk
#
# ------------------------------------------------------


#### roxygen2 comments ################################################
#
#' Get portfolio risk
#' 
#' calculates the expected risk defined as stdandard deviation of 
#' log-returns on an annual basis.
#' 
#' @param wealth vector of portfolio wealth
#' 
#' @return portfolio risk
#'  
#' @examples 
#' library(OLPS)
#' # load data
#' data(NYSE)
#' # select stocks
#' x <- NYSE[,c("kinar", "iroqu")]
#' # specify portfolio weights
#' b <- c(0.05, 0.05)
#' # calculate wealt
#' w <- get_wealth(x, b)
#' # calculate exponential growth rate
#' get_risk(w)
#' 
#' @export
#' 
#########################################################################
get_risk <- function(wealth){
  n <- 1:length(wealth)
  w <- c(1, wealth)
  risk <- sd( diff( log(w)) ) * sqrt(250)
  return(risk)
}