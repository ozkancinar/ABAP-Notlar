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
*----------------------------------------------------------
"mm03"
DATA: lt_bdcdata TYPE TABLE OF bdcdata.
DATA opt TYPE ctu_params.
lt_bdcdata = VALUE #(
          ( program  = 'SAPLMGMM' dynpro   = 0060 dynbegin = 'X' )
          ( fnam = 'BDC_CURSOR'       fval = 'RMMG1-MATNR' )
          ( fnam = 'BDC_OKCODE'       fval = '=AUSW' )
          ( fnam = 'RMMG1-MATNR'      fval = <line>-matnr ) "alan adı"
          ( program  = 'SAPLMGMM' dynpro   = 0070 dynbegin = 'X' )
          ( fnam = 'BDC_CURSOR'       fval = 'MSICHTAUSW-DYTXT(03)' )
          ( fnam = 'BDC_OKCODE'       fval = '=ENTR' )
          ( fnam = 'MSICHTAUSW-KZSEL(01)'      fval = 'X' ) "alan"
          ( fnam = 'MSICHTAUSW-KZSEL(02)'      fval = 'X' ) "alan"
          ( fnam = 'MSICHTAUSW-KZSEL(03)'      fval = 'X' ) "alan"
          ( program  = 'SAPLMGMM' dynpro   = 0080 dynbegin = 'X' )
          ( fnam = 'BDC_CURSOR'       fval = 'RMMG1-WERKS' )
          ( fnam = 'BDC_OKCODE'       fval = '=ENTR' )
          ( fnam = 'RMMG1-WERKS'       fval = '5000' ) ).
*                ( program  = 'SAPLMGMM' dynpro   = 4004 dynbegin = 'X' )
*                ( fnam = 'BDC_OKCODE'       fval = '=BABA' ) ).
  opt-dismode = 'E'.
  opt-defsize = 'X'.
  CALL TRANSACTION 'MM03' USING lt_bdcdata OPTIONS FROM opt.

"mm03 basic view
SET PARAMETER ID 'MAT' FIELD <line>-matnr .
SET PARAMETER ID 'MXX' FIELD 'K' .
CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.

"mm03 mrp1 view
SET PARAMETER ID 'MAT' FIELD <line>-matnr .
SET PARAMETER ID 'MARAV' FIELD <line>-matnr .
SET PARAMETER ID 'WRK' FIELD '5000'. "werks
SET PARAMETER ID 'MXX' FIELD 'D'."MRP1 View "default
CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.

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
