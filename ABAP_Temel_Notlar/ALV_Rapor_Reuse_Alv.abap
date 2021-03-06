" ALV Parametreleri
DATA:  gv_alv_repid   LIKE sy-repid,
       gv_index       TYPE sy-tabix,
       lt_fieldcat TYPE slis_t_fieldcat_alv,
       ls_fieldcat TYPE slis_fieldcat_alv,
       gs_layout      TYPE slis_layout_alv,
       gs_header      TYPE slis_t_listheader,
       gv_altmsg(255) TYPE c,
       gt_sort type slis_t_sortinfo_alv with header line,
       gs_variant LIKE  disvariant..


" ALV tablosuna basılacak veriler
DATA: BEGIN OF ls_itab,
        order_number like BAPI_ORDER_HEADER1-ORDER_NUMBER,
        ACTUAL_RELEASE_DATE like BAPI_ORDER_HEADER1-ACTUAL_RELEASE_DATE,
        "..."
        yedirme_orani TYPE p,
        sel(1) type c
      END OF ls_itab.
data: lt_itab LIKE ls_itab OCCURS 0.

START-OF-SELECTION.
  PERFORM modify_data.
  PERFORM prepare_alv_parameters.

  PERFORM show_alv.

end-of-selection.

FORM MODIFY_DATA .
* ALV'ye basılacak lt_itab'ın dolduralacağı form

ENDFORM.                    " MODIFY_DATA

FORM PREPARE_ALV_PARAMETERS .


  " ALV tablosunun alanlarını tek tek oluştur.
  "fieldname kısmı internal table'ın alanlarıyla aynı olmalı"

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = gv_alv_repid
      i_internal_tabname = 'GS_DATA' "Eğer local structure kullanılacaksa. Data tarafında type ile tanımlanan sütunlar görünmeyecektir lie kullan"
      I_STRUCTURE_NAME       = 'ZOG_121018_STRUCTURE' "global structure kullanılacaksa"
      i_inclname         = gv_alv_repid
    CHANGING
      ct_fieldcat        = lt_fieldcat[]
    EXCEPTIONS
       EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


LOOP AT lt_fieldcat INTO ls_fieldcat.
    CASE ls_fieldcat-fieldname.
      WHEN 'YODTUTAR'.
        ls_fieldcat-seltext_m = 'ÖD TALEP TUTAR'.
        ls_fieldcat-edit = 'X'.
        ls_fieldcat-datatype = 'CURR'.
        "Fieldcat options:"
        "ls_fieldcat-key = 'X'. "key alanlarını işaretle"
        "ls_fieldcat-col_pos  = 1.
        "ls_fieldcat-fieldname = 'ORDER_NUMBER'.
        "ls_fieldcat-seltext_m = 'SİPARİŞ NO'.
        "ls_fieldcat-edit = 'X'.
        "ls_fieldcat-input = 'X'.
        "ls_fieldcat-datatype = 'CURR'. "veri tipi"
        "ls_fieldcat-EMPHASIZE = 'C511'. "renkli satır"
        "ls_fieldcat-tech = 'X'. " Gizlemek istediğimiz alanlar"
        "ls_fieldcat-do_sum = 'X'. "sütun toplamı gösterir"
      WHEN 'REBZG'.
        ls_fieldcat-tech = 'X'.
      WHEN 'SGTXT'.
        ls_fieldcat-tech = 'X'.
      WHEN 'ZTERM'.
        ls_fieldcat-tech = 'X'.
      WHEN 'NAME1'.
        ls_fieldcat-seltext_s = 'S. ADI'.
        ls_fieldcat-seltext_m = 'SATICI ADI'.
        ls_fieldcat-seltext_l = 'SATICI ADI'.
    ENDCASE.
    MODIFY lt_fieldcat FROM ls_fieldcat.
  ENDLOOP.
ENDFORM.                    " PREPARE_ALV_PARAMETERS

