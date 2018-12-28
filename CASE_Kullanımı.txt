
case v1.
	when v2 [or vn ...].
		----
	when v3 [or vn ...].
		----
endcase.

------------ Örnek ---------
report ztx1005.
parameters f1 type i default 2.

case f1.
	when 1.  write / 'f1 = 1'.
	when 2.  write / 'f1 = 2'.
	when 3.  write / 'f1 = 3'.
	when others.  write / 'f1 is not 1, 2, or 3'.
	endcase.

----------------------------

REPORT  ZCONDITIONAL_BRANCHES.

PARAMETERS month TYPE i.

CASE month.
WHEN 3.
MESSAGE 'MART' type 'I'.
WHEN 4.
MESSAGE 'NİSAN' type 'I'.
WHEN OTHERS.
MESSAGE 'geçerli bir numara giriniz' TYPE 'E'.