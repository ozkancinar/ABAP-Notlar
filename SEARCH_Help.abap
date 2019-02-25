* se11'den search help oluşturup programda kullanman:
parameters pa_matnr type matnr matchcode object s_mat1.

* search helpi fonksiyonla kullanmak
at selection-screen on value-request for s_aufnr-low.
  perform get_aufnr_f4_help.

form get_aufnr_f4_help .
  data: it_ret type ddshretval occurs 0 with header line.

  data: begin of it_tab occurs 0,
          aufnr like afpo-aufnr,
        end of it_tab.

  select aufnr
   into corresponding fields of table it_tab
    from afpo
      where dauat eq 'ZP01'.

  delete adjacent duplicates from it_tab.

  call function 'F4IF_INT_TABLE_VALUE_REQUEST'
    exporting
      retfield   = 'REMATNR'
      value_org  = 'S'
    tables
      value_tab  = it_tab[]
      return_tab = it_ret[].
  if sy-subrc eq 0.
    read table it_ret index 1.
    s_aufnr-low = it_ret-fieldval.
  endif.
endform.

"Search help input parametresini doldurmak:
 DATA: shlp TYPE shlp_descr.
  DATA: l_wa      TYPE ddshiface,
        l_return_values LIKE ddshretval OCCURS 0 WITH HEADER LINE.

  CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
    EXPORTING
      shlpname = 'ZOZSH_DOKTOR' "searh help adı"
*     SHLPTYPE = 'SH'
    IMPORTING
      shlp     = shlp.

  LOOP AT shlp-interface INTO l_wa WHERE shlpfield  EQ 'DEPARTMAN'. "input alanının adı"
    l_wa-value = gv_departman. "input alanına verilecek değer"
    MODIFY shlp-interface FROM l_wa.
  ENDLOOP.


  CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
    EXPORTING
      shlp          = shlp
    TABLES
      return_values = l_return_values.