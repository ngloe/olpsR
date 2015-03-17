# --- Function get_growth_rate -------------------------
#
# Usage:    get_growth_rate(wealth)
# Purpose:  Calculates the exponential growth rate (i.e. expected log-return)
# Input:    Wealth --> Vector of Wealth
# Output:   exponential growth rate
#
# --------------------------------------------------


#### roxygen2 comments ################################################
#
#' Get exponential growth rate
#' 
#' calculates the exponential growth rate (i.e. expected log-return) from
#' the portfolio wealth
#' 
#' @param wealth vector of portfolio wealth
#' 
#' @return vector of the portfolio's exponential growth rate
#'  
#' @examples 
#' library(OLPS)
#' # load data
#' data(NYSE)
#' # select stocks
#' x <- NYSE[,c("kinar", "iroqu")]
#' # specify portfolio weights
#' b <- c(0.05, 0.05)
#' # calculate wealth
#' w <- get_wealth(x, b)
#' # calculate exponential growth rate
#' get_growth_rate(w)
#' 
#' @export
#' 
#########################################################################
get_growth_rate <- function(wealth){
  n <- 1:length(wealth)
  gr <- 1/n * log(wealth)
  return(gr)
}