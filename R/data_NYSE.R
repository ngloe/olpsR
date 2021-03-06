# =============================================#
# Documentation for NYSE dataset with roxygen2 #
# =============================================#

#' NYSE daily returns
#' 
#' The dataset contains daily returns of 36 stocks listed in the 
#' New York Stock Exchange from 1962-07-03 until 1984-12-31, that is 5651 trading days. 
#' Returns are calculated as closing price divided by the closing price 
#' of the privious day (price relative). 
#' The dataset was used for the analysis of Cover's \code{Universal Portfolio} algorithm for example
#' 
#' @format A data frame with 5651 observations on the following 36 stocks.
#' 
#' @details The following stocks are included:
#' \itemize{
#'  \item{\code{ahp}}
#'  \item{\code{alco}}
#'  \item{\code{amerb}}
#'  \item{\code{arco}}
#'  \item{\code{coke}}
#'  \item{\code{comme}}
#'  \item{\code{dow}}
#'  \item{\code{dupont}}
#'  \item{\code{espey}}
#'  \item{\code{exxon}}
#'  \item{\code{fisch}}
#'  \item{\code{ford}}
#'  \item{\code{ge}}
#'  \item{\code{gm}}
#'  \item{\code{gte}}
#'  \item{\code{gulf}}
#'  \item{\code{hp}}
#'  \item{\code{ibm}}
#'  \item{\code{inger}}
#'  \item{\code{iroqu}}
#'  \item{\code{jnj}}
#'  \item{\code{kimbc}}
#'  \item{\code{kinar}}
#'  \item{\code{kodak}}
#'  \item{\code{luken}}
#'  \item{\code{meico}}
#'  \item{\code{merck}}
#'  \item{\code{mmm}}
#'  \item{\code{mobil}}
#'  \item{\code{morris}}
#'  \item{\code{pandg}}
#'  \item{\code{pills}}
#'  \item{\code{schlum}}
#'  \item{\code{sears}}
#'  \item{\code{sherw}}
#'  \item{\code{tex}}
#' }
#' 
#' @usage data(NYSE)
#' 
#' @source Originally collected by Hal Stern the data here is provided by 
#' Yoram Singer \url{http://www.cs.bme.hu/~oti/portfolio/data.html}
#' 
#' @references
#' Cover, T. M. 
#' Universal Portfolios, 1991
#' 
#' @docType data
#' @keywords datasets
#' @name NYSE
NULL
