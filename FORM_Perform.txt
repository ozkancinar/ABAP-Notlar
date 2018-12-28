
FORM give_result USING p_result.

ENDFORM.     

"Table
form fetch_values  using p_lt_caufv like lt_caufv.
  
endform.   

FORM TESTING_PARAMS  USING  VaLUE(P_RESULT) " by value
                     CHANGING VALUE(P_DEGER1)  "by value and result
                              P_DEGER2. " by reference
  ADD 1 to p_result.
  ADD 1 to p_deger1.
  NEW-LINE.
  WRITE: 'sonucTesting: ', p_result.
  WRITE: / 'deger1Testing: ', p_deger1.
ENDFORM.                    " TESTING_PARAMS

form exclude_tb_functions  changing pt_exclude type ui_functions.

endform.

form delete_row using lt_row type lvc_t_row.
  
endform.

