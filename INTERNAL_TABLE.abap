******* /SORTED TABLE **************
Sorted table: Tüm indexi koymak gerekir. Aşağı ekleme yapılamaz. Sıralamanın tersi bir şey eklenirse dump alır.
data: t_mara_sorted TYPE SORTED TABLE OF ty_mara,
      t_mara_standard TYPE STANDARD TABLE OF ty_mara,.

t_mara_sorted[] = t_mara_standard[]. "Yapılabilir hata vermez
insert ls_mara into table t_mara1. "Append kullanılamaz
******* /SORTED TABLE *************

******* APPEND *************
"Append: Bir structureı internal table''a ekler. Yalnızca standartad table tipi için uygundur. Sorted ve hashed tablolar için insert kullanılır
APPEND wa_itab to itab.
APPEND LINES OF ITAB1 TO ITAB2. "itab + itab
******* /APPEND *************

******* INSERT *************
*Insert: Standard tablelarda kayıt ekler, sorted tablelarda istenilen bir noktaya kayıt ekler, hashed tablelarda  hash algoritmasına göre ekler
INSERT wa_itab INTO TABLE itab <condition>.
"Bir internal table ile çok miktarda kayıt eklemek:
INSERT itab2 <condition2> FROM <connection1>.
INSERT CUSTOMERS FROM TABLE t_iTAB. "Database tablosuna internal tablo ile veri atma

LOOP AT TAB INTO TAB_WA.
  INSERT INTO CUSTOMERS VALUES TAB_WA. "database tablosuna structure şle veri atma
ENDLOOP.
******* /INSERT *************

******* DELETE *************
*Delete: Internal tabledan bir satır siler
DELETE TABLE itab FROM wa_itab.
DELETE ADJACENT DUPLICATES FROM ITAB COMPARING K.
DELETE itab [ INDEX index I WHERE condition ].
DELETE ITAB FROM 450 TO 550.
DELETE itab WHERE field NOT IN select_option...
DELETE DBTABLE where field eq 'something'.
******* /DELETE *************

******* UPDATE *************
UPDATE dbtable set isim = 'Özkan' where id = '12'.
commit work.
******* /UPDATE *************

******* MODIFY *************
*Modify: Internal tableın bir satırın aynı tipteki bir structurla günceller
MODIFY TABLE itab FORM wa_itab <conditions>.
MODIFY dbtable from table gt_data. "Tablodaki verelere göre db tablosunu günceller"
******* /MODIFY *************

******* READ *************
*Read: Internal table''ın bir satırındaki veriyi bir structurea kopyalar

"Binary SEARCH kullanmadan önce sort ile internal table sıralanmalı
READ TABLE it_header INTO wa_header with key order_number = ls_siparis-sip_no
                            order_type = 'ZP04' BINARY SEARCH.

data(lv_countit) = lines( gt_data ). " Satır sayısını al"

*>7.40------------------
TRY.
    wa_header = it_header[ order_number = ls_siparis-sip_no
                           order_type = 'ZP04' ].
  CATCH cx_sy_itab_line_not_found.
ENDTRY.

field-SYMBOLS <fs_tab> like LINE OF lt_splfi.
ASSIGN lt_splfi[ 30 ] to <fs_tab> .
IF sy-subrc = 0.
    "do something
ENDIF.

assign gt_makineler[ 1 ] to FIELD-SYMBOL(<fs_makine>).
*--------------------
******* /READ *************

******* /SORT *************
"Sort: Tablolar herhangi bir sütuna göre aşağı veya yukarı yönlü sıralanabilir. Sorted Table''lar sıralanamaz
SORT itab.
SORT it_flight by percentage. "!Tavsiye edilen!"
sort gt_data by fiel1 field2.
sort lt_zmii_f2_adres by barkod tarih descending saat descending.
******* /SORT *************

******* COLLECT *************
* Collect: Hangi malzeme numarasından hangi malzemelerden kaç tane var
* karakter alanları farklı olanları alt alta yazıyor, aynı karakter tipindeki numerik alanları toplar.
loop at gt_data int gs_data.
  Collect gs_data into gt_data3.
ENDLOOP.
******* /COLLECT *************

"Tabloları kopyalamak COPY:
ITAB2[] = ITAB1[].

"Tabloları karşılaştırmak:
IF ITAB1[] = ITAB2[].
" ...
ENDIF.
* Two internal tables are equal if
* they have the same number of lines and
* each pair of corresponding lines is equal.

******* /CLEAR *************
*Clear: Tabloyu temizler
CLEAR itab[].
Refresh ": Clear gibi çalışır
FREE ": Tabloyu siler ve hafızanın tutulan alanını serbest bırakır
******* /CLEAR *************

******************************************
* > 7.40 nested table - iç içe tablo
TYPES:
  BEGIN OF struc1,
    col1 TYPE i,
    col2 TYPE i,
  END OF struc1,
  itab1 TYPE TABLE OF struc1 WITH EMPTY KEY,
  itab2 TYPE TABLE OF itab1 WITH EMPTY KEY,
  BEGIN OF struc2,
    col1 TYPE i,
    col2 TYPE itab2,
  END OF struc2,
  itab3 TYPE TABLE OF struc2 WITH EMPTY KEY.
DATA(itab) = VALUE itab3(
   ( col1 = 1  col2 = VALUE itab2(
                       ( VALUE itab1(
                           ( col1 = 2 col2 = 3 )
                           ( col1 = 4 col2 = 5 ) ) )
                       ( VALUE itab1(
                           ( col1 = 6 col2 = 7 )
                           ( col1 = 8 col2 = 9 ) ) ) ) )
   ( col1 = 10 col2 = VALUE itab2(
                       ( VALUE itab1(
                           ( col1 = 11 col2 = 12 )
                           ( col1 = 13 col2 = 14 ) ) )
                       ( VALUE itab1(
                           ( col1 = 15 col2 = 16 )
                           ( col1 = 17 col2 = 18 ) ) ) ) ) ).
DATA(num2) = itab[ 2 ]-col2[ 1 ][ 2 ]-col1.
*******************************************
