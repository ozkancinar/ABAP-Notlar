* İstenilen tcode çağırılabilir.
* rn: XK03 tcode a git -> Hangi alan zorunluysa üzerine gel f1 -> f9 ->
* orada parameter id olarak görebilirsin
* DEMO_CALL_TRANSACTION* örnek programlara bakabilisin

data: lv_val4 TYPE matnr,
      lv_field4(30) type c.

GET CURSOR FIELD LV_FIELD4 VALUE lv_val4.

IF lv_field4 eq 'PA_LIFNR' and lv_val4 is NOT INITIAL.
	SET PARAMETER ID 'LIF' FIELD lv_val4 .
	SET PARAMETER ID 'BUK' FIELD gt_data-bukrs.
	set PARAMETER ID 'EKO' FIELD gt_data-werks.
	CALL TRANSACTION 'XK03' AND SKIP FIRST SCREEN .
endif.

* ikinci yöntem bdcdata kullanmak
DATA: lt_bdcdata TYPE TABLE OF bdcdata,
        ls_bdcdata LIKE LINE OF lt_bdcdata.
DATA opt TYPE ctu_params.
 lt_bdcdata = VALUE #(
            ( program  = 'SAPMF02K' dynpro   = '0101' dynbegin = 'X' )
            ( fnam = 'BDC_CURSOR'       fval = 'RF02K-LIFNR' )
            ( fnam = 'RF02K-LIFNR'      fval = lv_val4 ) "alan adı"
            ( fnam = 'BDC_CURSOR'       fval = 'RF02K-BUKRS' )
            ( fnam = 'RF02K-BUKRS'      fval = gt_data-bukrs ) "alan"
            ( fnam = 'BDC_CURSOR'       fval = 'RF02K-EKORG' )
            ( fnam = 'RF02K-EKORG'      fval = lv_ekorg ) "alan"
            ( fnam = 'BDC_CURSOR'       fval = 'RF02K-D0110' )
            ( fnam = 'RF02K-D0110'      fval = 'X') "checkbox"
            ( fnam = 'BDC_OKCODE'       fval = '=WB_DISPLAY' )"çalıştır" ).
        opt-dismode = 'E'.
        opt-defsize = 'X'.
CALL TRANSACTION 'XK03' USING lt_bdcdata OPTIONS FROM opt.

"-------------------------------------"
DATA class_name TYPE c LENGTH 30 VALUE 'CL_ABAP_BROWSER'.

DATA bdcdata_tab TYPE TABLE OF bdcdata.

DATA opt TYPE ctu_params.

bdcdata_tab = VALUE #(
  ( program  = 'SAPLSEOD' dynpro   = '1000' dynbegin = 'X' )
  ( fnam = 'BDC_CURSOR'       fval = 'SEOCLASS-CLSNAME' )
  ( fnam = 'SEOCLASS-CLSNAME' fval = class_name )
  ( fnam = 'BDC_OKCODE'       fval = '=WB_DISPLAY' ) ).

opt-dismode = 'E'.
opt-defsize = 'X'.

TRY.
    CALL TRANSACTION 'SE24' WITH AUTHORITY-CHECK
                            USING bdcdata_tab OPTIONS FROM opt.
  CATCH cx_sy_authorization_error ##NO_HANDLER.
ENDTRY.
