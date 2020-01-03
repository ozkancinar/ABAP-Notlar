*---- string alt satıra geç string enter
CONCATENATE gv_sbnam gv_telnr gv_email INTO DATA(lv_001) SEPARATED BY cl_abap_char_utilities=>cr_lf.
read text to text -> call function 'CONVERT_ITF_TO_STREAM_TEXT'
*--------SUBSTRING
"Substring with Offset and length
result = substring( val = ‘ABCDEFGH’ off = 2 len = 3 ). "OUTPUT:   CDE
CX_SY_RANGE_OUT_OF_BOUNDS
CX_SY_REGEX_TOO_COMPLEX
CX_SY_STRG_PAR_VAL

escape character: \

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
*--------SPLIT
DATA STR(30) VALUE 'SAP IS AN ERP'.
DATA: S1(5), S2(5), S3(5), S4(5).
  SPLIT STR AT ' ' INTO S1 S2 S3 S4.
  SPLIT ls_sorumluluk-resp_code at ', ' INTO TABLE lt_resps.
WRITE :/ S1, / S2, / S3, / S4.
*-----------------------------------
*---------SEARCH
DATA STR(30) VALUE 'SAP IS AN ERP'.
DATA S1(3) VALUE 'AN'.
  SEARCH STR FOR S1.
WRITE :/ SY-FDPOS.
*-----------------------------------
*---------CONCATENATE
DATA STR(30).
DATA: S1(5) VALUE 'TURKEY', S2(5) VALUE 'IS', S3(5) VALUE 'GREAT'.
  CONCATENATE S1 S2 S3 INTO STR SEPARATED BY ' '.
WRITE :/ STR.
*----------------------------------
*---------SHIFT Sola, sağa veya dairesel olarak string hareketi sağlar
DATA STR(20) VALUE 'ABAP IS IN SAP'.
  SHIFT STR BY 5 PLACES.
WRITE STR COLOR 5.
DATA STR(20) VALUE 'ABAP IS IN SAP'.
  SHIFT STR RIGHT BY 5 PLACES.
WRITE STR COLOR 5.
DATA STR(20) VALUE 'ABAP IS IN SAP'.
  SHIFT STR CIRCULAR BY 5 PLACES.
WRITE STR COLOR 5.
SHIFT str right by 1 PLACES. "son karakteri sil
*--------------------------------------
*---------TRANSLATE Stringin harf boyutunu ayarlar. Küçük veya büyük
DATA STR(10) VALUE 'CHENNAIÇğÜ'.
  TRANSLATE STR TO LOWER CASE.
  translate lv_projetipi to upper case.
  translate lv_proje using 'AaHh'. "değer olarak bir harf kabul eder. İlk harfi ikinci harfle değiştirir"
  TRANSLATE str USING 'ğgşsİIçcÇC'. "türkçe karakterleri ingilizceye çevirir"
WRITE STR.
*-------------------------------------
*---------CONDENSE Boşlukları siler
data str(30) value ' ITALY IS GREAT'.
  CONDENSE STR.
  CONDENSE str no-gaps. "cümle içindeki boşlukları da siler"
WRITE STR.
*-------------------------------------
*---------REPLACE
data str(30) value 'ITALY IS GREAT'.
DATA S1(10) VALUE 'WRITES'.
  REPLACE 'IS' IN STR WITH S1.
  REPLACE ALL OCCURRENCES OF '.' IN gt_ireport-devir_txt WITH ''.
WRITE STR.
*-----------------------------------
*---------STRLEN
data str(30) value 'ITALY IS GREAT'.
data len type i.
  len = STRLEN( STR ).
"son karakteri ekrana yaz length
write len.
a = strlen( str ) - 1.
write str+a(1).
*----------------------------------
*Tip referans aktarımı
write ls_mara-menge to lv_str unit ls_mara-meins.
"----------------------------------
" text to xstring text= Miller -> xtext= 3F373D3D2F49010A018F09
CONVERT TEXT line-text INTO SORTABLE CODE line-xtext.
****** Comparing string ********
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
