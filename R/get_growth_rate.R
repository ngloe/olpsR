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
#' # load data
#' data(NYSE)
#' # select stocks
#' x = cbind(comme=NYSE$comme, kinar=NYSE$kinar)
#' # specify portfolio weights
#' b = c(0.05, 0.05)
#' # calculate wealth
#' w = get_wealth(x, b)
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
