
write ls_mara-menge to lv_str unit ls_mara-meins.

*  write data
* Header:
  write: / 'index' , 20 'Belge No', 30 'Kalem No', 40 'Malzeme', 60 'Fiyat'.
* Elements:
  loop at gt_vbap.
    write: / sy-tabix under 'index' left-justified, ' ', gt_vbap-vbeln under 'Belge No'
    , ' ', gt_vbap-posnr under 'Kalem No', ' ', gt_vbap-matnr under 'Malzeme', ' '.
    if gt_vbap-netwr ge p_tutar.
      write : gt_vbap-netwr color 5 under 'Fiyat'.
    else.
        write : gt_vbap-netwr color 6 under 'Fiyat'.
    endif.
    lv_toplam = lv_toplam + gt_vbap-netwr.
  endloop.
  write: / 'Toplam:', lv_toplam under 'Fiyat'.

"----------------------------------"
"Çizgi çiz"
  write: /5(82) sy-uline,
         19 line_bottom_middle_corner as line,
          21 line_bottom_middle_corner as line.

write: /5(15) sy-uline,
 /5 sy-vline, sym_documents as symbol,
 lt_nakliye-regio, 19 sy-vline,
 /5(82) sy-uline,
 19 line_cross as line,
 21 line_top_middle_corner as line.

"---------------------------------------------------------"
  … NO-ZERO
… NO-SIGN
… DD/MM/YY
… MM/DD/YY
… DD/MM/YYYY
… MM/DD/YYYY
… DDMMYY
… MMDDYY
… YYMMDD
… CURRENCY w
… DECIMALS d
… ROUND r
… UNIT u
… EXPONENT e

WRITE lv_date to lv_date2 DD/MM/YYY. "Birinci değişkeni lv_date2'ye belirtilen formatta yazar

*Ekrana yazdıralım

WRITE: / 'Formatlı tarih:' , lv_date2. "DD.MM.YYYY.

* Zaman için uygulayalım
DATA lv_time2 TYPE c LENGTH 30.
WRITE lv_time to lv_time2 USING EDIT MAST '__:__:__'. "Formatı belirliyoruz


  … USING EDIT MASK mask
… USING NO EDIT MASK

… UNDER g (only with WRITE )
… NO-GAP (only with WRITE )

… LEFT-JUSTIFIED
… CENTERED
… RIGHT-JUSTIFIED

Note
The formatting options UNDER g and NO-GAP are intended only output to lists and therefore cannot be used with WRITE … TO .

Option
… NO-ZERO

Effect
If the contents of f are equal to zero, only blanks are output; if f is of type C or N , leading zeros are replaced by blanks.

Option
… NO-SIGN

Effect
The leading sign is not output if f is of type I , P or F .

Option
… DD/MM/YY
Option
… MM/DD/YY

Effect
If
f is a date field (type D ), the date is output with a 2-character year
as specified in the user’s master record. Both of these formatting
options have the same value.

Option
… DD/MM/YYYY
Option
… MM/DD/YYYY

Effect
If
f is a date field (type D ), the date is output with a 4-character year
as specified in the user’s master record. Both of these formatting
options have the same value.

Option
… DDMMYY
Option
… MMDDYY

Effect
Date formatting like the additions … DD/MM/YY and … MM/DD/YY , but without separators.

Option
… YYMMDD

Effect
If f is a date field (type D ), the date is output in the format YYMMDD (YY = year, MM = month, DD = Day).

Option
… CURRENCY w

Effect
Correct format for currency specified in the field w .
Treats
the contents of f as a currency amount. The currency specified in w
determines how many decimal places this amount should have.
The
contents of w are used as a currency key for the table TCURX ; if there
is no entry for w , the system assumes that the currency amount has 2
decimal places.

Option
… DECIMALS d

