

types: begin of ty_veri,
	matnr type mara-matnr,
	mtart type marc-mtart,
	maktx type makt-maktx,
       end of ty_veri.

data: gs_veri type ty_veri,
      gt-veri type table of ty_veri with header line.

loop at gt_veri into gs_veri.
  write: / gs_veri-mtart, gts_veri-matnr, gs_veri-maktx.
  clear gs_veri.
endloop.

loop at gt_veri assigning <lf_veri>

endloop.

loop at lt_data REFERENCE INTO DATA(lr_data).
	data(veri) = lr_data->text. "oku
	lr_data->text = 'Özkan'. "yaz
endloop.

"AT - ENDAT"
data itab type sorted table of sflight with non-unique key.
loop at itab into wa.
  at new carrid.
    write: / wa-carrid.
  endat.
endloop.
