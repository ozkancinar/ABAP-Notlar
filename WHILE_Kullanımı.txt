
data: 1,
	t,
	done.

parameters p(25) default '      Vendor Number'.
while done = ' '
	vary l from p+0 next p+1 vary t from p+24 next p+23.
		if l = ' ' and t = ' '.
			l = t = '-'.
		else.
			done = 'X'.
			endif
		endwhile.
write: / p.

Çıktı: ----Vendor Number ----