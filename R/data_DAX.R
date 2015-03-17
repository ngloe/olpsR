# ============================================#
# Documentation for DAX dataset with roxygen2 #
# ============================================#

#' Daily returns from German stocks listed in the DAX
#'
#' The dataset contains daily returns of 26 stocks listed in the German DAX. 
#' from 2000-01-04 until 2013-12-31, that is 3638 trading days.
#'  Returns are calculated as closing price divided by the closing price 
#'  of the privious day (price relative).
#'
#' @format A data frame with 3638 rows and 26 variables.
#' 
#' @details The following stocks are included:
#' \itemize{
#'   \item{\code{ADS.DE}}
#'   \item{\code{ALV.DE}}
#'   \item{\code{BAS.DE}}
#'   \item{\code{BAYN.DE}}
#'   \item{\code{BEI.DE}}
#'   \item{\code{BMW.DE}}
#'   \item{\code{CBK.DE}}
#'   \item{\code{CON.DE}}
#'   \item{\code{DAI.DE}}
#'   \item{\code{DBK.DE}}
#'   \item{\code{LHA.DE}}
#'   \item{\code{DTE.DE}}
#'   \item{\code{EOAN.DE}}
#'   \item{\code{FME.DE}}
#'   \item{\code{FRE.DE}}
#'   \item{\code{HEI.DE}}
#'   \item{\code{HEN.DE}}
#'   \item{\code{SDF.DE}}
#'   \item{\code{LXS.DE}}
#'   \item{\code{LIN.DE}}
#'   \item{\code{MRK.DE}}
#'   \item{\code{MUV2.DE}}
#'   \item{\code{SAP.DE}}
#'   \item{\code{SIE.DE}}
#'   \item{\code{TKA.DE}}
#'   \item{\code{VOW.DE}}
#' }
#' 
#' @usage data(DAX)
#' 
#' @source stock price data was collected from \url{https://finance.yahoo.com}.
#' 
#' @docType data
#' @keywords datasets
#' @name DAX
NULL