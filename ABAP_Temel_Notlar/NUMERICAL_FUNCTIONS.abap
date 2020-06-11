 DATA n TYPE decfloat16.
 DATA m TYPE decfloat16 VALUE '-3.58'.
 
WRITE : / 'Original value :', m.
 n = abs( m ).
 WRITE :/ 'Absolute Value :',  n.
 
n = sign( m ).
 WRITE :/ 'Sign :', n.
 
n = ceil( m ).
 WRITE :/ 'Ceil Value :', n.
 
n = floor( m ).
 WRITE :/ 'Floor Value :', n.
 
n = trunc( m ).
 WRITE :/ 'Truncate Value :', n.
 
n = frac( m ).
 WRITE :/ 'Fraction Value :', n. 

 data : max type i ,
         min type i.
 * maximum 9 values can be passed
 max = nmax( val1 = 10
                       val2 = 12
                         val3 = 14
                           val4 = 16
                             val5 = 18
                                val6 = 20
                                  val7 = 25
                                    val8 = 7
                                      val9 = 3  ).
 
min = nmin( val1 = 10
                      val2 = 12
                        val3 = 14
                          val4 = 16
                            val5 = 18
                              val6 = 20
                                val7 = 25
                                   val8 = 7
                                     val9 = 3  ).
 
WRITE : / 'Maximum :', max.
 WRITE : / 'Minimum :', min. 

"get max internal table
data(max_ebelp) = REDUCE ebelp( init a = 0 for <wa2> IN ch_copy_mdpsx
                                WHERE ( delnr = <pair_mrp>-ebeln and delps = <pair_mrp>-ebelp )
                                next a = nmax( val1 = a val2 = <wa2>-ebelp ) ).