LOOP AT SCREEN.
 CASE screen-name.
  WHEN 'PA_MAKTX'.
    wa_fieldvalue-fieldname = 'PA_MAKTX'.
    wa_fieldvalue-fieldvalue = gt_data-maktx.
  WHEN 'PA_MATNR'.
   wa_fieldvalue-fieldname  = 'PA_MATNR'.
    wa_fieldvalue-fieldvalue = gt_data-matnr.
  when 'PA_WERKS'.
    wa_fieldvalue-fieldname = 'PA_WERKS'.
    wa_fieldvalue-fieldvalue = gt_data-werks.
  WHEN 'PA_URTYER'.
    wa_fieldvalue-fieldname = 'PA_URTYER'.
    wa_fieldvalue-fieldvalue = lv_urtyer.
   WHEN OTHERS.
 ENDCASE.
 append wa_fieldvalue to it_fieldvalues.
ENDLOOP.