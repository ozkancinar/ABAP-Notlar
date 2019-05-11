*&---------------------------------------------------------------------*
*& Include          ZMMI_BASLIK_NAKLIYE_ALV
*&---------------------------------------------------------------------*
class lcl_szl_nak definition deferred.

data: gc_nakliye            type scrfname value 'CONT_NAK',
      g_grid_nakliye        type ref to   ,
      g_custom_cont_nakliye type ref to cl_gui_custom_container,
      g_event_nakliye       type ref to lcl_szl_nak,
      gt_fieldcat           type lvc_t_fcat,
      gs_layout             type lvc_s_layo,
      gs_variant            type disvariant.

data: gs_f4 type lvc_s_f4,
      gt_f4 type lvc_t_f4.

*----------------------------------------------------------------------*
*       CLASS LCL_SZL_NAK DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_szl_nak definition.

  public section.
    methods:
      on_f4 for event onf4 of cl_gui_alv_grid
        importing sender
                    e_fieldname
                    e_fieldvalue
                    es_row_no
                    er_event_data
                    et_bad_cells
                    e_display,

      handle_data_changed for event data_changed of cl_gui_alv_grid
        importing er_data_changed e_ucomm,

      catch_doubleclick for event double_click of cl_gui_alv_grid
        importing e_column
                    es_row_no
                    sender,

      handle_hotspot_click for event hotspot_click of cl_gui_alv_grid
        importing e_row_id
                    e_column_id
                    es_row_no,

      toolbar_modify for event toolbar of cl_gui_alv_grid
        importing e_object
                    e_interactive,

      handle_user_command for event user_command of cl_gui_alv_grid
        importing e_ucomm.

