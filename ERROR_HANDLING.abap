"Try - Catch Exception handling"
DATA :v_unit_value TYPE i,
      v_total_value TYPE i VALUE 20,
      v_quantity TYPE i.
DATA r_ex TYPE REF TO cx_sy_zerodivide.

TRY .
    v_unit_value = v_total_value / v_quantity.
    WRITE v_unit_value.

  CATCH cx_sy_zerodivide INTO r_ex.
    WRITE :/'Error Short Text:',r_ex->get_text( ). "Division by zero
    WRITE :/'Error long Text:',r_ex->get_longtext( ).
  CLEANUP.
    " Any cleanup logic goes here the CLEANUP block
    " can be used to close any open files or rollback any database updates.
ENDTRY.

***** RETRY *****
PARAMETERS: pa_sayi1 TYPE i,
            pa_sayi2 TYPE i.
data result TYPE p DECIMALS 2.

TRY .
  result = pa_sayi1 / pa_sayi2.
CATCH cx_sy_zerodivide.
  pa_sayi1 = 0.
  RETRY. "try bloğunu tekrardan çalıştırır"
ENDTRY.

 "En genel hata yakalama exception"
data lr_exception TYPE REF TO cx_root. 
TRY .

CATCH cx_root INTO lr_exception. "Eğer dönecek hatanın sınıfını bilmiyorsan bu yöntem kullanılır"
	data(lv_text) = lr_exception->get_text( ). "Hata kısa metninin döner"

ENDTRY.


  IF iv_val2 LE 0.
    MESSAGE e007(zaa_msg) RAISING divide_by_zero.
    ev_subrc = 4.
     CLEAR ls_return.
     ls_return-id = 'ZAA_MSG'.
     ls_return-number = '007'.
     ls_return-type = 'E'.
     ls_return-message_v1 = '0'.
     MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number
       WITH ls_return-message_v1 ls_return-message_v2 ls_return-message_v3 ls_return-message_v4
       INTO ls_return-message.
     APPEND ls_return TO et_return.
     EXIT.
  ELSE.
    ev_result = iv_val1 / iv_val2.
  ENDIF.




"fonksiyonlar için"
CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
 ...
EXCEPTIONS  " un-comment these sections
  no_rate_found = 1
  overflow = 2
  no_factors_found = 3
  no_spread_found = 4
  derived_2_times = 5
OTHERS = 6.
IF sy-subrc NE 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO  " this is display the system message automatically when ever exp are hit
 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.