*&---------------------------------------------------------------------*
*& Include          ZCOAA_R_PM_GENERAL_CLS
*&---------------------------------------------------------------------*
class lcl_main definition create public.

  public section."*-----------------PUBLIC SECTION.-------------------------*
    data: gc_cont_alv    type scrfname value 'CC_ALV',
          go_custom_cont type ref to cl_gui_custom_container,
          go_grid_alv    type ref to cl_gui_alv_grid.

    types: tt_alv_data type table of zcoaa_st_pm_general_alv,
           ty_alv_data type zcoaa_st_pm_general_alv.
    types: tr_matnr type range of mara-matnr,
           tr_vkorg type range of vkorg,
           tr_vtweg type range of vtweg,
           tr_kunnr type range of kunnr.

           "zcoaa_st_pm_general_alv:
           key guid       : sysuuid_c32 not null;
           key item_key   : zcoaa_de_key not null;
           key matnr      : matnr not null;
           maktx          : maktx;
           vkorg          : vkorg;
           vtext          : vtxtk;
           vtweg          : vtweg;
           vtweg_t        : vtxtk;
           deleted        : zcoaa_de_deleted;
           modified       : char1;
           error_exists   : char1;
           cellstyle      : lvc_t_styl;
           cellcolor      : lvc_t_scol;
           rowcolor       : char4;
           lticon         : icon_d;

    types: begin of ty_alv_data_with_row,
             rowid type int4.
        include type ty_alv_data.
    types: end of ty_alv_data_with_row,
    tt_alv_data_with_row type table of ty_alv_data_with_row.

    types: begin of ty_a903,
             vkorg       type a903-vkorg,
             vtweg       type a903-vtweg,
             kunnr       type a903-kunnr,
             matnr       type a903-matnr,
             kschl       type a903-kschl,
             kbetr       type konp-kbetr,
             konwa       type konp-konwa,
             kpein       type konp-kpein,
             kmein       type konp-kmein,
             item_status type ty_alv_data-item_status,
           end of ty_a903.
    data t_a903 type table of ty_a903.

    data: t_alv_data type tt_alv_data,
          s_alv_data type ty_alv_data.
    data t_undo_deletion type tt_alv_data_with_row.
    data t_deleted_data type tt_alv_data.

    data c_msgid type bal_s_msg-msgid value 'ZCOAA_01' read-only.
    types: begin of ty_alv_keys,
             matnr type matnr,
             vkorg type vkorg,
             kunnr type kunnr,
             vtweg type vtweg,
           end of ty_alv_keys,
           tt_alv_keys type table of ty_alv_keys.
    data t_alv_keys type tt_alv_keys.
    data key_changed type abap_bool.
    data t_status type table of zcoaa_t_item_st.
    data error_table type bapiret2_t.
    data t_editable_cells type lvc_t_styl.
    data t_lock_cells type lvc_t_styl.
    data skip_data_change type abap_bool.

    methods constructor.
    methods clear_alv_container.
    methods init. "start of program
    methods display_alv.
    methods modify_alv_cell importing io_changed_data    type ref to cl_alv_changed_data_protocol
                                      value(i_row_id)    type int4 optional
                                      value(i_tabix)     type int4 optional
                                      value(i_fieldname) type lvc_fname optional
                                      i_value            type any
                            changing  is_line            type ty_alv_data .
    methods modify_alv_style importing io_changed_data    type ref to cl_alv_changed_data_protocol
                                       value(i_row_id)    type int4 optional
                                       value(i_fieldname) type lvc_fname optional
                                       value(i_style)     type raw4 .


    methods conversion importing i_name          type any
                                 i_type          type char6
                                 i_input         type any
                       exporting value(e_output) type any.
    methods get_data_element_text importing iv_name        type any
                                  returning value(rv_text) type char30.
    methods save_to_db.
    methods update_db_by_modified_fields importing it_alv_data type tt_alv_data.
    methods save_to_message_table importing iv_type   type bapi_mtype
                                            iv_number type symsgno
                                            iv_var1   type symsgv optional
                                            iv_var2   type symsgv optional
                                            iv_var3   type symsgv optional
                                            iv_var4   type symsgv optional.
    methods show_message_popup.
    "*-----------------Events-------------------------*
    methods:
      handle_data_changed for event data_changed of cl_gui_alv_grid
        importing er_data_changed
                    e_ucomm,

      handle_doubleclick for event double_click of cl_gui_alv_grid
        importing e_column
                    es_row_no
                    sender,

      handle_hotspot_click for event hotspot_click of cl_gui_alv_grid
        importing e_row_id
                    e_column_id
                    es_row_no,
      handle_user_command for event user_command of cl_gui_alv_grid
        importing e_ucomm,

      toolbar_modify for event toolbar of cl_gui_alv_grid
        importing e_object
                    e_interactive,

      handle_data_changed_finished        " DATA_CHANGED_FINISHED
            for event data_changed_finished of cl_gui_alv_grid
        importing
            e_modified
            et_good_cells.
  protected section. "*-----------------PROTECTED SECTION-------------------------*
    data t_roid_front type lvc_t_roid.

    methods fetch_alv_data.
    methods fetch_older_records.
    methods: append_initial_line,
      delete_selected_line.
    methods: build_fcat returning value(r_fcat) type lvc_t_fcat,
      exclude_toolbar returning value(r_exclude) type ui_functions  .
    methods: refresh_alv importing iv_soft type abap_bool default abap_true.
    methods: get_current_row_id returning value(r_return) type i.
    methods set_locked_line_style changing s_line type ty_alv_data.
    methods add_protocol_entry importing io_changed_data type ref to cl_alv_changed_data_protocol
                                         is_line         type ty_alv_data
                                         i_fieldname     type lvc_fname
                                         i_rowid         type int4
                                         i_msgno         type bal_s_msg-msgno
                                         i_msgty         type bal_s_msg-msgty
                                         i_msgv1         type bal_s_msg-msgv1 optional
                                         i_msgv2         type bal_s_msg-msgv2 optional
                                         i_msgv3         type bal_s_msg-msgv3 optional
                                         i_msgv4         type bal_s_msg-msgv4 optional.

    methods:
      fill_calculated_cells_by_range importing lr_matnr     type tr_matnr
                                               lr_vkorg     type tr_vkorg
                                               lr_vtweg     type tr_vtweg
                                               lr_kunnr     type tr_kunnr
                                               i_new_record type abap_bool
                                     changing  lt_alv_data  type tt_alv_data,
      generate_guid returning value(r_guid) type sysuuid_c32 .

    methods validate_row importing iv_rowid        type int4
                         changing  is_row          type ty_alv_data
                         returning value(r_return) type abap_bool .
    methods set_defaults.
    methods get_item_status_text    importing value(i_status) type zcoaa_de_item_status
                                    returning value(r_text)   type zcoaa_de_item_status_t.
    methods set_disabled_row changing s_row type ty_alv_data.
    methods calculate_beginning_alv.
    methods calculate_app_fields.
  private section. "*-----------------PRIVATE SECTION-------------------------*