endclass.                    "LCL_SZL_NAK DEFINITION
"-----------------------------------------------------------------------"
"-----------------------------------------------------------------------"
"-----------------------------------------------------------------------"
*----------------------------------------------------------------------*
class lcl_szl_nak implementation.
  method on_f4.
    case e_fieldname.
      when ''.

    endcase.
  endmethod.
  "-----------------------------------------------------------------------"
  "-----------------------------------------------------------------------"
  "-----------------------------------------------------------------------"
  method  handle_data_changed.
    data: ls_stable type lvc_s_stbl.
    data: ls_good type lvc_s_modi,
          ls_data like line of gt_nakliye,
          ls_lfa1 type lfa1,
          ls_lfm1 type lfm1,
          lt_data like table of gt_nakliye,
          ls_nak  like line of gt_nakliye,
          lv_ind  type i.


    loop at er_data_changed->mt_good_cells into ls_good.
      clear ls_data.
      read table gt_nakliye into ls_data index ls_good-row_id.

      case ls_good-fieldname.
        when 'KDVTUTAR'.
          condense ls_good-value.
          if ls_good-value ne '0.00'.
            ls_data-kdvtutar = ls_good-value.
          else.
            clear: ls_data-nakliye_ucret, ls_data-kazanan.
          endif.

          ls_data-kdv_nakliye_ucret = ls_data-kdvtutar + ls_data-nakliye_ucret.
          modify gt_nakliye from ls_data index ls_good-row_id.

        when 'NAKLIYE_UCRET'.
          condense ls_good-value.
          if ls_good-value ne '0.00'.
            ls_data-nakliye_ucret = ls_good-value.
            case ls_data-mwskz.
              when 'V1'.
                ls_data-kdvtutar = ( ls_data-nakliye_ucret * 1 ) / 100.

              when 'V2'.
                ls_data-kdvtutar = ( ls_data-nakliye_ucret * 8 ) / 100.

              when 'V3'.
                ls_data-kdvtutar = ( ls_data-nakliye_ucret * 18 ) / 100.
            endcase.

          else.
            clear: ls_data-nakliye_ucret, ls_data-kazanan.
          endif.

          ls_data-kdv_nakliye_ucret = ls_data-kdvtutar + ls_data-nakliye_ucret.
          modify gt_nakliye from ls_data index ls_good-row_id.

        when 'MWSKZ'.
          if ls_good-value is not initial.
            ls_data-mwskz = ls_good-value.

            if ls_data-mwskz(1) eq 'V'.
              case ls_data-mwskz.
                when 'V1'.
                  ls_data-kdvtutar = ( ls_data-nakliye_ucret * 1 ) / 100.

                when 'V2'.
                  ls_data-kdvtutar = ( ls_data-nakliye_ucret * 8 ) / 100.

                when 'V3'.
                  ls_data-kdvtutar = ( ls_data-nakliye_ucret * 18 ) / 100.

              endcase.

              ls_data-kdv_nakliye_ucret = ls_data-kdvtutar + ls_data-nakliye_ucret.
              modify gt_nakliye from ls_data index ls_good-row_id.

            else.
              error_field 'ZMM' '088' 'E' ' ' 'MWSKZ' ls_good-row_id.
            endif.

          else.
            clear: ls_data-kdv_nakliye_ucret, ls_data-kdvtutar.
            modify gt_nakliye from ls_data index ls_good-row_id.
          endif.

        when 'KAZANAN'.

          if ls_data-lifnr is not initial.
            clear: lt_data[], ls_nak.

            if ls_good-value is not initial.

              ""Nakliye ücreti dolu olmalıdır.
              if ls_data-nakliye_ucret is not initial.

                lt_data[] = gt_nakliye[].
                delete lt_data where kazanan eq space.
                clear lv_ind.
                describe table lt_data lines lv_ind.

                if lv_ind eq 1.
                  error_field 'ZMM' '058' 'E' ' ' 'KAZANAN' ls_good-row_id.

                else.
                  ls_data-kazanan = ls_good-value.
                  modify gt_nakliye from ls_data index ls_good-row_id.
                endif.

              else.
                error_field 'ZMM' '065' 'E' ' ' 'KAZANAN' ls_good-row_id.
              endif.

            else.
              clear ls_data-kazanan.
              modify gt_nakliye from ls_data index ls_good-row_id.
            endif.

          else.
            error_field 'ZMM' '060' 'E' ' ' 'KAZANAN' ls_good-row_id.
          endif.

        when 'LIFNR'.

          if ls_good-value is not initial.
            clear ls_nak.
            read table gt_nakliye into ls_nak with key lifnr = ls_good-value.

            if sy-subrc eq 0.
              error_field 'ZMM' '066' 'E' ' ' 'LIFNR' ls_good-row_id.
            else.

              ls_data-lifnr = ls_good-value.

              select count(*)
               from lfa1
                where lifnr eq ls_data-lifnr.

              if sy-subrc eq 0.

                clear ls_lfa1.
                select single *
                 from lfa1
                  into corresponding fields of ls_lfa1
                   where lifnr eq ls_data-lifnr.

                clear ls_lfm1.
                select single *
                 from lfm1
                  into corresponding fields of ls_lfm1
                   where lifnr eq ls_data-lifnr.

                move-corresponding ls_lfa1 to ls_data.

                clear ls_data-name1.
                concatenate ls_lfa1-name1 ls_lfa1-name2
                            ls_lfa1-name3 ls_lfa1-name4
                       into ls_data-name1.

                clear ls_data-adres.
                concatenate ls_lfa1-stras ls_lfa1-pstlz
                            ls_lfa1-ort01
                       into ls_data-adres.

                ls_data-verkf = ls_lfm1-verkf.
                ls_data-sorumlu_tel = ls_lfm1-telf1.

                modify gt_nakliye from ls_data index ls_good-row_id.

              else.
                error_field 'ZMM' '061' 'E' ' ' 'LIFNR' ls_good-row_id.
              endif.
            endif.

          else.

            clear: ls_data-name1, ls_data-name1, ls_data-telf1,
                   ls_data-verkf, ls_data-stenr,ls_data-sorumlu_tel,
                   ls_data-adres, ls_data-kazanan,ls_data-lifnr,
                   ls_data-nakliye_ucret,ls_data-mwskz,ls_data-kdv_nakliye_ucret,
                   ls_data-fatura_no,ls_data-fkdat, ls_data-aciklama, ls_data-kdvtutar.
            modify gt_nakliye from ls_data index ls_good-row_id.
          endif.
      endcase.
    endloop.

    """alv ekran set
    perform set_nakliye_alv_screen tables gt_nakliye.


    if g_grid_nakliye is not initial.

      ls_stable-row = abap_true.
      ls_stable-col = abap_true.

      g_grid_nakliye->refresh_table_display(
        exporting
          is_stable = ls_stable
        exceptions
          finished  = 1
          others    = 2 ).
    endif.


  endmethod.
  "-----------------------------------------------------------------------"
  "-----------------------------------------------------------------------"
  "-----------------------------------------------------------------------"
  method handle_user_command.
    data: ls_stable type lvc_s_stbl,
          lv_error, lv_ans.


    clear: gt_row[], gs_row.
    call method g_grid_nakliye->get_selected_rows
      importing
        et_index_rows = gt_row.

    case e_ucomm.
      when 'EKLE'.
        perform satir_ekle_nakliye.

      when 'SIL'.
        clear lv_error.
        perform check_satir_sil_nkl changing lv_error.
        if lv_error is initial.
          perform popup_to_confirm using lv_ans.
          if lv_ans eq 1.
            perform satir_sil_nakliye.
          endif.
        endif.

      when 'KAYDET'.
        perform check_nakliye_save changing lv_error.
        if lv_error is initial.
          perform satir_kaydet_nakliye.
        endif.

      when 'FATURA'.
        perform check_fatura_nakliye changing lv_error.
        if lv_error is initial.
          perform crea_fatura_nakliye.
        endif.
    endcase.

    if g_grid_nakliye is not initial.

      ls_stable-row = abap_true.
      ls_stable-col = abap_true.

      g_grid_nakliye->refresh_table_display(
        exporting
          is_stable = ls_stable
        exceptions
          finished  = 1
          others    = 2 ).
    endif.

  endmethod.                    "handle_user_command

  "-----------------------------------------------------------------------"
  "-----------------------------------------------------------------------"
  "-----------------------------------------------------------------------"
  method toolbar_modify.
    data: ls_toolbar type stb_button.
    if sy-tcode eq 'VL33N'.
    elseif sy-tcode eq 'VL03N'.
    else.

      clear ls_toolbar.
      move 'EKLE' to ls_toolbar-function.
      move icon_insert_row to ls_toolbar-icon.
      move 'Satır Ekle' to ls_toolbar-quickinfo.
      move 'Satır Ekle' to ls_toolbar-text.
      append ls_toolbar to e_object->mt_toolbar.

      "seperator
      CLEAR ls_toolbar.
      ls_toolbar-butn_type = 3.
      APPEND ls_toolbar TO e_object->mt_toolbar.

      move 'SIL' to ls_toolbar-function.
      move icon_delete_row to ls_toolbar-icon.
      move 'Satır Sil' to ls_toolbar-quickinfo.
      move 'Satır Sil' to ls_toolbar-text.
      append ls_toolbar to e_object->mt_toolbar.

      move 'KAYDET' to ls_toolbar-function.
      move icon_system_save to ls_toolbar-icon.
      move 'Kaydet' to ls_toolbar-quickinfo.
      move 'Kaydet' to ls_toolbar-text.
      append ls_toolbar to e_object->mt_toolbar.

      move 'FATURA' to ls_toolbar-function.
      move icon_annotation to ls_toolbar-icon.
      move 'Fatura Oluştur' to ls_toolbar-quickinfo.
      move 'Fatura Oluştur' to ls_toolbar-text.
      append ls_toolbar to e_object->mt_toolbar.
    endif.
  endmethod.
  "-----------------------------------------------------------------------"
  "-----------------------------------------------------------------------"
  "-----------------------------------------------------------------------"
  method catch_doubleclick.
*    case e_column.
*      when
**          read table gt_data into gs_data index es_row_no-row_id.
*
*    endcase.
*    call method sender->refresh_table_display.
     CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
      EXPORTING
        NEW_CODE = 'DOUBLE_CLICK'. "PAI tetikle"

    CALL METHOD cl_gui_cfw=>flush.
    call method sender->refresh_table_display.
  endmethod.                "CATCH_DOUBLECLICK
  "-----------------------------------------------------------------------"
  "-----------------------------------------------------------------------"
  "-----------------------------------------------------------------------"
  method handle_hotspot_click.
    data: ls_data    like gt_nakliye,
          ls_stable  type lvc_s_stbl,
          ls_disable type lvc_s_styl.


    case e_column_id.
      when 'BELNR'.
        clear ls_data.
        read table gt_nakliye into ls_data index e_row_id-index.

        set parameter id 'BLN' field ls_data-belnr.
        set parameter id 'BUK' field '1000'.
        set parameter id 'GJR' field ls_data-gjahr.
        call transaction 'FB03' and skip first screen.
    endcase.

    if g_grid_nakliye is not initial.

      ls_stable-row = abap_true.
      ls_stable-col = abap_true.

      g_grid_nakliye->refresh_table_display(
        exporting
          is_stable = ls_stable
        exceptions
          finished  = 1
          others    = 2 ).
    endif.
  endmethod.                    "HANDLE_HOTSPOT_CLICK

endclass.                    "LCL_SZL_NAK IMPLEMENTATION

* Program içerisinden çağırma
form call_nakliye_alv .
  data: lt_exclude type ui_functions.

  if g_custom_cont_nakliye is initial.
    create object g_custom_cont_nakliye
      exporting
        container_name = gc_nakliye.

    create object g_grid_nakliye
      exporting
        i_parent = g_custom_cont_nakliye.

    perform build_fieldcat using 'NAKL'
                           changing gt_fieldcat.
    perform exclude_tb_functions changing lt_exclude.

    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-info_fname = 'COLOR'.
    gs_layout-stylefname = 'LT_DISABLE'.
    gs_variant-report    = sy-repid.
    gs_variant-handle    = 'IMZA'.

    create object g_event_nakliye.
    set handler g_event_nakliye->on_f4                for g_grid_nakliye.
    set handler g_event_nakliye->handle_data_changed  for g_grid_nakliye.
    set handler g_event_nakliye->toolbar_modify       for g_grid_nakliye.
    set handler g_event_nakliye->catch_doubleclick    for g_grid_nakliye.
    set handler g_event_nakliye->handle_hotspot_click for g_grid_nakliye.
    set handler g_event_nakliye->handle_user_command  for g_grid_nakliye.

    call method g_grid_nakliye->set_table_for_first_display
      exporting
        is_variant           = gs_variant
        i_save               = 'A'
        is_layout            = gs_layout
        it_toolbar_excluding = lt_exclude
      changing
        it_fieldcatalog      = gt_fieldcat
        it_outtab            = gt_nakliye[].

    call method: g_grid_nakliye->register_edit_event
      exporting
        i_event_id = cl_gui_alv_grid=>mc_evt_modified,

     g_grid_nakliye->register_edit_event
      exporting
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.

    if sy-tcode eq 'VL03N'.
      call method g_grid_nakliye->set_ready_for_input
        exporting
          i_ready_for_input = 0.

    elseif sy-tcode eq 'VL33N'.
      call method g_grid_nakliye->set_ready_for_input
        exporting
          i_ready_for_input = 0.

    else.
      call method g_grid_nakliye->set_ready_for_input
        exporting
          i_ready_for_input = 1.

    endif.

  else.
    call method g_grid_nakliye->refresh_table_display.
  endif.
endform.

*&---------------------------------------------------------------------*
*& Form BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_       text
*      <--P_GT_FIELDCAT  text
*&---------------------------------------------------------------------*
form build_fieldcat  using p_val changing pt_fieldcat type lvc_t_fcat.
  data ls_fcat type lvc_s_fcat.
  if p_val eq 'NAKL'.
    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
        i_structure_name = 'ZMMS_ITH_NAKLIYE'
      changing
        ct_fieldcat      = pt_fieldcat.

    loop at pt_fieldcat into ls_fcat.
      case ls_fcat-fieldname.
        when 'LIFNR'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.

        when 'NAME1' or 'ADRES' or 'TELF1' or 'SORUMLU_TEL' or
             'STENR' or 'NAKLIYE_UCRET' or 'FKDAT' or 'ACIKLAMA' or
             'KDVTUTAR'.
          ls_fcat-edit = 'X'.

        when 'BELNR'.
          ls_fcat-hotspot = 'X'.

        when 'VERKF'.
          ls_fcat-edit = 'X'.

        when 'MWSKZ'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.

        when 'WAERS'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.

        when 'KAZANAN'.
          ls_fcat-checkbox = 'X'.
          ls_fcat-edit = 'X'.
          ls_fcat-coltext =
          ls_fcat-scrtext_s =
          ls_fcat-scrtext_m =
          ls_fcat-scrtext_l = 'Kazanan Firma'.

        when 'FATURA_NO'.
          ls_fcat-edit = 'X'.
          ls_fcat-coltext =
          ls_fcat-scrtext_s =
          ls_fcat-scrtext_m =
          ls_fcat-scrtext_l = 'Fatura No'.

      endcase.
      modify pt_fieldcat from ls_fcat.
    endloop.

  elseif p_val eq 'MASRAF'.

    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
        i_structure_name = 'ZMMS_ITH_MSR_HDR'
      changing
        ct_fieldcat      = pt_fieldcat.

    loop at pt_fieldcat into ls_fcat.
      case ls_fcat-fieldname.
        when 'MASRAF_TIPI' or 'KDVTUTAR' or
             'ACIKLAMA' or 'FKDAT'.
          ls_fcat-edit = 'X'.

        when 'WAERS' or
             'MWSKZ'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.

        when 'ODEME_TIPI'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.
          ls_fcat-checktable = 'ZMMT_ODEME_TIPI'.

        when 'LIFNR'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.
          ls_fcat-checktable = 'LFA1'.

        when 'ICON'.
          ls_fcat-icon = 'X'.
          ls_fcat-hotspot = 'X'.

        when 'WAERS'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.

        when 'BELNR' or 'BELNR2'.
          ls_fcat-hotspot = 'X'.

        when 'FATURA_NO'.
          ls_fcat-scrtext_s =
          ls_fcat-scrtext_m =
          ls_fcat-scrtext_l =
          ls_fcat-coltext = 'Fatura No'.

      endcase.
      modify pt_fieldcat from ls_fcat.
    endloop.

  elseif p_val eq 'MASRAF_ITEM'.

    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
        i_structure_name = 'ZMMS_ITH_MSR_ITM'
      changing
        ct_fieldcat      = pt_fieldcat.

    loop at pt_fieldcat into ls_fcat.
      case ls_fcat-fieldname.
        when 'KOMISYON_HIZMET'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.

        when 'WAERS'.
*          ls_fcat-edit = 'X'.
*          ls_fcat-just = 'X'.
*          ls_fcat-f4availabl = 'X'.

        when 'MASRAF_TUTAR' or 'ACIKLAMA'.
          ls_fcat-edit = 'X'.

        when 'WAERS' or 'MWSKZ' or 'MASRAF_TIPI'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.

      endcase.
      modify pt_fieldcat from ls_fcat.
    endloop.

  elseif p_val eq 'STATU'.

    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
        i_structure_name = 'ZMMS_ITH_STATU'
      changing
        ct_fieldcat      = pt_fieldcat.

    loop at pt_fieldcat into ls_fcat.
      case ls_fcat-fieldname.
        when 'ACIKLAMA'.
          ls_fcat-edit = 'X'.

        when 'SEVK_STATU' or 'SEVKIYAT_TARIH'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.

      endcase.
      modify pt_fieldcat from ls_fcat.
    endloop.

  elseif p_val eq 'KALEM'.

    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
        i_structure_name = 'ZMMS_ITH_KALEM'
      changing
        ct_fieldcat      = pt_fieldcat.

    loop at pt_fieldcat into ls_fcat.
      case ls_fcat-fieldname.
        when 'VBELN' or 'POSNR'.
          ls_fcat-hotspot = 'X'.
      endcase.
      modify pt_fieldcat from ls_fcat.
    endloop.


  elseif p_val eq 'MAL_BEDEL'.

    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
        i_structure_name = 'ZMMS_MAL_BEDELI_ALV'
      changing
        ct_fieldcat      = pt_fieldcat.

    loop at pt_fieldcat into ls_fcat.
      case ls_fcat-fieldname.
        when 'LFIMG' or 'MEINS'.
          ls_fcat-no_out = 'X'.

        when 'FKDAT' or 'ACIKLAMA' or
             'MASRAF'.
          ls_fcat-edit = 'X'.

        when 'MWSKZ' or 'KDVTUTAR'.
          ls_fcat-no_out = 'X'.

        when 'LIFNR'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'X'.
          ls_fcat-f4availabl = 'X'.

        when 'BELNR'.
          ls_fcat-hotspot = 'X'.

        when 'NETPR'.
          ls_fcat-edit    = 'X'.
          ls_fcat-coltext =
          ls_fcat-scrtext_s =
          ls_fcat-scrtext_m =
          ls_fcat-scrtext_l = 'Mal Bedeli'.

        when 'XBLNR'.
          ls_fcat-edit    = 'X'.
          ls_fcat-scrtext_s =
          ls_fcat-scrtext_m =
          ls_fcat-scrtext_l =
          ls_fcat-coltext = 'Fatura No'.

        when 'KDVLI_MAL_BEDELI'.
          ls_fcat-scrtext_s =
          ls_fcat-scrtext_m =
          ls_fcat-scrtext_l =
          ls_fcat-reptext =
          ls_fcat-coltext = 'Masraf + Mal Bedeli'.
      endcase.
      modify pt_fieldcat from ls_fcat.
    endloop.
  endif.
endform.

*&---------------------------------------------------------------------*
*& Form EXCLUDE_TB_FUNCTIONS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_       text
*      <--P_LT_EXCLUDE  text
*&---------------------------------------------------------------------*
form exclude_tb_functions changing pt_exclude type ui_functions.

  data ls_exclude type ui_func.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_move_row.
  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste.
  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_undo.
  append ls_exclude to pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_auf                   .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_average               .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_back_classic          .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_call_abc              .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_call_chain            .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_call_crbatch          .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_call_crweb            .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_call_lineitems        .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_call_master_data      .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_call_more             .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_call_report           .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_call_xint             .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_call_xxl              .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_check                 .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_col_invisible         .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_col_optimize          .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_count                 .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_current_variant       .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_data_save             .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_delete_filter         .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_deselect_all          .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_detail                .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_expcrdata             .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_expcrdesig            .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_expcrtempl            .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_expmdb                .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_extend                .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_f4                    .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_filter                .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_find                  .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_fix_columns           .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_graph                 .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_help                  .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_html                  .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_info                  .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_load_variant          .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row        .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy              .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_cut               .  append ls_exclude to pt_exclude.
  if pa_type eq 'READONLY'.
    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row          .  append ls_exclude to pt_exclude.
    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row        .  append ls_exclude to pt_exclude.
    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row        .  append ls_exclude to pt_exclude.
    ls_exclude = cl_gui_alv_grid=>mc_fc_excl_all              .  append ls_exclude to pt_exclude.
  endif.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_move_row          .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste             .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row     .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_undo              .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_maintain_variant      .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_maximum               .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_minimum               .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_pc_file               .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_print                 .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_print_back            .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_print_prev            .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_refresh               .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_reprep                .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_save_variant          .  append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_select_all            .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_send                  .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_separator             .   append ls_exclude to pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>MC_FC_SORT                  .   APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>MC_FC_SORT_ASC              .   APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>MC_FC_SORT_DSC              .   APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_subtot                .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_sum                   .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_to_office             .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_to_rep_tree           .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_unfix_columns         .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_url_copy_to_clipboard .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_variant_admin         .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_views                 .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_view_crystal          .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_view_excel            .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_view_grid             .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_view_lotus            .   append ls_exclude to pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_word_processor        .   append ls_exclude to pt_exclude.

endform.

*&---------------------------------------------------------------------*
*&  Include           ZMMI_TESLIMAT_EK_ALAN_DEF
*&---------------------------------------------------------------------*
data: begin of gt_nakliye occurs 0.
    include structure zmms_ith_nakliye.
data: lt_disable type lvc_t_styl,
      del.
data: end of gt_nakliye.
data: gt_del_nakliye like gt_nakliye occurs 0 with header line.

data: begin of gt_masraf_hdr occurs 0.
    include structure zmms_ith_msr_hdr.
data: lt_disable type lvc_t_styl,
      del, color(4).
data: end of gt_masraf_hdr.

data: begin of gt_masraf_itm occurs 0.
    include structure zmms_ith_msr_itm.
data: lt_disable type lvc_t_styl,
      del.
data: end of gt_masraf_itm.
data: gt_del_masraf_itm like gt_masraf_itm occurs 0 with header line,
      gt_masraf_itm_alv like gt_masraf_itm occurs 0 with header line,
      gt_del_masraf_hdr like gt_masraf_hdr occurs 0 with header line,
      gs_masraf_alv     like gt_masraf_itm.

data: begin of gt_statu occurs 0.
    include structure zmms_ith_statu.
data: lt_disable type lvc_t_styl,
      del.
data: end of gt_statu.
data: gt_del_statu like gt_statu occurs 0 with header line.

data: begin of gt_kalem occurs 0.
    include structure zmms_ith_kalem.
data: color(4),
      dagilim like zmms_ith_kalem-masraf.
data: end of gt_kalem.
data: gs_kalem_gnl like zmmt_ith_klm_gnl,
      gt_kalem_gnl like zmmt_ith_klm_gnl occurs 0 with header line.

data: begin of gt_bedel occurs 0.
    include structure zmms_mal_bedeli.
data: end of gt_bedel.

data: begin of gt_mbedel occurs 0.
    include structure zmms_mal_bedeli_alv.
data: lt_disable type lvc_t_styl.
data: end of gt_mbedel.

data: gt_row    type lvc_t_row,
      gs_row    type lvc_s_row,
      ok_code   like sy-ucomm,
      gt_return like bapiret2 occurs 0 with header line,
      gv_error.

data: gv_land1              like lfa1-land1,
      gv_muhatap(10),
      gv_gumruk_musavir     like lfa1-lifnr,
      gv_gumruk_musavir_txt like lfa1-name1,
      gv_land1_txt(40),
      gv_ad(40), r1, r2,
      gv_lifnr              like lfa1-lifnr,
      gv_light(4).

data:   bdcdata like bdcdata occurs 0 with header line.
data:   messtab like bdcmsgcoll occurs 0 with header line.
data:   result  like bdcmsgcoll occurs 0 with header line.
data:   nodata type c value '/'.

define error_field.
  call method er_data_changed->add_protocol_entry
   EXPORTING
     i_msgid     = &1
     i_msgno     = &2
     i_msgty     = &3
     i_msgv1     = &4
     i_fieldname = &5
     i_row_id    = &6.
end-of-definition.

selection-screen begin of block b1 with frame title text-001.
select-options: s_vbeln for likp-vbeln no intervals obligatory
                                       matchcode object zmm_sh025.
selection-screen end of block b1.
