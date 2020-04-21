INCLUDE ZPK_PP_STOKIHT_top.
INCLUDE ZPK_PP_STOKIHT_cls.

initialization.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_posnr.
    lcl_main=>display_posnr_f4_help( ).

start-of-selection.

method display_posnr_f4_help.
    data shlp type shlp_descr .
    data dynpro_values type standard table of dynpread .
    data field_value type dynpread.

    dynpro_values = value #( ( fieldname = 'P_VBELN' ) ).

    call function 'DYNP_VALUES_READ'
      exporting
        dyname               = sy-repid
        dynumb               = sy-dynnr
        translate_to_upper   = 'X'
      tables
        dynpfields           = dynpro_values
      exceptions
        invalid_abapworkarea = 1
        invalid_dynprofield  = 2
        invalid_dynproname   = 3
        invalid_dynpronummer = 4
        invalid_request      = 5
        no_fielddescription  = 6
        invalid_parameter    = 7
        undefind_error       = 8
        others               = 99.

    try.
        field_value = dynpro_values[ 1 ].
      catch cx_sy_itab_error.
    endtry.

    call function 'F4IF_GET_SHLP_DESCR'
      exporting
        shlpname = 'F4_POSNR_VBAP' "searh help adı"
*       SHLPTYPE = 'SH'
      importing
        shlp     = shlp.

    try.
        assign shlp-interface[ shlpfield = 'VBELN' ] to field-symbol(<shlp_field>).
        <shlp_field>-value = field_value-fieldvalue.
        <shlp_field>-valfield = 'X'.
        assign shlp-interface[ shlpfield = 'POSNR' ] to <shlp_field>.
        <shlp_field>-value = '*'.
        <shlp_field>-valfield = 'X'.
      catch cx_sy_itab_error.
    endtry.

    data return_values  type standard table of ddshretval.
    call function 'F4IF_START_VALUE_REQUEST'
      exporting
        shlp          = shlp
      tables
        return_values = return_values.
    try.
        p_posnr = return_values[ fieldname = 'POSNR' ]-fieldval.
      catch cx_sy_itab_error.
    endtry.
endmethod.
