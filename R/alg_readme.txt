calc routines for different OLPS Algorithms

dependencies:  - Rnd.Port()
               - .Wealth.CRP()
               - Wealth()
               - GrowthRate()
               - Risk()
Input:  Returns --> Matrix; relative Returns, (the ratio of 
                    the closing (opening) price today and 
                    the day before)
        Weights --> Vector; weights to which the portfolio should be 
                    rebalanced (only for CBAL)
Output: object of class OLP, containing 
        - algorithm name
        - weights
        - wealth
        - growth rate
        - expected annual log-return (return)
        - standard deviation of exp. ann. log-return (risk)