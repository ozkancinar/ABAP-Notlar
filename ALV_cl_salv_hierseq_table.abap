TYPES :begin of ty_vbrk,
       vbeln          TYPE vbeln_vf, "DocumentNumber
       kunrg          TYPE kunrg, "Payer
       fkdat          TYPE fkdat, "Billingdate
       netwr          TYPE netwr, "NetValue
       END OF ty_vbrk.
TYPES :begin of ty_vbrp,
       vbeln          TYPE vbeln_vf, "DocumentNumber
       posnr          TYPE posnr_vf, "BillingITEM
       arktx          TYPE arktx, "DescriptionofItem
       fkimg          TYPE fkimg, "Billedquantity
       vrkme          TYPE vrkme, "SalesUnit
       netwr          TYPE netwr_fp, "NetValue
       matnr          TYPE matnr, "MaterialNumber
       END OF ty_vbrp.
DATA :it_vbrk type standard TABLE OF ty_vbrk,
      it_vbrp             TYPE Standard TABLE OF ty_vbrp,
      lo_alv              TYPE REF TO cl_salv_hierseq_table,
      v_vbeln             TYPE vbeln_vf.
SELECT-OPTIONS s_vbeln for v_vbeln.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM show_output.

*&-------------------------------------------------------------*
*& FormGET_DATA
*&-------------------------------------------------------------*
FORM get_data.
  SELECT vbeln kunrg fkdat netwr from vbrk
  into table it_vbrk where vbeln in s_vbeln.
    SELECT vbeln posnr arktx fkimg vrkme netwr matnr
    from vbrp into table it_vbrp where vbeln in s_vbeln.
ENDFORM.
*&-------------------------------------------------------------*
*& FormSHOW_OUTPUT
*&-------------------------------------------------------------*
FORM show_output.
  DATA: lt_key type salv_t_hierseq_binding,
        lw_key                           LIKE LINE OF lt_key,
        lcx_data_err                     TYPE REF TO cx_salv_data_error,
        lcx_not_found                    TYPE REF TO cx_salv_not_found.
  lw_key-master ='VBELN'.
  lw_key-slave ='VBELN'.
  APPEND lw_key to lt_key.
  TRY.
      CALL method cl_salv_hierseq_table=>factory
      EXPORTING
      t_binding_level1_level2 = lt_key
      IMPORTING
      r_hierseq = lo_alv
      CHANGING
      t_table_level1 = it_vbrk
      t_table_level2 = it_vbrp.
    CATCH cx_salv_data_error into lcx_data_err.
    CATCH cx_salv_not_found into lcx_not_found.
  ENDTRY.

  DATA: lo_functions TYPE REF TO cl_salv_functions_list.
  lo_functions = lo_alv->get_functions( ).
  lo_functions->set_all( abap_true ).
  
  lo_alv->display( ).
ENDFORM.