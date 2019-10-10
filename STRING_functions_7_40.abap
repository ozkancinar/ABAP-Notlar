"COMPARISON
COND #( WHEN text1 < text2 THEN |{ text1 } < { text2 }|
             WHEN text1 > text2 THEN |{ text1 } > { text2 }|
                                ELSE |{ text1 } = { text2 }| ) ).

"CONCATENATION
 |Optimization factor: { t21 / t43 }|

"DISTANCE
index_tab = cl_abap_docu=>get_abap_index(
      COND #( WHEN sy-langu <> 'D'
                      THEN 'E'
                      ELSE 'D' ) ).
    LOOP AT index_tab->* ASSIGNING FIELD-SYMBOL(<index>).
      DATA(str1) = to_upper( val = <index>-key1 ).
      DATA(str2) = to_upper( val = word ).
      DATA(max) = COND i( WHEN strlen( str1 ) > strlen( str2 )
                            THEN strlen( str1 )
                            ELSE strlen( str2 ) ).
      max = ( 100 - percent  ) * max / 100 + 1.
      DATA(dist) = distance( val1 = str1 val2 = str2 max = max ).
      IF dist < max.
        distances = VALUE #( BASE distances
                            ( text = str1 dist = dist ) ).
      ENDIF.
    ENDLOOP.

"TEMPLATE_ALIGN_PAD
cl_demo_output=>new(
     )->write( |{ 'Left'   WIDTH = 20 ALIGN = LEFT   PAD = pad }<---|
     )->write( |{ 'Center' WIDTH = 20 ALIGN = CENTER PAD = pad }<---|
     )->write( |{ 'Right'  WIDTH = 20 ALIGN = RIGHT  PAD = pad }<---|
     )->display( ).

"TEMPLATE_ALPHA"
IF width = 0.
     resultstring_in   = |{ textstring ALPHA = IN  }|.
     output( title = `String, IN` text = resultstring_in ).
     <resultfield_in>  = |{ textstring ALPHA = IN  }|.
     output( title = `Field,  IN` text = <resultfield_in> ).
     resultstring_out  = |{ textstring ALPHA = OUT }|.
     output( title = `String, OUT` text = resultstring_out ).
     <resultfield_out> = |{ textstring ALPHA = OUT }|.
     output( title = `Field,  OUT` text = <resultfield_out> ).
   ELSE.
     resultstring_in   = |{ textstring ALPHA = IN  WIDTH = width }|.
     output( title = `String, IN` text = resultstring_in ).
     <resultfield_in>  = |{ textstring ALPHA = IN  WIDTH = width }|.
     output( title = `Field,  IN` text = <resultfield_in> ).
     resultstring_out  = |{ textstring ALPHA = OUT WIDTH = width }|.
     output( title = `String, OUT` text = resultstring_out ).
     <resultfield_out> = |{ textstring ALPHA = OUT WIDTH = width }|.
     output( title = `Field,  OUT` text = <resultfield_out> ).
   ENDIF.

"TEMPLATE_CASE
ASSIGN cl_abap_format=>(format-name) TO <case>.
APPEND |{ format-name WIDTH = 20 }| &
          |{ 'UPPER CASE, lower case ' CASE = (<case>) }|
          TO output.

"TEMPLATE_CTRL_CHAR
cl_demo_output=>display(
     |First line.\r\ttab\ttab\ttab\n\ttab\ttab\ttab\rLast line.| ).

"TEMPLATE_DATE_FORM
result-result = |{ sy-datum COUNTRY = land }|.

"TEMPLATE_ENV_SETT
LOOP AT country_tab INTO country.
     DATA(tabix) = sy-tabix.
     SET COUNTRY country-key.
     results = VALUE #( BASE results
     ( name      = country-name
       key       = country-key
       number    = |{ num    NUMBER    = ENVIRONMENT }|
       date      = |{ date   DATE      = ENVIRONMENT }|
       time      = |{ time   TIME      = ENVIRONMENT }|
       timestamp = |{ tstamp TIMESTAMP = ENVIRONMENT }| ) ).
     IF tabix = 1.
       results = VALUE #( BASE results ( ) ).
     ENDIF.
   ENDLOOP.

