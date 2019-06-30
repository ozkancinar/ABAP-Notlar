*&---------------------------------------------------------------------*
*& Report ZOZ_TEST1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoz_test1.
DATA:  lt_sflight TYPE TABLE OF sflight.

SELECT DISTINCT * FROM sflight
   INTO TABLE @DATA(lt_flight1)
    UP TO 1000 ROWS.

 data(if_true) = boolc( lt_flight1[] is not initial ).
 data(if1) = boolc( lt_sflight[] is not initial ).

if boolc( lt_sflight[] is not initial ) = abap_false.
  write 'boş'.
else.
  write 'dolu'.
endif.

 write if_true.

 if if_true.
   write 'true'.
 endif.

*****************For Until Then**************************
TYPES:
  BEGIN OF line,
    col1 TYPE i,
    col2 TYPE i,
    col3 TYPE i,
  END OF line,
  itab TYPE STANDARD TABLE OF line WITH EMPTY KEY.

DATA(lt_data1) = VALUE itab( FOR i = 0 THEN i + 10 while i <= 20
                             ( col1 = i col2 = i + 1 col3 = i + 2 ) ).

LOOP AT lt_data1 ASSIGNING FIELD-SYMBOL(<fs_data>).
  WRITE: / <fs_data>-col1, <fs_data>-col2, <fs_data>-col3.
ENDLOOP.
*****************/For Until Then*************************

*****************For Value with Structure**************************
TYPES: BEGIN OF ty_flight,
         carrid TYPE s_carr_id,
         connid TYPE s_conn_id,
         fldate TYPE s_date,
       END OF ty_flight,
       ty_data TYPE STANDARD TABLE OF ty_flight WITH EMPTY KEY.
*ls_data daha öncesinde tanımlanmadı for içerisinde tanımlandı

DATA(lt_data2) = VALUE ty_flight( FOR ls_data IN lt_flight1
                                WHERE ( connid > 17 ) ( carrid = ls_data-carrid
                                                            connid = ls_data-connid
                                                            fldate = ls_data-fldate ) ).
LOOP AT lt_data2 ASSIGNING FIELD-SYMBOL(<fs_data2>).
  WRITE: / <fs_data2>-carrid, <fs_data2>-connid, <fs_data2>-fldate.
ENDLOOP.
*****************/For Value with Structure*************************

*****************Reduce**************************
DATA(lv_sum) = REDUCE i( INIT x = 0 FOR wa IN lt_flight1
                         NEXT x = x + wa-price ).
WRITE lv_sum.
*****************/Reduce*************************

***************** Switch**************************
DATA: lv_indicator LIKE scal-indicator.
CALL FUNCTION 'DATE_COMPUTE_DAY'
  EXPORTING
    date = sy-datum    " Date of weekday to be calculated
  IMPORTING
    day  = lv_indicator.   " Weekday

DATA(lv_day) = SWITCH char10( lv_indicator
                              WHEN 1 THEN 'Pazartesi'
                              WHEN 2 THEN 'Salı'
                              WHEN 3 THEN 'Çarşamba'
                              WHEN 4 THEN 'Perşembe'
                              WHEN 5 THEN 'Cuma'
                              WHEN 6 THEN 'Cumartesi' ).
WRITE lv_day.
*****************/ Switch*************************

*****************Corresponding**************************
TYPES: BEGIN OF line1, col1 TYPE i, col2 TYPE i, END OF line1.
TYPES: BEGIN OF line2, col1 TYPE i, col2 TYPE i, col3 TYPE i, END OF line2.
data ls_line1 TYPE line1.

ls_line1 = VALUE #( col1 = 1 col2 = 2 ).

WRITE: / 'ls_line1 =' , ls_line1-col1, ls_line1-col2.

DATA(ls_line2) = VALUE line2( col1 = 4 col2 = 5 col3 = 6 ).

WRITE: / 'ls_line2 =' ,15 ls_line2-col1, ls_line2-col2, ls_line2-col3.
SKIP 2.

