
* Do basit döngü mekanizmasıdır

*--------- Do n sefer ---------------

report ztx1007.
sy-index = 99.
write: / 'before loop, sy-index = ', sy-index, / ''. "sy-index döngüdeki anlık sayıyı verir
do 5 times.
	write sy-index.
	enddo.
write: / 'after loop, sy-index =', sy-index, / ''.

do 4 times.
	write: / 'outer loop, sy-index =', sy-index
	do 3 times.
		write: / ' inner loop, sy-index =', sy-index.
		enddo.
	enddo.

write: / ''.
do 10 times.
	write sy-index.
	if sy-index = 3.
		exit.
	endif.
enddo.

*----------- Sonsuz Döngü ------------

report ztx1008.
do.
	write sy-index.
	if sy-index = 0.
		exit.
		endif.
	enddo.

--------------------------------------

*-------- Döngü ile data içerisindeki verilere erişmek ------

report ztx1011.
data: f1 type i,
	begin of s,
		c1 type i value 1,
		c2 type i value 2,
		c3 type i value 3,
		c4 type i value 4,
		c5 type i value 5,
		c6 type i value 6,
		end of s.
fiend-symbols <f>.

write / ''.
do 6 times varying f1 from s-c1 next s-c2.
	if sy-index = 6.
		s-c6 = 99.
	else.
		f1 = f1 * 2.
		endif.
	assign component sy-index of structure s to <f>.
	write <f>.
	enddo.

write / ''.
do 6 times varying f1 from s-c1 next s-c2.
	write f1.
	enddo. 

Çıktı: 
1 2 3 4 5 99
2 4 6 8 10 6
----------------------------------------------

------------- Varying Kullanımı Başka Bir Örnek ----------

DATA: BEGIN OF text,
        word1(4) TYPE c VALUE 'This',
        word2(4) TYPE c VALUE 'is',
        word3(4) TYPE c VALUE 'a',
        word4(4) TYPE c VALUE 'loop',
      END OF text.

DATA: string1(4) TYPE c, string2(4) TYPE c.

DO 4 TIMES VARYING string1 FROM text-word1 NEXT text-word2.
  WRITE string1.
  IF string1 = 'is'.
    string1 = 'was'.
  ENDIF.
ENDDO.

----------------------------------------------

DO 4 TIMES.
  IF sy-index = 2.
    CONTINUE.
  ENDIF.
  WRITE sy-index.
ENDDO.

SKIP.
ULINE.

* check

DO 4 TIMES.
  CHECK sy-index BETWEEN 2 AND 3.
  WRITE sy-index.
ENDDO.

SKIP.
ULINE.

* exit

DO 4 TIMES.
  IF sy-index = 3.
    EXIT.
  ENDIF.
  WRITE sy-index.
ENDDO.