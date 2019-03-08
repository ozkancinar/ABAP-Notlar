
MESSAGE 'Başarılı İşlem' TYPE 'S'.
MESSAGE 'Hata' TYPE 'E'.
MESSAGE 'Uyarı Mesajı' TYPE 'W'.
MESSAGE 'Uyarı Mesajı' TYPE 'I'. "Uyarı mesajı gösterir kullanıcı ok'e tıkladıüında devam eder
MESSAGE 'Hata. İşlem sonlandırılıyor. Ekran kapatılıyor' TYPE 'A'.
MESSAGE 'Short Dump Hatası' TYPE 'X'. "Dump hatası gösterilir pek kullanılmaz

1). MESSAGE 'abs' type 'I'.
2). MESSAGE I002 (<Message Class>)
            In the message class we have to write the corresponding message for 002.
3). REPORT <Program Name> MESSAGE-ID <Message Class>.
        MESSAGE I002.
            In the message class we have to write the corresponding message for 002.
4). MESSAGE i006 WITH text-003.
                    In the text symbols 003 we have to write the corresponding message.
5). MESSAGE text-001 type 'I'.
                        In the text symbols 001 we have to write the corresponding message.
6). MESSAGE i006 WITH 'Invalid purchase order Number'(003).
 " "      006 message description is sending at runtime, in the message class we mention & & & & for the corresponding 006 number. In the text symbols 003 we are writing the description, it    just for our display purpose.
7). MESSAGE ID '<Message Class>' type 'I' NUMBER 002.
8). MESSAGE i003 (<Message Class>) WITH '<Some text message> '.
9). MESSAGE i003 (<Message Class>) WITH text-003.
                        In the text symbols 003 we have to write the corresponding message.
10). MESSAGE i003 (<Message Class>) with p_user.

"Mesaj sınıf ve id bilgilerini değişken ile gönder
MESSAGE ID my_mid TYPE my_mtype NUMBER my_num WITH my_var1 my_var2 my_var3 my_var4 INTO lv_msg_txt.

"BAPIRET2_T mesaj tablosu oluştur:
*"  IMPORTING
*"     VALUE(IV_VAL1) TYPE  INT4 OPTIONAL
*"     VALUE(IV_VAL2) TYPE  INT4 OPTIONAL
*"  EXPORTING
*"     VALUE(EV_RESULT) TYPE  INT4
*"     VALUE(EV_SUBRC) TYPE  SYSUBRC
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"  EXCEPTIONS
*"      DIVIDE_BY_ZERO
*"----------------------------------------------------------------------
  DATA: ls_return LIKE LINE OF et_return.

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
