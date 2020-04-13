TYPES: BEGIN OF ty_mara2,
         matnr TYPE matnr,
         ersda TYPE ersda,
         laeda TYPE laeda,
         ernam TYPE mara-ernam,
         aenam TYPE mara-aenam,
       END OF ty_mara2.

DATA(out) = cl_demo_output=>new( ).

SELECT matnr, ersda, laeda, aenam FROM mara
    INTO TABLE @DATA(lt_mara)
    UP TO 3 ROWS
    ORDER BY ersda.

DATA lt_mara2 TYPE TABLE OF ty_mara2.
lt_mara2 = VALUE #( ( matnr = 'aaaa' ) ).
"base kısmındaki tabloya zarar vermeden diğer tabloyu ekler
lt_mara2 = CORRESPONDING #( BASE ( lt_mara2 ) lt_mara ).
out->write( lt_mara2 ).
*MATNR               ERSDA       LAEDA       ERNAM  AENAM
*aaaa                0000-00-00  0000-00-00
*000000000000001352  2018-07-23  2019-11-04         NGORTAY
*000000000012121216  2018-08-09  2018-08-09         HBURSTEDDE
*000000000009000013  2018-08-16  2019-11-25         HBURSTEDDE

"base kısmındaki tabloyu koruyarak farklı tipteki structure ekler
lt_mara2 = VALUE #( ( matnr = 'aaaa' ) ).
LOOP AT lt_mara ASSIGNING FIELD-SYMBOL(<mara>).
  lt_mara2 = VALUE #( BASE lt_mara2 ( CORRESPONDING #( <mara> ) ) ).
ENDLOOP.
out->write( lt_mara2 ).
*MATNR               ERSDA       LAEDA       ERNAM  AENAM
*aaaa                0000-00-00  0000-00-00
*000000000000001352  2018-07-23  2019-11-04         NGORTAY
*000000000012121216  2018-08-09  2018-08-09         HBURSTEDDE
*000000000009000013  2018-08-16  2019-11-25         HBURSTEDDE

t_alv_data = CORRESPONDING #( lt_db_Data MAPPING prodh = general-prodh ).

out->display(  ).