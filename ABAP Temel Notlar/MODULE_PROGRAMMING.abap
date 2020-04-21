* PBO PAI Konuları. Program oluşturulurken M(Module programming) seçilir

PROCESS AFTER INPUT.
  MODULE CANCEL AT EXIT-COMMAND.
  FIELD INPUT1 MODULE MODULE_1. "Bir alandaki girişi kontrol eder
  CHAIN.
    FIELD INPUT4.
    MODULE CHAIN_MODULE_1.
    FIELD INPUT5.
    FIELD INPUT6 MODULE CHAIN_MODULE_2.
  ENDCHAIN.

chain.
  field: gs_scren-mpn,
         gs_scren-batch,
         gs_screen-exp_date.
  MODULE check_mfrpn on CHAIN-REQUEST.
endchain.

MODULE module_1 INPUT.
  IF input1 < 50.
    MESSAGE e888(sabapdemos) WITH text-001 '50' text-002.
  ENDIF.
ENDMODULE.

"trigger pai"
CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
      EXPORTING
        NEW_CODE = 'DOUBLE_CLICK'
*      IMPORTING
*        RC       =
        .

FIELD CARRIER VALUES (NOT 'AA', 'LH', BETWEEN 'QF' AND 'UA').
"Search help: Oluşturduğun arama yardımını screen painterda seçebilir ve alanla bağlayabilirsin"
FIELD CONNECT SELECT  *
                  FROM  SPFLI
                  WHERE CARRID = CARRIER AND CONNID = CONNECT
                  WHENEVER NOT FOUND SEND ERRORMESSAGE 107
                                          WITH CARRIER CONNECT.

"Search help 2.Yöntem:"

process ON VALUE-REQUEST.
  field pa_mblnr MODULE help_mblnr.
  field pa_mjahr MODULE help_mjahr.

FORM SHOW_MBLNR_HELP .
  data: lt_return TYPE DDSHRETVAL occurs 0,
        ls_return TYPE DDSHRETVAL,
        lv_mblnr TYPE mblnr,
        lv_mjahr TYPE mjahr,
        lv_repid TYPE sy-repid.
        lv_repid = sy-repid.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
       EXPORTING
            tabname     = 'ZSH_MSEG'
            fieldname   = 'MBLNR'
            dynpprog    = lv_repid
            dynpnr      = sy-dynnr
            dynprofield = 'PA_MBLNR'
            callback_program = lv_repid
            callback_form = 'MBLNR_F4CALLBACK'
        TABLES
            RETURN_TAB = lt_return.

  CLEAR ls_return.
  READ TABLE lt_return INTO ls_return WITH KEY fieldname = 'MBLNR'.
ENDFORM.                    " SHOW_MBLNR_HELP

FORM SHOW_MJAHR_HELP .
  data: BEGIN OF values_tab occurs 0,
        mblnr TYPE mblnr,
        mjahr TYPE mjahr,
        END OF values_tab.

  CALL FUNCTION 'DYNP_VALUES_READ'
       EXPORTING
            dyname             = 'SAPMZ_MLZ_DIALOG1'
            dynumb             = '0100'
            translate_to_upper = 'X'
       TABLES
            dynpfields         = dynpro_values.

  field_value = dynpro_values[ 1 ].

  SELECT  mblnr mjahr
    FROM  mseg
    INTO  CORRESPONDING FIELDS OF TABLE values_tab
    WHERE mblnr = field_value-fieldvalue.

   CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
       EXPORTING
            retfield    = 'MJAHR'
            dynpprog    = sy-repid
            dynpnr      = sy-dynnr
            dynprofield = 'pa_mjahr'
            value_org   = 'S'
       TABLES
            value_tab   = values_tab.
ENDFORM.                    " SHOW_MJAHR_HELP
