# ====================================#
# Package Documentation with Roxygen2 #
# ====================================#

#' OLPS: Functions for Online Portfolio Selection.
#'
#' The OLPS package provides different online portfolio selection algorithms
#' and functions to deal with the online portfolio selection problem. 
#' Datasets to test the algorithms are also included.
#' 
#' Algorithms are mostly based on the paper "Online Portfolio Selection: A Survey"
#' by Bin Li and Steven C. Hoi 
#' (\url{http://arxiv.org/pdf/1212.2129.pdf})
#' 
#' @section Algorithms:
#' The following online portfolio selection algorithms are currently implemented:
#' \itemize{
#'  \item{\code{BH}: }{Buy-and-Hold}
#'  \item{\code{BHbest}: }{best Buy-and-Hold}
#'  \item{\code{CRP}: }{Constant Rebalanced Portfolio}
#'  \item{\code{BCRP}: }{Best Constant Rebalanced Portfolio}
#'  \item{\code{UP}: }{Universal Portfolio}
#'  \item{\code{EG}: }{Exponential Gradient}
#'  \item{\code{Anticor}: }{Anticor}
#'  \item{\code{PAMR}: }{Passive Aggressive Mean Reversion}
#'  \item{\code{VT}: }{Volatility Timing}
#' }
#' 
#' @section Functions:
#' 'Helper' functions, e.g. to transform stock prices into price relatives or 
#' into a Kelly market sequence.
#' 
#' @section Datasets:
#' Historical stock prices for different markets.
#'
#' @docType package
#' @name OLPS-package
NULL