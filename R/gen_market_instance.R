#### roxygen2 comments ################################################
#
#' Generate market instances
#' 
#' generates a random market instance from a given dataset with random number of assets and time instants, where the order of time instants is not changed.
#' 
#' @param data a matrix or dataframe from which the subdataset is generated
#' @param m number of columns (assets)
#' @param t number of rows (time instants)
#' @param N number of market instances to be generated
#' 
#' @return a subset of the dataset as a matrix.
#' 
#' @references 
#' Dochow, R.; Leppek, C.; Schmidt, G.; A framework for automated performance evaluation of 
#' portfolio selection algorithms. Working paper, 2015
#' 
#' @examples 
#' dataset = matrix(runif(100), 10, 10)
#' # generate 10 market instances with two assets and 5 time instants from dataset
#' gen_market_instance(dataset, m=2, t=5, N=10)
#' 
#' @export
#' 
#########################################################################
gen_market_instance = function(data, m, t=nrow(data), N=1){
  x = data
  
  # check for invalid inputs
  if(m>ncol(x)) stop("'m' must be smaller than or equal to 'ncol(data)'")
  if(t>nrow(x)) stop("'t' must be smaller than or equal to 'nrow(data)'")
  
  # initialize list of market instances
  x_market = list()
  
  for(n in 1:N){
    
    # randomly set starting time t_tmp such that t + t_tmp - 1 <= T (t in [1, inf])
    t_tmp = sample(1:nrow(x), 1)
    while(t_tmp + t - 1 > nrow(x)){
      t_tmp = sample(1:nrow(x), 1)
    }
  
    # randomly choose assets
    i = sample(1:ncol(x), size=m, replace=FALSE)
    x_market[[n]] = x[t_tmp:(t_tmp+t-1),i]
  
  }
  
  return(x_market)
}