FORM SHOW_ALV .
* Tasarım tanımlamaları
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-zebra             = 'X'.
  gs_layout-get_selinfos      = 'X'.
  gs_layout-numc_sum          = 'X'.
  gs_layout-no_sumchoice      = ''.
  gv_alv_repid                = sy-repid.
  gs_layout-coltab_fieldname  = 'C51'.
  gs_layout-edit = ''.
"gs_layout-SUBTOTALS_TEXT = 'PSTAT'.
  gs_layout-zebra = 'X'.
  gs_layout-box_fieldname = 'SEL'. "Seçim yapılan satırları almak için kullandığımız structure alanı"

  "sub total
  gt_sort-fieldname = 'PSTAT'.
  gt_sort-subtot = 'X'.
  append gt_sort.

  gs_variant-report = sy-repid.
  gs_variant-username = sy-uname.
  gs_variant-handle = '0001'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = gv_alv_repid
      it_fieldcat            = lt_fieldcat
      is_layout              = gs_layout
      i_callback_pf_status_set = 'SUB_STATUS' "pf-status tanımla"
      i_callback_user_command  = 'USER_COMMAND' "kullanıcı girişi yakala"
      i_callback_top_of_page   = 'F_TOP_OF_PAGE'
      i_save                   = 'A'  "X "
      I_STRUCTURE_NAME         = 'Zstructure' "u alana structure verilirse fieldcatologa gerek kalmaz"
      is_variant               = gs_variant
      it_sort                  = gt_sort[] "ALV'de alt toplam ve ara toplam koymak için"
*      I_CLIENT_NEVER_DISPLAY       = 'X'
*      i_callback_html_top_of_page = 'TOP_OF_PAGE'
*     i_callback_html_end_of_list = 'END_OF_LIST'
    TABLES
      t_outtab               = lt_itab
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
ENDFORM.                    " SHOW_ALV

FORM SUB_STATUS USING rt_extab TYPE slis_t_extab.
  DATA : lt_exc LIKE TABLE OF sy-ucomm. "istenmeyen pfstatus alanları için"

  SET PF-STATUS 'ZSTANDARD'."EXCLUDING lt_exc."
ENDFORM.                    " SUB_STATUS

FORM user_command USING ok_code LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.
  ok_code = sy-ucomm.
  CLEAR sy-ucomm.
  data REF_GRID TYPE REF TO CL_GUI_ALV_GRID.

  CASE ok_code.
    WHEN 'KAYDET'.
      MESSAGE 'Kayıt butonuna tık' TYPE 'S'.

***************************************************
"ALV'de yapılan bir değişikliği yakala
      IF REF_GRID IS INITIAL.
        CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
          IMPORTING
            E_GRID = REF_GRID.
      ENDIF.
      IF NOT REF_GRID IS INITIAL.
        CALL METHOD REF_GRID->CHECK_CHANGED_DATA .
      ENDIF.
***************************************************

      READ TABLE ivals INTO xvals INDEX 0.
      LOOP AT lt_odemeliste INTO wa_odemeliste WHERE YODTUTAR ne 0. "alanları güncelle
*        READ TABLE lt_odemeliste INTO wa_odemeliste INDEX sy-tabix.
          "lt_odemeliste bizim verilerin olduğu internal table
          "alv üzerinden değişiklik yapıldığında otomatik güncellenir"
          modify lt_odemeliste index gd_tabix  FROM wa_odemeliste .

        ENDIF.
      ENDLOOP.
    when '&SHOW'.
      ls_text = 'Seçilen malzemeler:'.
      loop at gt_mara assigning field-symbol(<fs_mara>) where sel = 'X'.
        concatenate ls_text <fs_mara>-matnr
            into ls_text separated by ','.
        "ls_text = gt_tab-matnr   && ' , ' &&  ls_text .
      endloop.
      message ls_text type 'I'.
    WHEN OTHERS.
      MESSAGE 'Something happend' TYPE 'S'.
  ENDCASE.
  RS_SELFIELD-refresh = 'X'. "bu satır alvyi güncellemek için önemli"
  rs_selfield-col_stable = 'X'. "cursorın olduğu yerde kalmasını sağlar"
  rs_selfield-row_stable = 'X'.