Effect
d
specifies the number of decimal places for a number field (type I , P
or F ) in d . If this value is smaller than the number of decimal
places in the number, the number is rounded. If the value is greater,
the number is padded with zeros.
Since accuracy with floating point
arithmetic is up to about 15 decimal places (see ABAP/4 number types ),
up to 17 digits are output with floating point numbers (type F ). (In
some circumstances, 17 digits are needed to differentiate between two
neighboring floating point numbers.) If the output length is not
sufficient, as many decimal places as possible are output. Negative
DECIMALS specifications are treated as DECIMALS 0 .

Example
Effect of different DECIMALS specifications:

DATA: X TYPE P DECIMALS 3 VALUE ‘1.267’,
Y TYPE F VALUE ‘125.456E2’.

WRITE: /X DECIMALS 0, “output: 1
/X DECIMALS 2, “output: 1.27
/X DECIMALS 5, “output: 1.26700
/Y DECIMALS 1, “output: 1.3E+04
/Y DECIMALS 5, “output: 1.25456E+04
/Y DECIMALS 20. “output: 1.25456000000000E+04

Option
… ROUND r

Effect
Scaled output of a field of type P .

The decimal point is first moved r places to the left ( r > 0) or to the right ( r < hour =" '1.230'.">.
ASSIGN ‘First Name’ TO .

WRITE: /3 ‘Name'(001), 15 , 30 ‘RoomNo’, 40 ‘Age'(002).
…
WRITE: / ‘Peterson’ UNDER 'Name'(001),
‘Ron’ UNDER ,
‘5.1’ UNDER ‘RoomNo’,
(5) 24 UNDER TEXT-002.

This produces the following output (numbers appear right-justified in their output fields!):

Name First Name RoomNo Age
Peterson Ron 5.1 24

Option
… NO-GAP

Effect
Suppresses the blank after the field f . Fields output one after the other are then displayed without gaps.

Example
Output several literals without gaps:

WRITE: ‘A’ NO-GAP, ‘B’ NO-GAP, ‘C’. “Output: ABC

If
NO-GAP was not specified here, the output would have been ” A B C ”
because one blank is always implicitly generated between consecutive
output fields.

Option
… LEFT-JUSTIFIED
… CENTERED
… RIGHT-JUSTIFIED

Effect
Left-justified, centered or right-justified output.
For
number fields (types I , P and F ), RIGHT-JUSTIFIED is the standard
output format, but LEFT-JUSTIFIED is used for all other types, as well
as for templates.

Examples
Output to a list ( WRITE ):

DATA: FIELD(10) VALUE ‘abcde’.

WRITE: / ‘|’ NO-GAP, FIELD LEFT-JUSTIFIED NO-GAP, ‘|’,
/ ‘|’ NO-GAP, FIELD CENTERED NO-GAP, ‘|’,
/ ‘|’ NO-GAP, FIELD RIGHT-JUSTIFIED NO-GAP, ‘|’.

* Output: |abcde |
* | abcde |
* | abcde|

Formatting in a program field ( WRITE…TO… )

DATA: TARGET_FIELD1(10),
TARGET_FIELD2 LIKE TARGET-FIELD1,
TARGET_FIELD3 LIKE TARGET-FIELD1.

WRITE: ‘123’ LEFT-JUSTIFIED TO TARGET-FIELD1,
‘456’ CENTERED TO TARGET-FIELD2,
‘789’ RIGHT-JUSTIFIED TO TARGET-FIELD3.

WRITE: / ‘|’ NO-GAP, TARGET_FIELD1 NO-GAP, ‘|’,
/ ‘|’ NO-GAP, TARGET-FIELD2 NO-GAP, ‘|’,
/ ‘|’ NO-GAP, TARGET_FIELD3 NO-GAP, ‘|’.

* Output: |123 |
* | 456 |
* | 789|

Notes
Specifying several formatting options

You
can use the additions of the first group ( NO-ZERO , NO-SIGN , DD/MM/YY
etc., CURRENCY , DECIMALS , ROUND , EXPONENT ) simultaneously, provided
it makes sense. You can combine the additions UNDER and NO-GAP with all
other additions in any permutation; however, they are not taken into
account until the field f has been formatted according to all the other
options.
Templates, conversion routines and alignment

If you
want to format a field using a special conversion routine , all the
other additions (apart from UNDER and NO-GAP ) are ignored. This also
applies if the conversion routine is not explicitly specified, but
comes from the ABAP/4 Dictionary .
If you want to format a field
using a template , the system first takes into account the options of
the first group, and then places the result in the template. However,
if you specify one of the date-related formatting options ( DD/MM/YY
etc.), the template is ignored.
Finally, the formatted field or the
template is copied to the target field according to the requested
alignment . For type C fields, it is the occupied length that is
relevant, not the defined length; this means that trailing blanks are
not taken into account.
Combined usage of CURRENCY , DECIMALS and ROUND

The rounding factor (from the right) in

WRITE price CURRENCY c ROUND r DECIMALS d

results from the formula

rounding factor = c + r – d .

If DECIMALS is not specified, d = c applies.

You read this formula in the following manner:

The
field price is supposed to be of ABAP/4 type P (or I ); it contains a
currency amount. The CURRENCY specification expresses how many decimal
places price is to have and may differ from the definition of price
(the decimal point is not stored internally, but comes from the type
attributes of price ). Normally, price is output with as many decimal
places as the field has internally according to the type attributes or
the CURRENCY specification. You can override this number of output
decimal places with DECIMALS . The addition ROUND addition moves the
decimal point r places to the left, if r is positive, otherwise to the
right. This means that a $ amount is output with ROUND 3 in the unit
1000 $.

According to the above formula, there can also be a
“negative” rounding factor; then, the corresponding number of zeros is
appended to the amount price on the right using the “rounding factor”.
However, the value of “rounding factor” must be at least equal to -14.
Currency fields and DATA with DECIMALS

If
the field price is normally formatted with decimal places (e.g. fields
for currency amounts), these are treated like a CURRENCY specification
when rounding, if CURRENCY was not expressly specified.
If present, the DECIMALS specification defines how many decimal places are to be output after rounding.
If
the DECIMALS and the (explicit or implicit) CURRENCY specifications are
different, rounding takes place according to the above formula, even if
no ROUND specification was made (i.e. r = 0).
If a field in the DATA statement was declared with DECIMALS n , WRITE treats it like a currency field with n decimal places.

Examples
Sales in pfennigs or lira: 246260
Unit TDM or TLira with 1 decimal place.

DATA SALES TYPE P VALUE 246260.
WRITE SALES CURRENCY ‘DEM’ ROUND 3 DECIMALS 1. ” 2,5 TDM
WRITE SALES CURRENCY ‘ITL’ ROUND 3 DECIMALS 1. ” 246,3 TLira

Sales in pfennigs or lira: 99990
Unit TDM or TLira with 1 decimal place.

SALES = 99990.
WRITE SALES CURRENCY ‘DEM’ ROUND 3 DECIMALS 1. ” 1,0 TDM
WRITE SALES CURRENCY ‘ITL’ ROUND 3 DECIMALS 1. ” 100,0 TLira

Sales in pfennigs or lira: 93860
Unit 100 DM or 100 lira with 2 decimal places:

SALES = 93860.
WRITE SALES CURRENCY ‘DEM’ ROUND 2 DECIMALS 2. ” 9,38 HDM
WRITE SALES CURRENCY ‘ITL’ ROUND 2 DECIMALS 2. ” 938,60 HLira

Sales in pfennigs: 93840
Unit 1 DM without decimal places.

SALES = 93860
WRITE SALES CURRENCY ‘DEM’ DECIMALS 0. ” 938 DM

Sales in pfennigs: 93860
Unit 1 DM without decimal places.

SALES = 93860.
WRITE SALES CURRENCY ‘DEM’ DECIMALS 0. ” 939 DM

Note
Runtime errors

WRITE_CURRENCY_ILLEGAL_TYPE : CURRENCY parameter with WRITE is not type C
WRITE_ROUND_TOO_SMALL : Rounding parameter is less than -14
WRITE_UNIT-ILLEGAL_TYPE : UNIT parameter with WRITE is not type C