*ls_line2 = CORRESPONDING #( ls_line1 ).
*WRITE: / 'ls_line2 CORRESPONDING #( ls_line1 ) =' ,40 ls_line2-col1, ls_line2-col2, ls_line2-col3.

*ls_line2 = CORRESPONDING #( BASE ( ls_line2 ) ls_line1 ).
*WRITE: / 'ls_line2 CORRESPONDING #( BASE ( ls_line2 ) =' ,50 ls_line2-col1, ls_line2-col2, ls_line2-col3.

ls_line2 = CORRESPONDING #( ls_line1 mapping col1 = col1 col2 = col1 EXCEPT col3  ). "bir alanın başka bir alana atanması için kullanılır
WRITE: / 'ls_line2 CORRESPONDING #( ls_line1 mapping' , 50 ls_line2-col1, ls_line2-col2, ls_line2-col3.
*****************/Corresponding*************************

*****************Write**************************
WRITE / |{ 'Left'     WIDTH = 20 ALIGN = LEFT   PAD = '-' }|.
WRITE / |{ 'Centre'   WIDTH = 20 ALIGN = CENTER PAD = '0' }|.
WRITE / |{ 'Right'    WIDTH = 20 ALIGN = RIGHT  PAD = '0' }|.

WRITE / |{ 'Text' CASE = (cl_abap_format=>c_raw) }|.
WRITE / |{ 'Text' CASE = (cl_abap_format=>c_upper) }|.
WRITE / |{ 'Text' CASE = (cl_abap_format=>c_lower) }|.

WRITE / |{ sy-datum DATE = ISO }|.           "Date Format YYYY-MM-DD
WRITE / |{ sy-datum DATE = User }|.          "As per user settings
WRITE / |{ sy-datum DATE = Environment }|.   "Formatting setting of language environme
*****************/Write*************************

*****************Loop at Group By**************************
loop at lt_flight1 INTO data(ls_data) GROUP BY ( connid = ls_data-connid "fldate = ls_data-fldate
                                                  size = GROUP SIZE
                                                  index = GROUP INDEX )
                                                  assigning field-symbol(<fs_group>).

  WRITE: / 'Connid:', <fs_group>-connid, 'Size:', <fs_group>-size, 'Index:', <fs_group>-index.
  LOOP AT GROUP <fs_group> ASSIGNING FIELD-SYMBOL(<fs_data2>).
    WRITE: / ,5 <fs_data2>-carrid, <fs_data2>-connid, <fs_data2>-fldate.
  ENDLOOP.
endloop.
*****************/Loop at Group By*************************

***************** MESH **************************
TYPES: BEGIN OF ty_ucus,
         carrid TYPE sflight-carrid,
         connid TYPE sflight-connid,
         fldate TYPE sflight-fldate,
       END OF ty_ucus,
       tt_ucus TYPE SORTED TABLE OF ty_ucus WITH NON-UNIQUE KEY carrid.

TYPES: BEGIN OF ty_sirket,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         currcode TYPE scarr-currcode,
       END OF ty_sirket,
       tt_sirket TYPE SORTED TABLE OF ty_sirket WITH NON-UNIQUE KEY carrid.

TYPES: BEGIN OF MESH m_bilet, "ilişkili bir structure yaratmak için kullanılır
         ucus   TYPE tt_ucus ASSOCIATION sirket_detay TO sirket ON carrid = carrid,
         sirket TYPE tt_sirket ASSOCIATION ucus_detay TO ucus ON carrid = carrid,
       END OF MESH m_bilet.
DATA: ls_bilet TYPE m_bilet.

DATA: lt_ucus   TYPE tt_ucus,
      lt_sirket TYPE tt_sirket.

SELECT * FROM sflight
   INTO CORRESPONDING FIELDS OF TABLE lt_ucus
    UP TO 1000 ROWS.

