

fi [not] exp [ and [not] exp ] [ or [not] exp ].
	----
[elseif exp].
	----
[else].
endif.

IF p_string eq c_abc.
  NEW-LINE.
  WRITE: p_string, 'Sabit degerimiz', c_abc,'e eşit'.
else.
  WRITE: / p_string, 'Sabit degerimiz', c_abc,'e eşit değil'.
ENDIF.

IF p_string co c_abc. " contains only
  WRITE: / p_string, 'contains only characters from', c_abc.
ENDIF.
*contains only: eğer karşılaştırılan karakterlerin içerisinde birbirinde
* olmayan herhangi bir karakter yoksa true döner
* örn: AAAABBBBBCCCC co ABCDEF true döner

IF p_string cn c_abc. " contains not only
  WRITE: / p_string, 'contains not only characters from', c_abc.
ENDIF.
* AAAAAZZZZBBBB cn ABCDEF true döner

IF p_string ca c_abc. " contains any
  WRITE: / p_string, 'en azından bir karakter eşit', c_abc.
ENDIF.
* AAAAZZZZZBBBB ca ABCDEF true döner

IF p_string na c_abc. " contains not any
  WRITE: / p_string, 'hiçbir karakter eşit değil', c_abc.
ENDIF.
* QQWW na ABCDEF true döner

IF p_string cs c_abc. " contains string
  WRITE: / p_string, 'string ifade içerir', c_abc.
ENDIF.

IF p_string ns c_abc. " contains no string
  WRITE: / p_string, 'string ifade içermez', c_abc.
ENDIF.

IF p_string cp c_abc. " contains pattern
  WRITE: / p_string, 'desenler uyuştu', c_abc.
ENDIF.

IF p_string np c_abc. " contains no pattern
  WRITE: / p_string, 'herhangi bir desen tekrar yok', c_abc.
ENDIF.

--------------- Örnek -----------
report ztx1001.
data: begin of s1,
		x value 'X',
		y value 'Y',
		z value 'Z',
		end of s1,
	begin of s2,
		x value 'X',
		z value 'Z',
		end of s2.

if s1-x = s2-x.
	write: / s1-x, '=', s2-x.
else.
	write: / s1-x, '<>', s2-x.
endif.

-------------------------------------

-------------- Örnek 2 ------------
report ztx1002.
parameters: f1 default 'A',
			f2 default 'B',
			f3 default 'C'.

if f1 = f2.
	write: / f1, '=', f2.
elseif f1=f3.
	write: / f1, '=', f3.
else
	write: 'Something else'.

------------------------------------

*---------------- Not Equal ---------

SELECT * FROM scarr into wa_scarr.
         if sy-subrc ne 0.
             write : 'no data found!'.
       endif.
   ENDSELECT.

veya

SELECT * FROM scarr into wa_scarr.
	if sy-subrc <> 0. 
		write / 'No data found'.
	endif.
ENDSELECT.

*-------------------------------------
*------------ CP--------------------
IF FLD CP 'IT_SPFLI*' AND SY-SUBRC = 0.
       "it_spfli ile başlayan tün değerler	"
ENDIF.