*&---------------------------------------------------------------------*
*& Report  ZLOJIK_IFADELER
*&
*&---------------------------------------------------------------------*
*& Lojik ifadeler ve karşılaştırma ifadeleri
*&
*&---------------------------------------------------------------------*

REPORT  ZLOJIK_IFADELER.

PARAMETERS p_number TYPE i.
PARAMETERS p_string type string.

CONSTANTS c_10 TYPE i VALUE 10.
CONSTANTS c_abc TYPE string VALUE 'ABCDEF'.

NEW-LINE.
WRITE: 'Sample number:', c_10.
NEW-LINE.
WRITE: 'Sample string:', c_abc.

IF p_number eq c_10.
  NEW-LINE.
  WRITE: p_number, 'Sabit değerimiz', c_10, 'a eşit'.
ELSEIF p_number <> c_10.
  WRITE: / p_number,'Sabit degerimiz', c_10,'e esit degil'.
ENDIF.

IF p_number >= c_10.
  WRITE: / p_number, 'büyüktür', c_10, 'dan'.
ELSEIF p_number <= c_10.
  WRITE: / p_number, c_10, 'dan küçüktür'.
ENDIF.


****** Comparing string ********
"check demo program: DEMO_CHARACTER_COMPARISON
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