SELECT * FROM scarr
    INTO CORRESPONDING FIELDS OF TABLE lt_sirket.

DELETE ADJACENT DUPLICATES FROM lt_ucus COMPARING carrid.

ls_bilet-ucus = lt_ucus.
ls_bilet-sirket = lt_sirket.

"Uçuş bilgisi içerisinde hava yolu adını yaz
LOOP AT lt_ucus ASSIGNING FIELD-SYMBOL(<fs_ucus>).
  DATA(ls_data) = ls_bilet-ucus\sirket_detay[ <fs_ucus> ].
  WRITE: / ls_data-carrid, <fs_ucus>-fldate, ls_data-carrname, ls_data-currcode.
ENDLOOP.

ULINE.

"Hava yolundan uçuşa
DATA ls_data2 TYPE ty_ucus.
LOOP AT lt_sirket ASSIGNING FIELD-SYMBOL(<fs_sirket>).
  IF line_exists(  ls_bilet-sirket\ucus_detay[ <fs_sirket> ] ).
    ls_data2 = ls_bilet-sirket\ucus_detay[ <fs_sirket> ].
    WRITE: / ls_data2-carrid, ls_data2-connid, ls_data2-fldate.
  ENDIF.
ENDLOOP.
*****************/ MESH *************************

*****************FILTER**************************
types: BEGIN OF ty_ucak,
       connid TYPE sflight-connid,
       END OF ty_ucak,
       tt_ucak TYPE sorted TABLE OF ty_ucak WITH NON-UNIQUE KEY connid.

data lt_filtre TYPE tt_ucak. "sorted olmak zorunda


lt_filtre = VALUE #( ( connid = '17' )
                     ( connid = '26' ) ).
" connid 17 ve 26 olan satırlar
" lt_flight1 type STANDARD TABLE of sflight
data(lt_filtered_filght) = filter #( lt_flight1 in lt_filtre where connid eq connid ).

*---------------

data lt_flight3 TYPE SORTED TABLE OF sflight WITH NON-UNIQUE KEY connid.
lt_flight3[] = lt_flight1[].
"connid 26'dan büyük olan satırlar
data(lt_filtered) = FILTER #( lt_flight3 WHERE connid > CONV #( 26 ) ). "yalnızca sorted table kabul ediyor

*-------------
DATA spfli_tab TYPE STANDARD TABLE OF spfli
                   WITH EMPTY KEY
                   WITH NON-UNIQUE SORTED KEY carr_city "bir key yarattı
                        COMPONENTS carrid cityfrom.
    SELECT *
           FROM spfli
           INTO TABLE @spfli_tab.
"cityfrom frakfurt carrid lh olanlar
    DATA(extract) =
      FILTER #( spfli_tab USING KEY carr_city
                  WHERE carrid   = CONV #( to_upper( 'LH' ) ) AND
                        cityfrom = CONV #( to_upper( 'frankfurt' ) ) ).
    BREAK ocinar.
*****************/FILTER*************************

*****************String Format**************************
DATA : lv_num TYPE CHAR10 VALUE '0000000001'.

DATA(lv_without_zeros) = |{ lv_num ALPHA = OUT }|.
" lv_without_zeros value is now '1'.

DATA(lv_with_zeros) = |{ lv_without_zeros ALPHA = IN }|.
" lv_with_zeros value is now '0000000001'.

DATA: lv_string TYPE string.
lv_string = |This is string.|.

*****************/String Format*************************

*****************Lines**************************
SELECT carrid
       FROM scarr
       INTO TABLE @DATA(scarr_tab).

DESCRIBE TABLE scarr_tab LINES DATA(lines). "< 7.40
ASSERT lines = lines( scarr_tab ). "> 7.40
WRITE lines.
*****************/Lines*************************

*****************OO**************************
DATA lo_human TYPE REF TO class_human.
CREATE OBJECT lo_human EXPORTING NAME = 'TONY'.

lo_human = NEW class_human( name = ‘TONY’ ).


