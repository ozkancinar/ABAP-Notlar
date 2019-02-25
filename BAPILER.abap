* Siparişe ait veriler 
      " BAPI Parametreleri
      ld_return TYPE BAPIRET2,
      wa_order_object LIKE BAPI_PP_ORDER_OBJECTS,
      it_header TYPE STANDARD TABLE OF BAPI_ORDER_HEADER1,
      wa_header LIKE LINE OF it_header,
      it_position  TYPE STANDARD TABLE OF BAPI_ORDER_ITEM,
      wa_position  LIKE LINE OF it_position,
      it_sequence  TYPE STANDARD TABLE OF BAPI_ORDER_SEQUENCE,
      wa_sequence  LIKE LINE OF it_sequence,
      it_operation  TYPE STANDARD TABLE OF BAPI_ORDER_OPERATION1,
      wa_operation  LIKE LINE OF it_operation,
      it_trigger_point  TYPE STANDARD TABLE OF BAPI_ORDER_TRIGGER_POINT,"TABLES PARAM
      wa_trigger_point  LIKE LINE OF it_trigger_point,
      it_component  TYPE STANDARD TABLE OF BAPI_ORDER_COMPONENT,
      wa_component  LIKE LINE OF it_component.
      it_prod_rel_tool  TYPE STANDARD TABLE OF BAPI_ORDER_PROD_REL_TOOLS,
      wa_prod_rel_tool  LIKE LINE OF it_prod_rel_tool.

initialization.
  wa_order_object-header = 'X'.
  wa_order_object-OPERATIONS = 'X'.
  wa_order_object-COMPONENTS = 'X'.

CALL FUNCTION 'BAPI_PRODORD_GET_DETAIL'
      EXPORTING
        NUMBER           = ls_siparis-sip_no
*       COLLECTIVE_ORDER =
        ORDER_OBJECTS    = wa_order_object
      IMPORTING
        RETURN           = ld_return
      TABLES
        HEADER           = tmp_header
*       POSITION         =
*       SEQUENCE         =
        OPERATION        = tmp_operation
*       TRIGGER_POINT    =
        COMPONENT        = tmp_component
*       PROD_REL_TOOL    =
      .

*------------------------------------------------
* Malzemeye göre sipariş bilgisi
 call function 'BAPI_RESERVATION_GETITEMS1'
      exporting
        plant             = '1100'
        material_long     = gt_data-matnr
      tables
        reservation_items = lt_rezerv.
*------------------------------------------------

"Muhatap adres bilgilerini al
CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'
      EXPORTING
        businesspartner         = lv_partnerno
*       VALID_DATE              = SY-DATLO
*       IV_REQ_MASK             = 'X'
      IMPORTING
*       centraldata             = ls_centraldata
        centraldataperson       = ls_centralperson
        centraldataorganization = ls_centralorg.

CALL FUNCTION 'BAPI_BUPA_ADDRESS_GETDETAIL'
  EXPORTING
    businesspartner = lv_partnerno
*       ADDRESSGUID     =
*       VALID_DATE      = SY-DATLO
*       RESET_BUFFER    =
  IMPORTING
    addressdata     = ls_addressdata
  TABLES
*       BAPIADTEL       =
    bapiadfax       = lt_bafiadfax.
