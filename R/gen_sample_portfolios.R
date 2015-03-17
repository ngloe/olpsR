# --- FUNCTION gen_sample_portfolios ---------------------------------------
#
# Usage:    gen_sample_portfolios(n_assets, step=0.05)
# Purpose:  generates all possible portfolios of the form b = (b_1, b_2, ... b_m),
#           where 'b_m - b_m-1 = step', 0 < step < 1
# Input:    n_assets  --> number of assets within each portfolio, integer
#           step      --> specifies the limiting set of CRP portfolios of the form b=(b_1,     
#                       1-b_1)}, where b_1 runs from 0 to 1 in steps of length 
#                       "step=0.05"
# Output:   Matrix with portfolio weights; each row represents a portfolio
#
# Dependencies: 'gtools'-package (function 'permutations()')
#
#-------------------------------------------------------------------------


#### roxygen2 comments ################################################
#
#' Generate sample portfolios
#' 
#' generates all possible portfolios of the form \eqn{b = (b_1, b_2, ... b_m)}, 
#' where \eqn{b_i - b_i-1 = step} and, \eqn{0 < step < 1}.
#' 
#' @param n_assets number of assets within each portfolio
#' @param step step length
#' 
#' @return Matrix with portfolio weights; each row represents a portfolio
#'       
#' @note 
#' can lead to memory problems for \code{n_assets > 5}. Alternatively
#' use \code{gen_rand_portfolios}.
#' 
#' @examples 
#' gen_sample_portfolios(2, step=0.05) 
#' 
#' @export
#' 
#########################################################################
gen_sample_portfolios <- function(n_assets, step=0.05){
  #make sure that sequence can end up 1
  step_internal <- 1/round(1/step)
  
  c1 <- seq(0,1, by=step_internal)
  tmp <- gtools::permutations(length(c1), n_assets ,c1, repeats.allowed=TRUE)
  portfolios <- tmp[which(rowSums(tmp)==1),]
  return(portfolios)
}