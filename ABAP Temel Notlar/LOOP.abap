"AT - ENDAT"
data itab type sorted table of sflight with non-unique key.
loop at itab into wa.
  at new carrid.
    write: / wa-carrid.
  endat.
	AT END OF carrid.
		 out->write( group ).
		 SUM.
		 out->line( )->write( line )->line( ).
	 ENDAT.
	 AT LAST.
		 SUM.
		 out->line( )->write( line ).
	 ENDAT.
endloop.

"loop at group by
LOOP AT itab INTO wa GROUP BY wa-col1.
   group = VALUE #( FOR <wa> IN GROUP wa ( <wa> ) ).
   out->write( group ).
ENDLOOP.

"loop at group by
loop at lt_flight1 INTO data(ls_data) GROUP BY ( connid = ls_data-connid "fldate = ls_data-fldate
                                                  size = GROUP SIZE
                                                  index = GROUP INDEX )
                                                  assigning field-symbol(<fs_group>).

  WRITE: / 'Connid:', <fs_group>-connid, 'Size:', <fs_group>-size, 'Index:', <fs_group>-index.
  LOOP AT GROUP <fs_group> ASSIGNING FIELD-SYMBOL(<fs_data2>).
    WRITE: / ,5 <fs_data2>-carrid, <fs_data2>-connid, <fs_data2>-fldate.
  ENDLOOP.
endloop.
