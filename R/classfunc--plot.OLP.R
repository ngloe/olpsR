# --- FUNCTION plot.OLP ---------------------------------------
#
# Usage:    plot(OLP), plot.OLP(OLP)
# Purpose:  modifies the default plot routine 
#           for objects of class "OLP"
# Input:    Object of class "OLP"
# Output:   -
#
# -------------------------------------------------------------


#### roxygen2 comments ################################################
#' Plot OLP objects
#' 
#' plot method for objects of the class "\code{OLP}"
#' 
#' @param x an object of class \code{OLP}
#' @param ... additional arguments
#' 
#' @return 
#' Plots the achieved wealth of an online portfolio selection algorithm. 
#' If multiple input arguments of class OLP are given a risk-return plot 
#' and APY and MDD values are also given.
#' 
#' @examples
#' library(OLPS)
#' #load data
#' data(NYSE)
#' # select stocks
#' data(NYSE)
#' x = cbind(iroqu=NYSE$iroqu, kinar=NYSE$kinar, comme=NYSE$comme)
#' 
#' # compute portfolio algorithms
#' MARKET = calc_BH(x, rep(1/ncol(x), ncol(x)))
#' BHbest = calc_BHbest(x)
#' ND     = calc_CRP(x, rep(1/ncol(x), ncol(x)))
#'  
#' plot(MARKET)
#' plot(MARKET, BHbest, ND)
#' 
#' @S3method plot OLP
#' @export
#' 
#########################################################################
plot.OLP <- function(x, ...){
  
  # get input variable names and store as arg_names
  arg_name   = deparse(substitute(x))
  dots_names = substitute(list(...))[-1]
  arg_names  = c(arg_name, sapply(dots_names, deparse))
  #names_data = sapply(1:length(myargs), function(i) myargs[[i]]$Alg)
  names_data = arg_names
  
  # default values for graphic options
  .pardefault = par(no.readonly = T)
  
  # check input arguments
  myargs = list(x, ...)
  n_args = nargs()
  if( n_args < 2 ){  
    plot(x$Wealth, type = "l", 
         xlab = "Time", 
         ylab = "Wealth", 
         main = x$Alg)
  } else {
    
    # set graphic panel layout options
    m = rbind( c(1,1), c(2,3), c(4,4) )
    layout(m, heights = c(0.4, 0.4, 0.2))
    par(mar = c(4.1, 5.1, 4.1, 3.1))
    
    # set color options
    mycol = 1:(length(arg_names))
    #mycol = c("#00A0B0", "#6A4A3C", "#CC333F", "#EB6841", "#EDC951")
    #mycol = c("#EB912B", "#7099A5", "#C71F34", "#1D437D", "#E8762B", "#5B6591", "#59879B")
    
    # make data calculations
    # wealth
    W_data = sapply(1:length(myargs), function(i) myargs[[i]]$Wealth)
    colnames(W_data) = arg_names
    # returns
    Return_data = sapply(1:length(myargs), function(i) myargs[[i]]$Return)
    names(Return_data) = arg_names
    # risk
    Risk_data   = sapply(1:length(myargs), function(i) myargs[[i]]$Risk)
    names(Risk_data) = arg_names
    # APY
    APY_data = sapply(1:length(myargs), function(i) myargs[[i]]$APY)
    names(APY_data) = arg_names
    # MDD
    MDD_data = sapply(1:length(myargs), function(i) myargs[[i]]$MDD)
    names(MDD_data) = arg_names
    
    
    # plot cumulative wealth
    plot.ts(W_data, main="Cumulative Wealth", xlab="Time", ylab="", plot.type = "single", col=mycol)
    
    # plot returns and risk
    dat = as.matrix(data.frame(Risk=Risk_data, Return=Return_data))
    plot(dat*100, main="Risk-Return", xlab="Risk [%]", ylab="Return [%]", col=mycol, pch=16, cex=1.5)
    grid()
    
    # plot APY and MDD
    dat = as.matrix(data.frame(APY=APY_data, MDD=MDD_data))
    #barplot(dat*100, beside = TRUE, col=mycol, ylab="[%]", ylim=c(0, 1.1*max(dat*100)))
    dotchart(dat*100, main="APY & MDD", xlab="[%]", color=mycol, )
    
    # add legend
    par(mar = c(0, 5.1, 0, 5.1))
    plot(1, type = "n", axes=FALSE, xlab="", ylab="")
    legend( 'center', names_data, lty=1, col=mycol, bty="n", horiz=TRUE, cex=1 )
    
  }
  
  # reset graphic panel layout
  par(.pardefault)
  
}
