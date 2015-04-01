#### roxygen2 comments ################################################
#
#' Get Kelly Sequence from price relatives
#' 
#' transform any sequence of price relatives
#' into  a Kelly market sequence. That is, for each trading 
#' period t the maximum relative price is assigned 1,
#' otherwise 0. If there exist 2 or more assets with 
#' maximum value assign 1 randomly amongst them.
#' 
#' @param x Matrix of price relatives (rows=time, columns=assets)
#' 
#' @return Matrix, where each row represents a Kelly market 
#'                 (rows=time, columns=assets)
#'  
#' @examples 
#' #load data
#' data(NYSE)
#' # select stocks
#' x = cbind(comme=NYSE$comme, kinar=NYSE$kinar)
#' get_kelly_seq(x)
#' 
#' @export
#' 
#########################################################################
get_kelly_seq <- function(x){
  # find index asset with max price relative
  index <- apply(x, 1, which.max)
  index <- cbind(1:length(index), index)
  # generate Kelly-Sequence
  kelly_seq <- matrix(0, nrow=nrow(x), ncol=ncol(x))
  kelly_seq[index] <- 1  
  
  return(kelly_seq)
}  
