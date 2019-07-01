"tek seferli okumada başarılı yalnızca anahtar alanlar ile erişilebilir"
"tüm anahtarları veri okuma sırasında vermezsen kötü performans ortaya çıkarabilir
"All entries in the table must have a unique key.
"You can only access a hashed table using the generic key operations or other generic operations (SORT, LOOP, and so on).
"Explicit or implicit index operations (such as LOOP ... FROM to INSERT itab within a LOOP) are not allowed." 
PARAMETERS p_ktopl LIKE t001-ktopl.
PARAMETERS p_bukrs LIKE t001-bukrs.
PARAMETERS p_konto LIKE skb1-saknr.

DATA: t1   TYPE i,
      t2   TYPE i,
      tmin TYPE i.

DATA stab TYPE SORTED TABLE OF skb1 WITH UNIQUE KEY bukrs  saknr.
DATA htab TYPE HASHED TABLE OF skb1 WITH UNIQUE KEY bukrs  saknr.
DATA wa TYPE skb1.

SELECT        * FROM  skb1 INTO TABLE stab.
write: /'cnt:', sy-dbcnt.
uline.
htab = stab.


GET RUN TIME FIELD t1.
*READ TABLE stab INTO wa WITH TABLE KEY bukrs = p_bukrs
*                                       saknr = p_konto.
LOOP AT stab ASSIGNING FIELD-SYMBOL(<stab>) WHERE bukrs = p_bukrs and
                                                  saknr = p_konto.
  data(da) = <stab>-bukrs.
ENDLOOP.

GET RUN TIME FIELD t2.
tmin = t2 - t1.
WRITE:/  'sorted table :', tmin, 'microseconds'.

ULINE.
CLEAR: t1, t2, tmin.
FREE stab.
GET RUN TIME FIELD t1.
*READ TABLE htab INTO wa WITH TABLE KEY bukrs = p_bukrs
*                                       saknr = p_konto.

LOOP AT htab ASSIGNING FIELD-SYMBOL(<htab>) WHERE bukrs = p_bukrs and
                                                  saknr = p_konto.
  data(do) = <htab>-bukrs.
ENDLOOP.

GET RUN TIME FIELD t2.
tmin = t2 - t1.
WRITE:/  'hashed table :', tmin, 'microseconds'.