ENDFORM.                    " USER_COMMAND

form f_top_of_page.
  data:
    wa_header     type slis_listheader,
    lv_line       like wa_header-info,
    ld_lines      type i,
    ld_linesc(10).
  " tipler
  " H = header
  " S = selection
  " A = action

  check it_header is initial.
  "başlık
*  wa_header-typ = 'H'.
*  wa_header-info = ' Raporu'.
*  APPEND wa_header TO it_header.
*  CLEAR wa_header.
  "tarih
  wa_header-typ = 'S'.
  wa_header-key = 'Tarih: '.


  concatenate sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum(4) into
wa_header-info.
  append wa_header to it_header.
  clear wa_header.

  wa_header-typ = 'S'.
  wa_header-key = 'Saat: '.

  concatenate sy-uzeit(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2) into
    wa_header-info.
  append wa_header to it_header.
  clear wa_header.

  "toplam kayıt
  describe table gt_mara lines ld_lines.

  ld_linesc = ld_lines.
  concatenate 'Toplam Kayıt Sayısı: ' ld_linesc into lv_line separated
  by space.

  wa_header-typ = 'A'.
  wa_header-info = lv_line.

  append wa_header to it_header.
  clear: wa_header, lv_line.

  "headerları ekrana yaz
  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = it_header.


endform.                    "f_top_of_page

FORM end_of_list USING end TYPE REF TO cl_dd_document.

  DATA: l_grid TYPE REF TO cl_gui_alv_grid,
        f(14)  TYPE c VALUE 'SET_ROW_HEIGHT'.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = l_grid.

  CALL METHOD l_grid->parent->parent->(f)
    EXPORTING
      id     = 3
      height = 3.


  CONCATENATE text-014 sy-uname text-015
  sy-datum+6(2)'/' sy-datum+4(2)'/' sy-datum+0(4)
  text-016 sy-timlo+0(2) ':' sy-timlo+2(2) INTO gv_altmsg.
  "MESSAGE ALT_MSG TYPE 'I'.
  CALL METHOD end->add_text
    EXPORTING
      text = gv_altmsg.
ENDFORM.

FORM top_of_page USING top TYPE REF TO cl_dd_document.

  CALL METHOD top->add_gap
    EXPORTING
      width = 355.

  CALL METHOD top->add_picture
    EXPORTING
      picture_id = 'ZMB_AYNES_LOGO'.
  "ALTERNATIVE_TEXT = TEXT-002.

  top->new_line( ).

  CALL METHOD top->add_text
    EXPORTING
      text      = text-001
      sap_style = 'heading'.

  top->new_line( ).
  CALL METHOD top->add_text
    EXPORTING
      text = text-003.

ENDFORM.                    "TOP_OF_PAGE

FORM end_of_list USING end TYPE REF TO cl_dd_document.

  DATA: l_grid TYPE REF TO cl_gui_alv_grid,
        f(14)  TYPE c VALUE 'SET_ROW_HEIGHT'.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = l_grid.

  CALL METHOD l_grid->parent->parent->(f)
    EXPORTING
      id     = 3
      height = 3.


  CONCATENATE text-014 sy-uname text-015
  sy-datum+6(2)'/' sy-datum+4(2)'/' sy-datum+0(4)
  text-016 sy-timlo+0(2) ':' sy-timlo+2(2) INTO gv_altmsg.
  "MESSAGE ALT_MSG TYPE 'I'.
  CALL METHOD end->add_text
    EXPORTING
      text = gv_altmsg.
ENDFORM.