endclass.

class lcl_main implementation.

  method constructor.
    set_defaults( ).
  endmethod.

  method clear_alv_container.
    if go_custom_cont is bound.
      go_custom_cont->free( ).
    endif.
    free: go_custom_cont, go_grid_alv.
  endmethod.

  method init.

    fetch_records( ).
    display_alv( ).

  endmethod.

  method display_alv.
    data ls_layout  type lvc_s_layo  .
    data(edit_mode) = cond i( when is_editable eq abap_true then 1 else 0 ).

    if go_custom_cont is initial.
      create object go_custom_cont
        exporting
          container_name = gc_cont_alv.

      create object go_grid_alv
        exporting
          i_parent = go_custom_cont.

      data(lt_fcat) = me->build_fcat( ).
      data(lt_exclude_toolbar) = me->exclude_toolbar( ).

*      CREATE OBJECT go_danisman_alv
*        EXPORTING
*          toplu_giris = go_toplu_giris.
      set handler go_main->handle_hotspot_click for go_grid_alv.
      set handler go_main->handle_doubleclick for go_grid_alv.
      set handler go_main->handle_data_changed for go_grid_alv.
      set handler go_main->handle_data_changed_finished for go_grid_alv.
      set handler go_main->handle_user_command for go_grid_alv.
      set handler go_main->toolbar_modify for go_grid_alv.

      go_grid_alv->set_ready_for_input( i_ready_for_input = edit_mode ).
      call method go_grid_alv->register_edit_event
        exporting
          i_event_id = cl_gui_alv_grid=>mc_evt_enter.

*      call method go_grid_alv->register_edit_event
*        exporting
*          i_event_id = cl_gui_alv_grid=>mc_evt_modified.
**      go_grid_alv->set_toolbar_interactive( ).
      ls_layout-sel_mode = 'A'.
      ls_layout-info_fname = 'ROWCOLOR'. "satır rengini belirten sütun
      ls_layout-stylefname = 'CELLSTYLE'.
      ls_layout-ctab_fname = 'CELLCOLOR'.
*      ls_layout-cwidth_opt = 'X'.

"alternatif"
"data grid         TYPE REF TO cl_gui_alv_grid,
*     CREATE OBJECT grid
*          EXPORTING
*            i_parent          = cl_gui_container=>default_screen
*          EXCEPTIONS ##SUBRC_OK
*            error_cntl_create = 1
*            error_cntl_init   = 2
*            error_cntl_link   = 3
*            error_dp_create   = 4
*            OTHERS            = 5.
      "variant
      DATA(ls_variant) = VALUE disvariant( report = sy-repid ).
      ls_variant-variant = p_vari. "parametreden gelen

      go_grid_alv->set_table_for_first_display(
          exporting
*            i_buffer_active               =
*            i_bypassing_buffer            =
*            i_consistency_check           =
*            i_structure_name              =
            is_variant                    = ls_variant
            i_save                        = 'A'
*            i_default                     = 'X'
            is_layout                     = ls_layout
*            is_print                      =
*            it_special_groups             =
            it_toolbar_excluding          = lt_exclude_toolbar
*            it_hyperlink                  =
*            it_alv_graphics               =
*            it_except_qinfo               =
*            ir_salv_adapter               =
        changing
          it_outtab                     = t_alv_data[]
          it_fieldcatalog               = lt_fcat
*            it_sort                       =
*            it_filter                     =
        exceptions
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          others                        = 4
      ).
      if sy-subrc <> 0.
        message id sy-msgid type sy-msgty number sy-msgno
                   with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      endif.

      "f4 register
      data(lt_f4) = value lvc_t_f4( chngeafter = 'X'
                                    ( fieldname = 'MATNR' )
                                    ( fieldname = 'VKORG' )
                                    ( fieldname = 'VTWEG' )
                                     ).
      call method go_grid_alv->register_f4_for_fields
        exporting
          it_f4 = lt_f4.
    else.
      data: ls_stable type lvc_s_stbl value 'XX'.
      call method go_grid_alv->refresh_table_display
        exporting
          is_stable = ls_stable
