"----------Range SELECT-----------------------------"
TYPES: tr_matnr TYPE RANGE OF matnr.

data(lr_matnr) = VALUE tr_matnr( for ls_afpo in lt_afpo
                                  let s = 'I'
                                  o = 'EQ'
                                  in sign   = s
                                  option = o
                                  ( low = ls_afpo-matnr ) ).
lr_hvlid = VALUE #( for level in lT_LEVELNAMES
                    let s = 'I'
                         o = 'EQ'
                     in sign   = s
                        option = o
                     ( low = level-hlvlid ) ).

SE11 range örneği: RSELOPTION
  *--------------------------------------------------------*

 DATA: lr_range TYPE RANGE OF vbap-pstyv,
        ls_range LIKE LINE OF lr_range.

  "Faturalı & Konsiye Koşulu
  IF pa_fatur = 'X'.
    ls_range-option  = 'EQ'.
    ls_range-sign    = 'I'.
    ls_range-low     = 'ZS12'.
    APPEND ls_range TO lr_range.
  ENDIF.

  IF pa_kons = 'X'.
    ls_range-option  = 'EQ'.
    ls_range-sign    = 'I'.
    ls_range-low     = 'ZS11'.
    APPEND ls_range TO lr_range.
  ENDIF.

  DATA: lr_randevu_no TYPE RANGE OF zoz_randevular-randevu_no,
        lr_doktor_no TYPE RANGE OF zoz_doktorlar-doktor_no,
        lr_tarih TYPE RANGE OF zoz_randevular-tarih,
        lr_departman TYPE RANGE OF zoz_doktorlar-departman.
  "Eğer değer boş ise range tablosu dolmalı yoksa boş döner"
  IF gs_rapor-randevu_no IS NOT INITIAL.
    lr_randevu_no = VALUE #( ( option = 'EQ' sign = 'I' low = gs_rapor-randevu_no ) ).
  ENDIF.
  IF gs_rapor-doktor_no IS NOT INITIAL.
    lr_doktor_no = VALUE #( ( option = 'EQ' sign = 'I' low = gs_rapor-doktor_no ) ).
  ENDIF.
  IF gs_rapor-tarih IS NOT INITIAL.
    lr_tarih = VALUE #( ( option = 'EQ' sign = 'I' low = gs_rapor-tarih ) ).
  ENDIF.
  IF gs_rapor-departman IS NOT INITIAL.
    lr_departman = VALUE #( ( option = 'EQ' sign = 'I' low = gs_rapor-departman ) ).
  ENDIF.


  types : tr_aufnr type range of aufnr,
          tr_matnr type range of matnr.

  data(r_matnr) =  value tr_matnr( for rs_matnr in lt_component
                     let s = 'I'
                         o = 'EQ'
                      in sign     = s
                         option   = o
                       ( low = rs_matnr-material ) ).


  select menge, bwart
   from aufm
    into table @data(lt_aufm)
      where matnr in @r_matnr
        and aufnr eq @gt_data-aufnr
        and bwart in ('261', '262').
