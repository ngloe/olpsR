#### roxygen2 comments ################################################
#
#' Get conversion rates
#' 
#' calculates for each time instant the conversion rate for converting asset i into asset j; that is the ratio of the 
#' prices of asset i and asset j
#' 
#' @param prices Matrix of asset prices, where each column represents
#'               an asset.
#' 
#' @return Array[i,j,t] of conversion rates for converting asset i into asset j at time instant t.
#'  
#' @examples 
#' # load data
#' data(NYSE)
#' # select stocks
#' x = cbind(kinar=NYSE$kinar, iroqu=NYSE$iroqu)
#' 
#' # get conversion rates
#' get_conversion_rates(x)
#' 
#' @export
#' 
#########################################################################
# ============================================================== #
# calculate converion rates for converting asset i into asset j
#
# MODEL: Q_ij = q_i / q_j
#
# INPUT:  prices as a vector of length t or a matrix (data.frame)
#         with t rows
# OUTPUT: conversion rates as a t-dimensional array Q[n,n,t], where 
#         dimension t contains the conversion rates for period t
# ============================================================== #
get_conversion_rates = function(prices){
  q = prices
  n = ncol(q)
  H = nrow(q)
  
  if(is.vector(q)){
    Q = sapply(q, function(x) q / x)
  } 
  
  if(is.matrix(q)){
    Q = array(dim=c(n,n,H))
    for(t in 1:H){
      Q[,,t] = sapply(q[t,], function(x) q[t,] / x)
    }
  } 
  
  return(Q)
}