"TEMPLATE_NUMB_FORM"
 results = VALUE #( BASE results
         ( xdezp  = xdezp
           format = |{ number COUNTRY = land }| ) ).

"TEMPLATE_SIGN
formats =
  CAST cl_abap_classdescr(
         cl_abap_classdescr=>describe_by_name( 'CL_ABAP_FORMAT' )
         )->attributes.
DELETE formats WHERE name NP 'S_*' OR is_constant <> 'X'.

LOOP AT formats INTO format.
  ASSIGN cl_abap_format=>(format-name) TO <sign>.
  APPEND |{ format-name WIDTH = 16 }  | &
         |"{ num1 SIGN = (<sign>) }"  | &
         |"{ num2 SIGN = (<sign>) }"  | TO results.

"TEMPLATE_TIMEZONE"
<timezone>-datetime = |{ tstamp TIMEZONE  = <timezone>-tzone
                                     TIMESTAMP = USER }|.

"TEMPLATE_TIME_FORM"
result-raw = |{ <time> TIME = RAW }|.
result-iso = |{ <time> TIME = ISO }|.

cl_demo_output=>write(
  VALUE result(
    FOR j = 1 UNTIL j > strlen( sy-abcde )
    ( |{ substring( val = sy-abcde len = j )
         WIDTH = j + 4 }<---| ) ) ).

"TEMPLATE_WIDTH"
cl_demo_output=>display(
  VALUE result(
    FOR j = 1 UNTIL j > strlen( sy-abcde )
    ( |{ substring( val = sy-abcde len = j )
         WIDTH = strlen( sy-abcde ) / 2 } <---| ) ) ).

"TEMPLATE_XSD
 DATA: i          TYPE i            VALUE -123,
       int8       TYPE int8         VALUE -123,
       p          TYPE p DECIMALS 2 VALUE `-1.23`,
       decfloat16 TYPE decfloat16   VALUE `123E+1`,
       decfloat34 TYPE decfloat34   VALUE `-3.140000E+02`,
       f          TYPE f            VALUE `-3.140000E+02`,
       c          TYPE c LENGTH 3   VALUE ` Hi`,
       string     TYPE string       VALUE ` Hello `,
       n          TYPE n LENGTH 6   VALUE `001234`,
       d          TYPE d            VALUE `20020204`,
       t          TYPE t            VALUE `201501`,
       x          TYPE x LENGTH 3   VALUE `ABCDEF`,
       xstring    TYPE xstring      VALUE `456789AB`.

 DEFINE write_template.
   APPEND |{ &1 width = 14  }| &&
          |{ &2 width = 30  }| &&
          |{ &2 xsd   = yes }| TO result.
 END-OF-DEFINITION.

 FORMAT FRAMES OFF.
 write_template `i`          i.
 write_template `int8`       int8.
 write_template `p`          p.
 write_template `decfloat16` decfloat16.
 write_template `decfloat34` decfloat34.
 write_template `f`          f.
 APPEND `` TO result.
 write_template `c`          c.
 write_template `string`     string.
 write_template `n`          n.
 write_template `d`          d.
 write_template `t`          t.
 APPEND `` TO result.
 write_template `x`          x.
 write_template `xstring`    xstring.
 cl_demo_output=>display( result ).
ENDMETHOD.

*--------SUBSTRING
"Substring with Offset and length
result = substring( val = ‘ABCDEFGH’ off = 2 len = 3 ). "OUTPUT:   CDE
data(barcode) = 'M000012367'.
data(res) = substring( val = barcode off = 1 ).
"Substring From
result = substring_from( val = ‘ABCDEFGH’ sub = ‘CD’ ). "OUTPUT:   CDEFGH
"Substring After
result = substring_after( val = ‘ABCDEFGH’ sub = ‘CD’ ). "OUTPUT:   EFGH
"Substring Before
result = substring_brfore( val = ‘ABCDEFGH’ sub = ‘CD’ ). "OUTPUT:   AB
"Substring To
result = substring_to( val = ‘ABCDEFGH’ sub = ‘CD’ ). " OUTPUT:   ABCD
