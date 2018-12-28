*&---------------------------------------------------------------------*
*& Report  ZFOR_ALL_ENTRIES
*&
*&---------------------------------------------------------------------*
*& Aynı anda birden fazla tablodan veri çekmenin inner join
*& harici alternatif yöntemi. select sorgusu içerisinde başka local
*& başka bir tablodan veri çekmek için for all enrtries in
*& loop içerisinde başka tablodan veri çekmek için read table kullanılır
*&---------------------------------------------------------------------*

REPORT  ZFOR_ALL_ENTRIES.

DATA: lt_scarr type TABLE OF scarr,
      wa_scarr like LINE OF lt_scarr,
      lt_spfli type TABLE OF spfli,
      wa_spfli like LINE OF lt_spfli.

SELECT * FROM scarr into CORRESPONDING FIELDS OF TABLE lt_scarr.

IF lt_scarr is NOT INITIAL. "boş değilse

  " lt_scarr tablosundaki her eleman için where sorgusu yapar
  SELECT * from spfli INTO CORRESPONDING FIELDS OF TABLE lt_spfli
  FOR ALL ENTRIES IN lt_scarr " lt_scarr tablosundaki her elaman için
  WHERE carrid eq lt_scarr-carrid.

  LOOP AT lt_spfli INTO wa_spfli.
    " döngünün içerisinde başka tablodan veri okuyoruz
    " diğer tabloda döngüde her seferinde değişecek olan carrid parametresine
    " göre okuma yapıyoruz
    READ TABLE lt_scarr INTO wa_scarr with KEY carrid = wa_spfli-carrid.
    IF sy-subrc eq 0.
      NEW-LINE.
      WRITE: wa_spfli-carrid,
             wa_spfli-connid,
             wa_scarr-carrname.
    ENDIF.
  ENDLOOP.
ENDIF.