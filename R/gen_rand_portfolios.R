#### roxygen2 comments ################################################
#
#' Generate random portfolios
#' 
#' generates uniformly distributed random portfolios based on Algorithm 3
#' of Ishijima's 'Numerical Methods for Universal Portfolios' (see references)
#' 
#' @param n_portfolios number of portfolios to be generated
#' @param n_assets number of assets within each portfolio
#' 
#' @return Matrix with portfolio weights; each row represents a portfolio
#'  
#' @references 
#' Ishijima 2001, Numerical Methods for Universal Portfolios
#' \url{http://www.business.uts.edu.au/qfrc/conferences/qmf2001/Ishijima_H.pdf}
#'       
#' @examples 
#' gen_rand_portfolios(10, 3)
#' 
#' @export
#' 
#########################################################################
gen_rand_portfolios <- function(n_portfolios, n_assets){
  generate_portfolio <- function(n_assets){
    #Step 1:
    x <- rgamma(n=n_assets, shape=1)
    #Step 2:
    b <- x/sum(x)
    b[n_assets] <- 1-sum(b[1:(n_assets-1)])
    return(b)
  }  
  return(t(replicate(n_portfolios, generate_portfolio(n_assets))))
}