*         i_soft_refresh =
        .
      go_grid_alv->set_ready_for_input( i_ready_for_input = edit_mode ).
    endif.
  endmethod.

  method build_fcat.
    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
        i_structure_name = 'ZCOAA_ST_PM_GENERAL_ALV'
      changing
        ct_fieldcat      = r_fcat.

    loop at r_fcat assigning field-symbol(<fcat>).
      case <fcat>-fieldname.
        when 'GUID' or 'ITEM_KEY' or 'ITEM_STATUS' or 'MODIFIED' or 'ERROR_EXISTS' or 'LTICON'
         or 'ROWCOLOR' or 'CELLSTYLE' or 'COLUMN_X_QUAN' or 'COLUMN_Y_QUAN' or 'COLUMN_Z_QUAN'
         or 'COLUMN_X_QUAN' or 'COLUMN_Y_QUAN' or 'COLUMN_Z_QUAN' or 'COLUMN_X' or 'COLUMN_Y' or 'COLUMN_Z'
         or 'TOT_QS_APPORT' .
          <fcat>-tech = 'X'.
        when 'MATNR'.
          <fcat>-outputlen = 20.
          <fcat>-key = 'X'.
          <fcat>-edit = 'X'.
        when 'MAKTX' or 'ST_DESC' or 'VTWEG_T' or 'HL_DESC' or 'PRODH_DESC' or 'PROJ_DESC'.
          <fcat>-outputlen = 30.
        when 'FEATURE_DESC' or 'COUNTRY_DESC'.
          <fcat>-outputlen = 10.
        when 'VKORG'.
          <fcat>-outputlen = 10.
          <fcat>-key = 'X'.
          <fcat>-edit = 'X'.
          <fcat>-hotspot = 'X'.
        when 'VTWEG'.
          <fcat>-outputlen = 10.
          <fcat>-key = 'X'.
          <fcat>-edit = 'X'.
        when 'KUNNR'.
          <fcat>-outputlen = 10.
          <fcat>-key = 'X'.
          <fcat>-edit = 'X'.
        when 'IS_LOCKED'.
          <fcat>-checkbox = 'X'.
          <fcat>-edit = 'X'.
          <fcat>-outputlen = 5.
        when 'PROD_START' or 'PROD_END' or
             'MODIF_DATE' or 'TOT_DD_APPORT' or 'TOT_JF_APPORT' or 'TOT_TO_APPORT' or
             'TOT_QS_APPORT' or 'APP_QUAN_DD' or
             'APP_QUAN_JF' or 'APP_QUAN_TO' or 'COLUMN_X_QUAN' or 'COLUMN_Y_QUAN' or
             'COLUMN_Z_QUAN' or 'TEXT'."or 'APP_DD' or 'APP_JF' or 'APP_QS'.
          <fcat>-edit = 'X'.
        when 'PRELIMANARY' or 'STATUS'.
          <fcat>-outputlen = 15.
          <fcat>-edit = 'X'.
          <fcat>-f4availabl = 'X'.
        when 'WERKS'.
          <fcat>-edit = 'X'.
          <fcat>-outputlen = 5.
        when 'DELETED'.
          <fcat>-ls_fieldcat-just = 'X'.
      endcase.
    endloop.
  endmethod.

  method handle_data_changed.
    skip_data_change = abap_false.
    "handle deletion
*    if lines( er_data_changed->mt_deleted_rows ) > 0.
*      skip_data_change = abap_true.
*      data ls_undo_del type ty_alv_data_with_row.
*      loop at er_data_changed->mt_deleted_rows into data(ls_deleted).
*        read table t_alv_data into data(ls_alv_data) index ls_deleted-row_id.
*        if sy-subrc eq 0.
*          if line_exists( t_alv_data[ matnr = ls_alv_data-matnr kunnr = ls_alv_data-kunnr
*                                      vtweg = ls_alv_data-vtweg vkorg = ls_alv_data-vkorg item_status = ls_alv_data-item_status + 1 ] ).
*
*            add_protocol_entry( io_changed_data = er_data_changed  is_line = ls_alv_data  i_fieldname = ''
*                               i_rowid = ls_deleted-row_id     i_msgno = '017' i_msgty = 'E'  i_msgv1 = ''
*                               i_msgv2 = '' i_msgv3 = '' i_msgv4 = ''  ).
*            move-corresponding ls_alv_data to ls_undo_del.
*            ls_undo_del-rowid = ls_deleted-row_id.
*            append ls_undo_del to t_undo_deletion.
*            continue.
*          endif.
*          append ls_alv_data to t_deleted_data.
*        endif.
*      endloop.
**      return.
*    endif.
    if er_data_changed->mt_inserted_rows[] is not initial.
      skip_data_change = abap_true.
