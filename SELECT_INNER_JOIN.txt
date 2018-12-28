
data: gs_veri type ty_veri,
      gt-veri type table of ty_veri with header line.

* INNER JOIN kullanılırlen - yerine ~ kullanılır
* INTO CORRESPONDING FIELDS OF TABLE okunan verileri tabloya yazar. Yazdığı tabloda elimizdeki alanlara denk gelen kısımlara
* yazar. 5 tip veri varken biz 3 tip veri çektiğimizde bunu hata olarak göstermez.

select t1~matnr as matnr_mara t2~mtart(marc-matnr) t3~maktx INTO CORRESPONDING FIELDS OF TABLE gt_veri 
  from mara as t1 inner JOIN marc as t2 ON t1~matnr = t2~matnr 
           	  inner JOIN makt as t3 ON t1~matnr = t3~matnr
 WHERE t2~werks eq = '2110'.


* Left outer join dil için kullanılır. 
* Eğer dil bakımı yapılmadıysa veri yine de gelir dil alanı boş gelir

select * into gt_table 
  from mara Left outer join maktx 
    on mara~matnr eq maktx~matnr
    and maktx~spras eq sy-langu
      where mara~matnr eq '0000013'. 

 ------------------- ÖRNEK2 --------------

 data: ls_stveri type ls_veriler,
      lt_tablo type table of ls_veriler.


select m~matnr m~ersda m~ERNAM m~LAEDA m~AENAM m~VPSTA m~PSTAT m~LVORM m~MTART
m~MBRSH m~MATKL m~BISMT m~MEINS mk~maktx INTO CORRESPONDING FIELDS OF TABLE lt_tablo
  from mara as m inner JOIN makt as mk ON m~matnr = mk~matnr UP TO 100 ROWS.


 ---- ALTERNATİF KULLANIM ------------------------------------------
 
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

-----------------------------------------------------------