*data(lv_isim) = new char20( 'Özkan' ).


*****************/OO*************************



DATA itab TYPE TABLE OF scarr.
SELECT * FROM scarr INTO TABLE itab.
DATA wa LIKE LINE OF itab.
READ TABLE itab WITH KEY carrid = ‘lh’ INTO wa.
DATA output TYPE string.
CONCATENATE ‘carrier:’ wa-carrname INTO output SEPARATED BY space.
cl_demo_output=>display( output ).

************************************ SELECT STATEMENTS *************************************************

*****************CASE1**************************
DATA(else) = 'fffff'.
SELECT carrid, connid , fldate , ( carrid && ' ' && 'Özkan' ) as text1,
    case connid
      when '0017' then ( carrid && '17' )
      when '0026' then ( carrid && '26' )
      else @else
      end as text
      FROM sflight
      INTO TABLE @data(lt_result).


*****************/CASE*************************
*****************CASE2**************************
CONSTANTS: lc_l TYPE c LENGTH 20 VALUE '< 500 & eq AA',
           lc_ge TYPE c LENGTH 30 VALUE '> 500 & < 1000 & ne AA',
           lc_others  TYPE c LENGTH 20 VALUE 'Others'.

SELECT carrid, connid, fldate, price ,
    case when price < 500 and carrid eq 'AA' then @lc_l
         when price > 500 and price < 1000 and carrid ne 'AA' THEN @lc_ge
         else @lc_others
    end as durum
    FROM sflight
    INTO TABLE @data(lt_result1).
 BREAK ocinar.

*****************/CASE2*************************

*****************CONSTANTS IN SELECT**************************
DATA: lv_sta_time TYPE timestampl,
      lv_end_time TYPE timestampl,
      lv_diff_w   TYPE p DECIMALS 5.
DATA carrier TYPE scarr-carrid.
carrier = 'TR'.

GET TIME STAMP FIELD lv_sta_time.

SELECT SINGLE @abap_true
           FROM scarr
           WHERE carrid = @carrier
           INTO @DATA(exists).
IF exists = abap_true.
 write: |Carrier { carrier } exists in SCARR| .
ELSE.
  write: |Carrier { carrier } does not exist in SCARR| .
ENDIF.

GET TIME STAMP FIELD lv_end_time.
lv_diff_w = lv_end_time - lv_sta_time.
WRITE: (15) 'New Style', lv_diff_w, /.

GET TIME STAMP FIELD lv_sta_time.

SELECT SINGLE count( * )
           FROM scarr
           WHERE carrid = carrier.
IF sy-subrc eq 0.
 write: |Carrier { carrier } exists in SCARR| .
ELSE.
  write: |Carrier { carrier } does not exist in SCARR| .
ENDIF.
GET TIME STAMP FIELD lv_end_time.
lv_diff_w = lv_end_time - lv_sta_time.
WRITE: (15) 'Old Style', lv_diff_w.

*****************/CONSTANTS IN SELECT*************************

*****************SELECT ARİTMETİK İŞLEMLER**************************

SELECT carrid, connid, seatsmax_b, seatsmax_f,
          CAST( seatsmax_b AS FLTP ) / CAST( seatsmax_f AS FLTP ) AS ratio,
          DIV( seatsmax_b, seatsmax_f ) AS div,
          MOD( seatsmax_b, seatsmax_f ) AS mod,
          ABS( seatsmax_b - seatsmax_f ) AS fark
          FROM sflight
          WHERE  seatsocc_b  IS not NULL
          ORDER BY fark DESCENDING
          INTO TABLE @DATA(results)
          .
write: 'sonuç:'.
LOOP AT results ASSIGNING FIELD-SYMBOL(<fs_result>).
  WRITE: / <fs_result>-carrid, <fs_result>-connid, <fs_result>-seatsmax_b, <fs_result>-seatsmax_f.
ENDLOOP.

"*****************/SELECT ARİTMETİK İŞLEMLER*************************