*      return.
    endif.

    "değiştirilen satırları al bunu after_data_changed'de kullan
    t_roid_front = er_data_changed->mt_roid_front.
*    data(lt_changed_row) = er_data_changed->mt_good_cells[].
    data lv_matnr type matnr.
    loop at er_data_changed->mt_good_cells assigning field-symbol(<changed_row>).
      assign t_alv_data[ <changed_row>-row_id ] to field-symbol(<alv_line>).
      if sy-subrc ne 0.
        continue.
      endif.

      case <changed_row>-fieldname.
        when 'MATNR'.
          lv_matnr = <changed_row>-value.
          select single count( * )
            from mara where matnr = lv_matnr.
          if sy-subrc ne 0.
            add_protocol_entry( io_changed_data = er_data_changed  is_line = <alv_line>  i_fieldname = 'MATNR'
                                i_rowid = <changed_row>-row_id     i_msgno = '005' i_msgty = 'E'  i_msgv1 = ''(003)
                                i_msgv2 = conv #( <changed_row>-value ) i_msgv3 = '' i_msgv4 = ''  ).
            continue.
          endif.

        when 'VKORG'.
          select count( * ) from tvko where vkorg = <changed_row>-value.
          if sy-subrc ne 0.
            add_protocol_entry( io_changed_data = er_data_changed  is_line = <alv_line>  i_fieldname = 'VKORG'
                                i_rowid = <changed_row>-row_id     i_msgno = '005' i_msgty = 'E'  i_msgv1 = 'Sales Organization'(004)
                                i_msgv2 = conv #( <changed_row>-value ) i_msgv3 = '' i_msgv4 = ''  ).
            continue.
          endif.


        when 'VTWEG'.
          select single count( * ) from tvtw where vtweg = <changed_row>-value.
          if sy-subrc ne 0.
            add_protocol_entry( io_changed_data = er_data_changed  is_line = <alv_line>  i_fieldname = 'VTWEG'
                               i_rowid = <changed_row>-row_id     i_msgno = '005' i_msgty = 'E'  i_msgv1 = text-007
                               i_msgv2 = conv #( <changed_row>-value ) i_msgv3 = '' i_msgv4 = ''  ).
            continue.
          endif.

        when 'KUNNR'.
          data(lv_kunnr) = conv kunnr( |{ <changed_row>-value alpha = in }| ).
          select count( * ) from kna1 where kunnr = lv_kunnr.
          if sy-subrc ne 0.
            add_protocol_entry( io_changed_data = er_data_changed  is_line = <alv_line>  i_fieldname = 'KUNNR'
                                i_rowid = <changed_row>-row_id     i_msgno = '005' i_msgty = 'E'  i_msgv1 = text-009
                                i_msgv2 = conv #( <changed_row>-value ) i_msgv3 = '' i_msgv4 = ''  ).
            continue.
          endif.

        when 'HL_KUNNR'.

          lv_kunnr = |{ <changed_row>-value alpha = in }|.
          select single count( * ) from kna1 where kunnr = lv_kunnr.
          if sy-subrc ne 0.
            add_protocol_entry( io_changed_data = er_data_changed  is_line = <alv_line>  i_fieldname = 'HL_KUNNR'
                             i_rowid = <changed_row>-row_id     i_msgno = '005' i_msgty = 'E'  i_msgv1 = text-010
                             i_msgv2 = conv #( <changed_row>-value ) i_msgv3 = '' i_msgv4 = ''  ).
            continue.
          endif.

      endcase.
      "set modified
*      modify_alv_cell(
*            exporting
*              io_changed_data = er_data_changed
*              i_row_id        = <changed_row>-row_id
*              i_tabix         = <changed_row>-tabix
*              i_fieldname     = 'MODIFIED'
*              i_value         = 'X'
*            changing
*              is_line         = <alv_line>
*          ).

    endloop.

  endmethod.

  method handle_data_changed_finished.
    data: lr_matnr type tr_matnr,
          lr_kunnr type tr_kunnr,
          lr_vtweg type tr_vtweg,
          lr_vkorg type tr_vkorg.
    data lt_rowids type table of int4.
    data lt_changing_data type tt_alv_data.
    data lt_modified_lines type table of int4.
    data error_occr type abap_bool.
    field-symbols <alv_data> type ty_alv_data.

    if e_modified eq 'X'.

      loop at et_good_cells assigning field-symbol(<cells>).
        at new row_id.
          case <cells>-fieldname.
            when 'MATNR' or 'VKORG' or 'VTWEG' or 'KUNNR'.
              data(ch_ind) = line_index( t_roid_front[ row_id = <cells>-row_id ] ). "değiştirilen satırı al
              if ch_ind is not initial.
                append ch_ind to lt_rowids.
              endif.

            when 'IS_LOCKED'. "toggle lock - change line display
              assign t_alv_data[ <cells>-row_id ] to <alv_data>.
              if <alv_data>-item_status ne -1 and <alv_data>-deleted ne 'X'.
                set_locked_line_style(
                  changing
                    s_line = <alv_data> ).
              endif.
              if not line_exists( lt_modified_lines[ table_line = <cells>-row_id ] ).
                append <cells>-row_id to lt_modified_lines.
              endif.

            when others.
              if not line_exists( lt_modified_lines[ table_line = <cells>-row_id ] ).
                append <cells>-row_id to lt_modified_lines.
              endif.
          endcase.
        endat.
      endloop.
      "get new lines added to alv
      loop at lt_rowids assigning field-symbol(<id>) .
        assign t_alv_data[ <id> ] to <alv_data>.
        if sy-subrc eq 0.
          if <alv_data>-matnr is not initial.
            append value #( option = 'EQ' sign = 'I' low = <alv_data>-matnr ) to lr_matnr.
          endif.
          if <alv_data>-kunnr is not initial.
            append value #( option = 'EQ' sign = 'I' low = <alv_data>-kunnr ) to lr_kunnr.
          endif.
          if <alv_data>-vkorg is not initial.
            append value #( option = 'EQ' sign = 'I' low = <alv_data>-vkorg ) to lr_vkorg.
          endif.
          if <alv_data>-vtweg is not initial.
            append value #( option = 'EQ' sign = 'I' low = <alv_data>-vtweg ) to lr_vtweg.
          endif.
          if <alv_data>-matnr is not initial and <alv_data>-kunnr is not initial and
             <alv_data>-vkorg is not initial and <alv_data>-vtweg is not initial.
            append <alv_data> to lt_changing_data.
          endif.
          if <alv_data> is initial.
            delete lt_rowids where table_line = <id>.
          endif.
        endif.
      endloop.

      if lt_changing_data is not initial. "fill all cells
        "validate new lines
        loop at lt_changing_data assigning field-symbol(<changing_data>).
          if <changing_data>-matnr is not initial and <changing_data>-kunnr is not initial and
             <changing_data>-vkorg is not initial and <changing_data>-vtweg is not initial.

            "cannot add new entry for each keys
            data(line) = lt_rowids[ sy-tabix ].
            data(lv_unlocked_count) = reduce i( init cnt = 0 for wa in t_alv_data
                                               where ( matnr = <changing_data>-matnr and vkorg = <changing_data>-vkorg
                                                 and   vtweg = <changing_data>-vtweg and kunnr = <changing_data>-kunnr
                                                 and   guid eq '' and item_status > -1 )
                                               next cnt = cnt + 1 ).
            if lv_unlocked_count > 1.
              save_to_message_table(
             exporting
               iv_type   = 'E'
               iv_number = '015' "Lock previous modification entries before create new one at line &1
               iv_var1 = |{ line }|
              ).
              error_occr = abap_true.
            endif.
            clear line.
          endif.

        endloop.

        if error_occr eq abap_true.
          show_message_popup( ).
          return.
        endif.
        fill_calculated_cells_by_range(
          exporting
            lr_matnr = lr_matnr
            lr_vkorg = lr_vkorg
            lr_vtweg = lr_vtweg
            lr_kunnr = lr_kunnr
            i_new_record = abap_true
          changing
            lt_alv_data = lt_changing_data
        ).

        loop at lt_changing_data assigning <alv_data>.
          read table lt_rowids into data(lv_asd) index sy-tabix.
          modify t_alv_data from <alv_data> index lv_asd.
        endloop.
        calculate_app_fields( ).
      else. "fill only key texts
        if lr_matnr[] is not initial.
          select mara~matnr, makt~maktx from mara
              left outer join makt on makt~matnr = mara~matnr
                                  and makt~spras = @sy-langu
              where mara~matnr in @lr_matnr
              into table @data(lt_mara).
        endif.
        if lr_vkorg[] is not initial.
          select vkorg, vtext from tvkot
               into table @data(lt_vkorg)
               where vkorg in @lr_vkorg
                 and spras = @sy-langu.
        endif.

        if lr_vtweg[] is not initial.
          select vtweg, vtext from tvtwt
            into table @data(lt_vtweg_t)
            where vtweg in @lr_vtweg
              and spras = @sy-langu.
        endif.

        if lr_kunnr[] is not initial.
          select kunnr, name1 from kna1
            into table @data(lt_cust)
            where kunnr in @lr_kunnr
              and spras = @sy-langu.
        endif.

        loop at lt_rowids assigning field-symbol(<row_id>).
          assign t_alv_data[ <row_id> ] to <alv_data>.
          if sy-subrc eq 0.
            assign lt_mara[ matnr = <alv_data>-matnr ]-maktx to field-symbol(<maktx>).
            if sy-subrc eq 0.
              <alv_data>-maktx = <maktx>.
            endif.
            assign lt_cust[ kunnr = <alv_data>-kunnr ]-name1 to field-symbol(<cust_text>).
            if sy-subrc eq 0.
              <alv_data>-st_desc = <cust_text>.
            endif.

            assign lt_vkorg[ vkorg = <alv_data>-vkorg ]-vtext to field-symbol(<vk_text>).
            if sy-subrc eq 0.
              <alv_data>-vtext = <vk_text>.
            endif.

            assign lt_vtweg_t[ vtweg = <alv_data>-vtweg ]-vtext to field-symbol(<vt_text>).
            if sy-subrc eq 0.
              <alv_data>-vtweg_t = <vt_text>.
            endif.
            <alv_data>-modified = 'X'.
          endif.
        endloop.
      endif.

      "set modified
      loop at lt_modified_lines assigning <row_id>.
        assign t_alv_data[ <row_id> ] to <alv_data>.
        if sy-subrc eq 0.
          <alv_data>-modified = 'X'.
        endif.
      endloop.

      if lt_rowids is not initial or lt_modified_lines is not initial.

      endif.
      refresh_alv( iv_soft = abap_true ).
    endif.
  endmethod.

  method handle_doubleclick.

  endmethod.

  method handle_hotspot_click.

  endmethod.

  method handle_user_command.
    case e_ucomm.
      when c_add_row.
        append_initial_line( ).
        refresh_alv( iv_soft = abap_true ).
      when c_del_row.
        delete_selected_line( ).
        "change field catalog"
        data(lt_new_fcat) = build_fcat( ).
        o_grid_alv->set_frontend_fieldcatalog( it_fieldcatalog = lt_new_fcat ).
        refresh_alv( ).
    endcase.

  endmethod.

  method modify_alv_cell. "Change value of a cell
    call method io_changed_data->modify_cell
      exporting
        i_row_id    = i_row_id
        i_tabix     = i_tabix
        i_fieldname = i_fieldname
        i_value     = i_value.

    field-symbols: <fs> type any.
    assign component i_fieldname of structure is_line to <fs>.
    if <fs> is assigned.
      <fs> = i_value.
    endif.
  endmethod.

  method modify_alv_style.
    "usage
    " handle data changein son kısmında çağırabilirsin
*    PERFORM modify_activity_style
*               USING
*              pr_data_changed
*              'ZZPLAN'
*              p_row_id
*              cl_gui_alv_grid=>mc_style_enabled.


    call method io_changed_data->modify_style
      exporting
        i_row_id    = i_row_id
        i_fieldname = i_fieldname
        i_style     = i_style.

  endmethod.

  method set_locked_line_style.
    data: lt_edit type lvc_t_styl.
    data lv_style type raw4.
    data lt_cellcolor type lvc_t_scol.
    data lv_color type lvc_col .
    CONSTANTS lc_bold TYPE lvc_style VALUE '00000020'. "bold
    "custom sum line
    ls_sum_line-cellstyle = VALUE #( ( fieldname = 'MTTR' style = lc_bold ) ( fieldname = 'ACTUAL_BREAKDOWN' style = lc_bold )
        ( fieldname = 'MTBR' style = lc_bold ) ( fieldname = 'TOTAL_DOWNTIME' style = lc_bold )
        ( style = cl_gui_alv_grid=>mc_style_f4_no style2 = cl_gui_alv_grid=>mc_style_disabled
        style3 = cl_gui_alv_grid=>mc_style4_link_no style4 = cl_gui_alv_grid=>mc_style_no_delete_row ) ).
    "cell row coloring"

    lv_style = cond #( when s_line-is_locked eq abap_true then cl_gui_alv_grid=>mc_style_disabled else cl_gui_alv_grid=>mc_style_enabled ).
    loop at t_lock_cells assigning field-symbol(<cell>).
      <cell>-style = lv_style.
      if s_line-is_locked eq abap_false and s_line-deleted eq ''.
        append value #( fname = <cell>-fieldname color-col = 0 ) to lt_cellcolor.
      endif.
    endloop.

    append lines of t_lock_cells to lt_edit.
    s_line-cellstyle[] = lt_edit[].
    s_line-cellcolor = lt_cellcolor.
  endmethod.

  method add_protocol_entry.
    call method io_changed_data->add_protocol_entry
      exporting
        i_msgid     = c_msgid
        i_msgty     = i_msgty
        i_msgno     = i_msgno
        i_msgv1     = i_msgv1
        i_msgv2     = i_msgv2
        i_msgv3     = i_msgv3
        i_msgv4     = i_msgv4
        i_fieldname = i_fieldname
        i_row_id    = i_rowid.
  endmethod.

  method fetch_alv_data.
*    fetch_older_records( ).
  endmethod.

  method append_initial_line.
    data ls_line type ty_alv_data.
    data: row_id type i.
    data lv_status type zcoaa_de_item_status .

    row_id = get_current_row_id( ).

    if row_id is not initial or ( row_id is initial and t_alv_data is initial ).
      row_id = row_id + 1.
      insert ls_line into t_alv_data index row_id.
    endif.

  endmethod.

  method toolbar_modify.
    data: ls_toolbar type stb_button.

    read table e_object->mt_toolbar into ls_toolbar
         with key function = cl_gui_alv_grid=>mc_fc_loc_delete_row.
    if sy-subrc = 0 .
      ls_toolbar-function = c_del_row.
      modify e_object->mt_toolbar from ls_toolbar index sy-tabix.
    endif.
*    IF is_editable EQ abap_true.
*      CLEAR ls_toolbar.
*      MOVE c_add_row TO ls_toolbar-function.
*      MOVE '@17@' TO ls_toolbar-icon.
*      MOVE TEXT-001 TO ls_toolbar-quickinfo. "add row
*      MOVE ' ' TO ls_toolbar-disabled.
*      APPEND ls_toolbar TO e_object->mt_toolbar.
*
*      CLEAR ls_toolbar.
*      MOVE c_del_row TO ls_toolbar-function.
*      MOVE '@18@' TO ls_toolbar-icon.
*      MOVE TEXT-002 TO ls_toolbar-quickinfo. "del row
*      MOVE ' ' TO ls_toolbar-disabled.
*      APPEND ls_toolbar TO e_object->mt_toolbar.
*    ENDIF.
  endmethod.

  method exclude_toolbar.
    data ls_exclude type ui_func.

*    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
*    APPEND ls_exclude TO r_exclude.
*    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
*    APPEND ls_exclude TO r_exclude.
*    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
*    APPEND ls_exclude TO r_exclude.
  endmethod.

  method refresh_alv.
    data: ls_stable type lvc_s_stbl value 'XX'.

    call method go_grid_alv->refresh_table_display
      exporting
        i_soft_refresh = iv_soft
        is_stable      = ls_stable
      exceptions
        finished       = 1
        others         = 2.
  endmethod.

  method delete_selected_line.
    data row type i.
    data deleted type abap_bool.
    data alv_data type ty_alv_data.
    data error type abap_bool.

    go_grid_alv->get_selected_rows(
      importing
        et_index_rows = data(lt_rows)    " Indexes of Selected Rows
*        et_row_no     =     " Numeric IDs of Selected Rows
    ).

    if lt_rows is initial.
      row = get_current_row_id( ).
      if row is initial.
        return.
      endif.
      append value #( index = row ) to lt_rows.
    endif.

    loop at lt_rows assigning field-symbol(<row>).
          delete t_alv_data index <row>-index.
    endloop.
  endmethod.

  method get_current_row_id.
    data: row_id type lvc_s_row,
          row_no type lvc_s_roid.

    call method go_grid_alv->get_current_cell
      importing
        e_row = r_return.
  endmethod.

  method conversion.
    data: lv_func type char40.

    concatenate 'CONVERSION_EXIT_' i_name '_' i_type into lv_func.

    call function lv_func
      exporting
        input        = i_input
      importing
        output       = e_output
      exceptions
        length_error = 1
        others       = 2.
  endmethod.

  method save_to_db.

  endmethod.

  method update_db_by_modified_fields.

  endmethod.

  method save_to_message_table.
    append value #( id = c_msgid
                    type = iv_type
                    number = iv_number
                    message_v1 = iv_var1
                    message_v2 = iv_var2
                    message_v3 = iv_var3
                    message_v4 = iv_var4  ) to error_table.
  endmethod.

  method validate_row.
    data lo_log type ref to cl_alv_changed_data_protocol.
    data: ls_comp type abap_componentdescr,
          ls_stru type ref to cl_abap_structdescr,
          lt_comp type standard table of abap_componentdescr with key name.
    data lt_obligatory_fields type table of lvc_fname.
    data lo_elem_descr     type ref to cl_abap_elemdescr.

    r_return = abap_true.
    lt_obligatory_fields = value #( ( 'VKORG' )
                                    ( 'MATNR' )
                                    ( 'VTWEG' )
                                    ( 'KUNNR' )
                                    ( 'PROD_START' )
                                    ( 'PROD_END' )
                                    ( 'PRELIMANARY' )
                                    ( 'STATUS' )
                                    ( 'WERKS' )
             ).
    if is_row-item_status > 0.
      append 'MODIF_DATE' to lt_obligatory_fields.
    endif.

    ls_stru ?= cl_abap_typedescr=>describe_by_data( is_row ).
    lt_comp = ls_stru->get_components( ).
    "check are obligatory fields filled
    loop at lt_comp assigning field-symbol(<comp>).
      assign component <comp>-name of structure is_row to field-symbol(<field>).
      if <field> is assigned.
        if <field> is initial and line_exists( lt_obligatory_fields[ table_line = <comp>-name ] ).
          lo_elem_descr ?= <comp>-type.
          data(elem_text) =  lo_elem_descr->get_ddic_field( )-scrtext_m.
          save_to_message_table(
            exporting
              iv_type   = 'E'
              iv_number = '011'
              iv_var1 = conv symsgv( elem_text )
              iv_var2 = |{ iv_rowid }|
          ).
          r_return = abap_false.
        endif.
      endif.
    endloop.
    "cannot fill modif date while status eq initial
    if is_row-item_status eq 0 and is_row-modif_date is not initial.
      save_to_message_table(
            exporting
              iv_type   = 'E'
              iv_number = '012'
              iv_var1 = |{ iv_rowid }|
          ).
      r_return = abap_false.
    endif.
    "only one key entry can be inserted for each session
    data(lv_count) = reduce i( init cnt = 0 for wa in t_alv_data
                               where ( matnr = is_row-matnr and vkorg = is_row-vkorg
                                 and   vtweg = is_row-vtweg and kunnr = is_row-kunnr
                                 and   guid = '' and item_status > -1 )
                               next cnt = cnt + 1 ).
    if lv_count > 1.
      save_to_message_table(
            exporting
              iv_type   = 'E'
              iv_number = '013' "You can create only one entry for each keys at each session
              iv_var1 = |{ iv_rowid }|
          ).
    endif.

    "cannot add new entry if there is any modification data which locked = ''
    data(lv_unlocked_count) = reduce i( init cnt = 0 for wa in t_alv_data
                                               where ( matnr = is_row-matnr and vkorg = is_row-vkorg
                                                 and   vtweg = is_row-vtweg and kunnr = is_row-kunnr
                                                 and   guid eq '' and item_status > -1 and is_locked = '' )
                                               next cnt = cnt + 1 ).
    if lv_unlocked_count > 1.
      save_to_message_table(
            exporting
              iv_type   = 'E'
              iv_number = '015' "Lock previous modification entries before create new one at line &1
              iv_var1 = |{ iv_rowid }|
          ).
    endif.

    if r_return eq abap_false.
      is_row-error_exists = 'X'.
      return.
    endif.
    is_row-error_exists = ''.
  endmethod.

  method show_message_popup.

    if error_table is initial.
      return.
    endif.
    loop at error_table assigning field-symbol(<error>).
      call function 'MESSAGE_TEXT_BUILD'
        exporting
          msgid               = <error>-id
          msgnr               = <error>-number
          msgv1               = <error>-message_v1
          msgv2               = <error>-message_v2
          msgv3               = <error>-message_v3
          msgv4               = <error>-message_v4
        importing
          message_text_output = <error>-message.     " Output message text

    endloop.

    call function 'RSCRMBW_DISPLAY_BAPIRET2'
      tables
        it_return = error_table.

    clear error_table[].
  endmethod.


  method set_defaults.
    t_editable_cells = value #( style = cl_gui_alv_grid=>mc_style_enabled
                        ( fieldname = 'MATNR' )
                        ( fieldname = 'VKORG' )
                        ( fieldname = 'VTWEG' )
                        ( fieldname = 'KUNNR' )
                        ( fieldname = 'PROD_START' )
                        ( fieldname = 'PROD_END' )
                        ( fieldname = 'PRELIMANARY' )
                        ( fieldname = 'STATUS' )
                        ( fieldname = 'WERKS' )
                        ( fieldname = 'MODIF_DATE' )
                        ( fieldname = 'TOT_DD_APPORT' )
                        ( fieldname = 'TOT_JF_APPORT' )
                        ( fieldname = 'TOT_TO_APPORT' )
                        ( fieldname = 'TOT_QS_APPORT' )
                        ( fieldname = 'COLUMN_X' )
                        ( fieldname = 'COLUMN_Y' )
                        ( fieldname = 'COLUMN_Z' )
                        ( fieldname = 'APP_QUAN_DD' )
                        ( fieldname = 'APP_QUAN_JF' )
                        ( fieldname = 'APP_QUAN_TO' )
                        ( fieldname = 'COLUMN_X_QUAN' )
                        ( fieldname = 'COLUMN_Y_QUAN' )
                        ( fieldname = 'COLUMN_Z_QUAN' )
                        ( fieldname = 'IS_LOCKED' )
                        ( fieldname = 'TEXT' ) ).

    t_lock_cells = value lvc_t_styl( style = cl_gui_alv_grid=>mc_style_enabled
                                          ( fieldname = 'TOT_DD_APPORT' )
                                          ( fieldname = 'TOT_JF_APPORT' )
                                          ( fieldname = 'TOT_TO_APPORT' )
                                          ( fieldname = 'TOT_QS_APPORT' )
                                          ( fieldname = 'APP_QUAN_DD' )
                                          ( fieldname = 'APP_QUAN_JF' )
                                          ( fieldname = 'APP_QUAN_TO' )
                                           ).
  endmethod.

  method fill_calculated_cells_by_range.
    "tablo doldurma işlemleri"
  endmethod.


  method get_item_status_text.
    if i_status eq -1.
      r_text = text-015."'Total'.
    elseif i_status eq 0.
      r_text = text-016."'Initial'.
    elseif i_status > 0.
      r_text = |{ text-017 } { i_status }|."|Modification { i_status }|.
    endif.
  endmethod.

  method set_disabled_row.
    data: ls_comp type abap_componentdescr,
          ls_stru type ref to cl_abap_structdescr,
          lt_comp type standard table of abap_componentdescr with key name.
    data: lt_edit type lvc_t_styl,
          ls_edit type lvc_s_styl.
"edit mode kapa"

    ls_stru ?= cl_abap_typedescr=>describe_by_data( s_row ).
    lt_comp = ls_stru->get_components( ).
    "check are obligatory fields filled
    ls_edit-style = cl_gui_alv_grid=>mc_style_disabled.
    loop at lt_comp assigning field-symbol(<comp>).
      ls_edit-fieldname = <comp>-name.
      insert ls_edit into table lt_edit.
    endloop.

    s_row-cellstyle[] = lt_edit[].
    clear s_row-cellcolor.
  endmethod.

endclass.

MODULE user_command_0101 INPUT.
    "gui status event handler
    CLEAR save_code.
    save_code = ok_code.
    CLEAR ok_code.
    o_grid_alv->set_function_code(
              CHANGING
                c_ucomm = save_code    " Function Code
            ).
ENDMODULE.
