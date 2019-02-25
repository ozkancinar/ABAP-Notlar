*&---------------------------------------------------------------------*
*& Report  ZTEST_ALV
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZTEST_ALV.

"Alv tanımlamaları
DATA:
  lt_fieldcat TYPE LVC_T_FCAT,
  ls_fieldcat type lvc_s_fcat,
  ls_layout TYPE lvc_s_layo.

 DATA :
  g_container TYPE scrfname VALUE 'CONTAINER_GRID1', "Tasarım kısmındaki isim
  g_Custom_Container TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
  g_Grid TYPE REF TO CL_GUI_ALV_GRID.

DATA :
  OK_CODE LIKE sy-ucomm.

START-OF-SELECTION.

 CALL SCREEN 100.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module STATUS_0100 output.
  SET PF-STATUS 'STATUS100'.
  SET TITLEBAR 'TITLE'.

  data: lt_data LIKE STANDARD TABLE OF mara,
        ls_mara LIKE LINE OF lt_data.

  SELECT * FROM mara into TABLE lt_data
    UP TO 100 rows.

  IF g_Custom_Container IS INITIAL.

    " Create CONTAINER object with reference to container name in the screen
    CREATE OBJECT g_Custom_Container
      EXPORTING
        CONTAINER_NAME = g_container.
    " Create GRID object with reference to parent name
    CREATE OBJECT g_Grid
      EXPORTING
        I_PARENT = g_Custom_Container.

    ls_layout-ZEBRA = 'X'.
    ls_layout-cwidth_opt = 'X'.

    gv_alv_repid = sy-repid .

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        I_STRUCTURE_NAME = 'MARA'
      CHANGING
        CT_FIELDCAT      = lt_fieldcat[].

    loop at lt_fieldcat into ls_fieldcat.
      case ls_fieldcat-fieldname.
        when 'LIFNR'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-just = 'X'.
          ls_fieldcat-f4availabl = 'X'.

        when 'NAME1' or 'ADRES' or 'TELF1' or 'SORUMLU_TEL' or
             'STENR' or 'NAKLIYE_UCRET' or 'FKDAT' or 'ACIKLAMA' or
             'KDVTUTAR'.

          ls_fieldcat-edit = 'X'.
        when 'BELNR'.
          ls_fieldcat-hotspot = 'X'.

        when 'WAERS'.

          ls_fieldcat-edit = 'X'.
          ls_fieldcat-just = 'X'.
          ls_fieldcat-f4availabl = 'X'.

        when 'KAZANAN'.
          ls_fieldcat-checkbox = 'X'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-coltext =
          ls_fieldcat-scrtext_s =
          ls_fieldcat-scrtext_m =
          ls_fieldcat-scrtext_l = 'Kazanan Firma'.
          ls_fieldcat-no_out = 'X' "alan gizlenir
        when 'DATE'.
          "Date conversion exit"
          ls_fieldcat-datatype = 'DATUM'
          ls_fieldcat-inttype = 'D'
          ls_fieldcat-intlen = '000008'
          ls_fieldcat-dd_outlen = '000010'

      endcase.
      modify pt_fieldcat from ls_fieldcat.
    endloop.

    " SET_TABLE_FOR_FIRST_DISPLAY
    CALL METHOD g_Grid->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
        is_layout       = ls_layout
      CHANGING
        it_fieldcatalog = lt_fieldcat
        IT_OUTTAB       = lt_data. " Data

  ELSE.
    CALL METHOD g_Grid->REFRESH_TABLE_DISPLAY.
  ENDIF.

endmodule.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module USER_COMMAND_0100 input.

 OK_CODE = sy-ucomm.
 CLEAR sy-ucomm.
  CASE OK_CODE.
    WHEN 'EXIT' OR 'BACK' OR 'CNCL'.
      LEAVE PROGRAM.
    WHEN 'LIST'. "Butonun function kodu unutma!

    WHEN OTHERS.
  ENDCASE.
  CLEAR: OK_CODE.
endmodule.                 " USER_COMMAND_0100  INPUT
