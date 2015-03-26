# =============================================#
# Documentation for DJIA dataset with roxygen2 #
# =============================================#

#' DJIA daily returns
#' 
#' The dataset contains daily returns of 30 stocks from the Dow Jones Industrial 
#' Average (DJIA) from 2001-01-14 until 2003-01-14, that is 507 trading days. 
#' Returns are calculated as closing price divided by the closing price 
#' of the privious day (price relative). 
#' The dataset was used for the analysis of \code{Anticor} algorithm by Borodin et al. 
#' for example.
#' 
#' @format A data frame with 507 observations on the following 30 stocks.
#' 
#' @details The following stocks are included:
#' \describe{
#'  \item{\code{alcoa}}{ALCOA INC}
#'  \item{\code{ge}}{GENERAL ELEC CO}
#'  \item{\code{jnj}}{JOHNSON&JOHNSON}
#'  \item{\code{msft}}{MICROSOFT CP}
#'  \item{\code{amxp}}{AMER EXPRESS CO}
#'  \item{\code{gm}}{GENERAL MOTORS}
#'  \item{\code{jpm}}{JP MORGAN CHASE}
#'  \item{\code{pg}}{PROCTER & GAMBLE}
#'  \item{\code{boeing}}{BOEING CO}
#'  \item{\code{homedep}}{HOME DEPOT INC}
#'  \item{\code{coke}}{COCA COLA CO}
#'  \item{\code{sbc}}{SBC COMMS}
#'  \item{\code{citi}}{CITIGROUP}
#'  \item{\code{honey}}{HONEYWELL INTL}
#'  \item{\code{mcd}}{MCDONALDS CORP}
#'  \item{\code{att}}{AT&T CORP}
#'  \item{\code{cat}}{CATERPILLAR}
#'  \item{\code{hp}}{HEWLETT-PACKARD}
#'  \item{\code{mmm}}{3M COMPANY}
#'  \item{\code{utc}}{UNITED TECH CP}
#'  \item{\code{dupont}}{DU PONT CO}
#'  \item{\code{ibm}}{INTL BUS MACHINE}
#'  \item{\code{morris}}{PHILIP MORRIS}
#'  \item{\code{walmart}}{WAL-MART STORES}
#'  \item{\code{disney}}{WALT DISNEY CO}
#'  \item{\code{intel}}{INTEL CORP}
#'  \item{\code{merck}}{MERCK & CO}
#'  \item{\code{exxon}}{EXXON MOBIL}
#'  \item{\code{kodak}}{EASTMAN KODAK}
#'  \item{\code{ip}}{INTL PAPER CO}
#' }
#' 
#' @usage data(DJIA)
#' 
#' @source Yahoo Finance, according to \url{http://www.cs.technion.ac.il/~rani/portfolios}
#' 
#' @references
#' Borodin, A.; El-Yaniv, R. & Gogan, V. 
#' Can we learn to beat the best stock, 2004
#' 
#' @docType data
#' @keywords datasets
#' @name DJIA
NULL
