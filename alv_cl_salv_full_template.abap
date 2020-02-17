*&---------------------------------------------------------------------*
*& Report ZOZ_SALV_FULL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoz_salv_full.

CLASS lcl_salv DEFINITION.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_data,
             icon      TYPE icon_d,
             reason    TYPE string,
             t_resdrop TYPE salv_t_int4_column,
             checkbox  TYPE sap_bool,
             matnr     TYPE matnr,
             ersda     TYPE ersda,
             ernam     TYPE  ernam,
             laeda     TYPE  laeda,
             aenam     TYPE  aenam,
             vpsta     TYPE  vpsta,
             pstat     TYPE  pstat_d,
             lvorm     TYPE  lvoma,
             mtart     TYPE  mtart,
             mbrsh     TYPE  mbrsh,
             matkl     TYPE  matkl,
             bismt     TYPE  bismt,
             meins     TYPE  meins,
             bstme     TYPE  bstme,
             zeinr     TYPE  dzeinr,
             fkimg     TYPE fkimg,
             cellcolor TYPE lvc_t_scol,
             celltype  TYPE salv_t_int4_column,
           END OF ty_data.

    DATA t_data TYPE TABLE OF ty_data.
    "-ALV Declarations
    DATA o_alv TYPE REF TO cl_salv_table.
    METHODS: init.
    METHODS get_data.
    METHODS display_alv.
    METHODS build_columns CHANGING lo_columns TYPE REF TO cl_salv_columns_table.
    METHODS set_text IMPORTING name       TYPE lvc_fname
                               s_text     TYPE scrtext_s
                               m_text     TYPE scrtext_m
                               l_text     TYPE scrtext_l
                     CHANGING  lo_columns TYPE REF TO cl_salv_columns_table.
    METHODS set_color IMPORTING name       TYPE lvc_fname
                                col        TYPE lvc_col
                                int        TYPE lvc_int
                                inv        TYPE lvc_inv
                      CHANGING  lo_columns TYPE REF TO cl_salv_columns_table.

    METHODS create_top_of_page.
    "*-----------------EVENTS-------------------------*
    METHODS on_link_click FOR EVENT link_click OF cl_salv_events_table
      IMPORTING row column.
    METHODS: on_user_command FOR EVENT added_function OF cl_salv_events
      IMPORTING e_salv_function.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_salv IMPLEMENTATION.

  METHOD init.
    get_data( ).
    display_alv( ).
  ENDMETHOD.

  METHOD get_data.
    FIELD-SYMBOLS <data> TYPE ty_data.

    SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE t_data UP TO 100 ROWS.

    "*-----------------Insert dropdown data for reason-------------------------*
*    DATA: ls_dropdown TYPE salv_s_int4_column,
*          lt_dropdown TYPE salv_t_int4_column.
*
*    LOOP AT t_data ASSIGNING FIELD-SYMBOL(<data>).
*      <data>-reason = |Reason{ <data>-ersda }|.
*      IF sy-tabix < 3.
*        ls_dropdown-columnname = 'REASON'.
*        ls_dropdown-value      = sy-tabix.
*        APPEND ls_dropdown TO lt_dropdown.
*
*        <data>-t_resdrop = lt_dropdown.
*      ENDIF.
*      CLEAR: ls_dropdown, lt_dropdown.
*    ENDLOOP.

    "*-----------------Cell Coloring-------------------------*
    DATA: ls_color TYPE lvc_s_scol,
          lt_color TYPE lvc_t_scol.
    LOOP AT t_data ASSIGNING <data>.
      IF sy-tabix MOD 2 = 0.
        ls_color-fname     = 'AENAM'.
        ls_color-color-col = 6.
        ls_color-color-int = 0.
        ls_color-color-inv = 0.
        APPEND ls_color TO lt_color.
      ELSEIF sy-tabix MOD 3 = 0.
        ls_color-fname     = 'PSTAT'.
        ls_color-color-col = 3.
        ls_color-color-int = 0.
        ls_color-color-inv = 0.
        APPEND ls_color TO lt_color.
      ELSEIF sy-tabix MOD 5 = 0.
        "satır renklendirmek için fname alanını boş bırak
        ls_color-color-col = 4.
        ls_color-color-int = 1.
        ls_color-color-inv = 0.
        APPEND ls_color TO lt_color.
      ENDIF.

      <data>-cellcolor = lt_color.

      "icon
      <data>-icon = '@0V@'.
      CLEAR: ls_color, lt_color.
    ENDLOOP.

    "change layout of alv clickable cells
    LOOP AT t_data ASSIGNING FIELD-SYMBOL(<alv_line>).
      IF <alv_line>-matnr IS INITIAL.
        APPEND VALUE #( columnname = 'DELIVERY_SD' value = if_salv_c_cell_type=>text ) TO <alv_line>-celltype.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD display_alv.
    DATA lo_functions TYPE REF TO cl_salv_functions_list.
    DATA lo_display TYPE REF TO cl_salv_display_settings.
    DATA: lo_columns TYPE REF TO cl_salv_columns_table.

    DATA ls_key TYPE salv_s_layout_key .

    TRY.
        CALL METHOD cl_salv_table=>factory
*          EXPORTING
*            R_CONTAINER  = calv_const_post
          IMPORTING
            r_salv_table = o_alv
          CHANGING
            t_table      = t_data.
      CATCH cx_salv_msg INTO DATA(lo_err).
        MESSAGE ID lo_err->msgid TYPE lo_err->msgty NUMBER lo_err->msgno WITH lo_err->msgv1 lo_err->msgv1 lo_err->msgv1 lo_err->msgv1.
        RETURN.
    ENDTRY.

    "*-----------------Toolbar Design-------------------------*
    ls_key-report = sy-repid.
    o_alv->get_layout( )->set_key( value = ls_key ).
*    o_alv->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
*    lo_functions = o_alv->get_functions( ).
*    lo_functions->set_default( abap_true ). "Alternatif
*    lo_functions->set_all( abap_true ).
    "Alternatif2
    "Eğer özel pf status tasarladıysan üstteki lo_functions kodlarını kapat ve alta pf statusun adını ver
    o_alv->set_screen_status( report        = sy-repid"'SAPLSLVC_FULLSCREEN'
                              pfstatus      = 'STATUS_MAIN'
                              set_functions = o_alv->c_functions_all ).

    "*-----------------Layout-Display Settings-------------------------*
    lo_display = o_alv->get_display_settings( ).
    lo_display->set_striped_pattern( cl_salv_display_settings=>true ). "zebra
    lo_display->set_list_header( 'SALV Full Template' ). "gui_title
    lo_display->set_horizontal_lines( cl_salv_display_settings=>false ). "yatay çerçeve çizgisi
    lo_display->set_vertical_lines( cl_salv_display_settings=>true ). "dikey çerçeve çizgisi
    lo_display->set_list_header( |Number of displayed rows: { lines( t_data ) }| ). "üstte satır sayısını göster
    "*-----------------TOP-OF-PAGE-------------------------*
    me->create_top_of_page( ).
    "*-----------------Columns - Fieldcatalog-------------------------*
    lo_columns = o_alv->get_columns( ).
    lo_columns->set_optimize( abap_true ).
    lo_columns->set_key_fixation( abap_true ).
    build_columns( CHANGING lo_columns = lo_columns ).

    "*-----------------Dropdown-------------------------*
    "fullscreen'de çalışmaz. Grid'de çalışır
*    DATA: lr_dropdowns TYPE REF TO cl_salv_dropdowns,
*          lt_values    TYPE salv_t_value.
*    DATA: lr_functional_settings TYPE REF TO cl_salv_functional_settings.
*
*    lr_functional_settings = o_alv->get_functional_settings( ).
*
*    lr_dropdowns = lr_functional_settings->get_dropdowns( ).
*
*    TRY.
*        lr_dropdowns->add_dropdown(
*          handle   = 1
*          t_values = lt_values ).
*      CATCH cx_salv_existing.                           "#EC NO_HANDLER
*    ENDTRY.


    "*-----------------Color Column-------------------------*
    TRY.
        lo_columns->set_color_column( 'CELLCOLOR' ).
      CATCH cx_salv_data_error.                         "#EC NO_HANDLER
    ENDTRY.
    TRY.
        lo_columns->set_cell_type_column( 'CELLTYPE' ).
      CATCH cx_salv_data_error.
    ENDTRY.

    "*-----------------Register Events-------------------------*
    DATA: lr_events TYPE REF TO cl_salv_events_table.
    lr_events = o_alv->get_event( ).
    SET HANDLER me->on_link_click FOR lr_events.
    SET HANDLER me->on_user_command FOR lr_events.

    "*-----------------Selection-------------------------*
    DATA: lo_selections TYPE REF TO cl_salv_selections.
    lo_selections = o_alv->get_selections( ).
*    lo_selections->set_selection_mode( if_salv_c_selection_mode=>multiple ). "çoklu seçime izin verir ama solda seçim görünümü olmaz
    lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

    "*-----------------Display-------------------------*
    o_alv->display( ).

  ENDMETHOD.

  METHOD build_columns.
    DATA lo_column  TYPE REF TO cl_salv_column_table.

    "----Alternate"
    DEFINE set_text.
      TRY .
          lr_column ?= lo_columns->get_column( &1 ).
          IF &2 NE space.
            lr_column->set_short_text( conv #( &2 ) ).
          ENDIF.
          IF &3 NE space.
            lr_column->set_medium_text( conv #( &3 ) ).
          ENDIF.
          IF &4 NE space.
            lr_column->set_long_text( conv #( &4 ) ).
          ENDIF.
        CATCH cx_salv_not_found.                        "#EC NO_HANDLER
      ENDTRY.
    END-OF-DEFINITION.
    "----Alternate"

    "*-----------------Set Column Texts-------------------------*
*   set_text( EXPORTING name =  s_text = m_text =  l_text =  CHANGING lo_columns =  ).
    set_text( EXPORTING name = 'ERSDA' s_text = 'Tarih' m_text = 'Tarih' l_text = 'Tarih' CHANGING lo_columns = lo_columns ).
    set_text( EXPORTING name = 'MATNR' s_text = 'Malzeme' m_text = 'Malzeme' l_text = 'Malzeme' CHANGING lo_columns = lo_columns ).
    set_text: 'BSD_SURE' text-012 text-012 text-012.
    "*-----------------Set Color-------------------------*
    set_color( EXPORTING name = 'ERSDA'  col = 5 int = 0 inv = 0 CHANGING lo_columns = lo_columns ).
    set_color( EXPORTING name = 'ERNAM'  col = 6 int = 1 inv = 0 CHANGING lo_columns = lo_columns ).

    "*-----------------Colum Design-------------------------*
    TRY.
*        lo_column ?= lo_columns->get_column( 'T_RESDROP' ).
*        lo_column->set_technical( ). "technical
        lo_column ?= lo_columns->get_column( 'ICON' ).
        lo_column->set_icon( ). "icon
        lo_column ?= lo_columns->get_column( 'REASON' ).
        lo_column->set_visible( abap_false ). "no_out, statusteki layout ile görünüme eklenebilir
*        lo_column ?= lo_columns->get_column( 'CHECKBOX' ).
*        lo_column->set_cell_type( if_salv_c_cell_type=>checkbox ). "checkbox
        lo_column ?= lo_columns->get_column( 'CHECKBOX' ).
        lo_column->set_cell_type( if_salv_c_cell_type=>checkbox_hotspot ). "editable checkbox
        lo_column->set_long_text( 'Checkbox' ).
        lo_column ?= lo_columns->get_column( 'MATNR' ).
        lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
        lo_column ?= lo_columns->get_column( 'FKIMG' ).
        lo_column->set_zero( ' ' ). "değer sıfır olduğunda boşluk olsun
        lo_column ?= lo_columns->get_column( 'CELLTYPE' ).
        lo_column->set_technical( ).
        DATA(asd) = lo_column->get_cell_type( ).
      CATCH cx_salv_not_found INTO DATA(err).
    ENDTRY.

    "*-----------------Dropdown-------------------------*
    "fullscreen'de çalışmaz. Grid'de çalışır
*    TRY.
*        lo_column ?= lo_columns->get_column( 'REASON' ).
*        lo_column->set_cell_type( if_salv_c_cell_type=>dropdown ).
*        lo_column->set_dropdown_entry( value = 1 ).
*      CATCH cx_salv_not_found.
*    ENDTRY.

  ENDMETHOD.

  METHOD set_text.
    DATA lo_column  TYPE REF TO cl_salv_column_table.
    TRY.
        lo_column ?= lo_columns->get_column( name ).
        IF s_text IS NOT INITIAL.
          lo_column->set_short_text( s_text ).
        ENDIF.
        IF m_text IS NOT INITIAL.
          lo_column->set_medium_text( m_text ).
        ENDIF.
        IF l_text IS NOT INITIAL.
          lo_column->set_long_text( l_text ).
        ENDIF.

      CATCH cx_salv_not_found INTO DATA(err).
    ENDTRY.

  ENDMETHOD.

  METHOD set_color.
    DATA lo_column  TYPE REF TO cl_salv_column_table.
    TRY.
        DATA ls_col TYPE lvc_s_colo .
        lo_column ?= lo_columns->get_column( name ).
        lo_column->set_color( value = VALUE lvc_s_colo( col = col int = int inv = inv ) ).
      CATCH cx_salv_not_found INTO DATA(err).
    ENDTRY.

  ENDMETHOD.

  METHOD on_link_click.
    READ TABLE t_data ASSIGNING FIELD-SYMBOL(<line>) INDEX row.
    IF column = 'MATNR'.
      SET PARAMETER ID 'MAT' FIELD <line>-matnr .
      SET PARAMETER ID 'MXX' FIELD 'K' .
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    ELSEIF column = 'CHECKBOX'.
      IF <line>-checkbox IS INITIAL.
        <line>-checkbox = 'X'.
      ELSE.
        CLEAR <line>-checkbox.
      ENDIF.
      o_alv->refresh( ).
    ENDIF.
  ENDMETHOD.

  METHOD on_user_command.
    DATA: lt_rows TYPE salv_t_row,
          lt_cols TYPE salv_t_column,
          ls_cell TYPE salv_s_cell.
    DATA: lr_selections TYPE REF TO cl_salv_selections.

    CASE e_salv_function.
      WHEN 'SHOW_SEL'."show selection
        "display selections
        lr_selections = o_alv->get_selections( ).
        lt_rows = lr_selections->get_selected_rows( ).
        lt_cols = lr_selections->get_selected_columns( ).
        ls_cell = lr_selections->get_current_cell( ).

      WHEN 'SET_ROWS'. "set selected rows

        APPEND 4 TO lt_rows.
        APPEND 5 TO lt_rows.
        APPEND 6 TO lt_rows.
        lr_selections = o_alv->get_selections( ).
        lr_selections->set_selected_rows( lt_rows ).

      WHEN 'SET_COLS'. "set selected cols

        APPEND 'PRICE' TO lt_cols.
        lr_selections = o_alv->get_selections( ).
        lr_selections->set_selected_columns( lt_cols ).

      WHEN 'SET_CELL'." set selected cell

        ls_cell-columnname = 'PLANETYPE'.
        ls_cell-row        = 4.
        lr_selections = o_alv->get_selections( ).
        lr_selections->set_current_cell( ls_cell ).

      WHEN 'SUBTOTAL'.
        DATA: lo_aggregations TYPE REF TO cl_salv_aggregations.
        DATA: lo_groups TYPE REF TO cl_salv_sorts .

        lo_aggregations = o_alv->get_aggregations( ).
        lo_aggregations->clear( ).
        lo_groups = o_alv->get_sorts( ) .
        lo_groups->clear( ).

        TRY.
            lo_groups->add_sort(
               columnname = 'STOK_KODU'
*               position   = 1
               subtotal   = abap_true
               sequence   = if_salv_c_sort=>sort_up ).

          CATCH cx_salv_not_found cx_salv_data_error cx_salv_existing.
        ENDTRY.
        TRY.
            lo_aggregations->add_aggregation( columnname = 'TEORIK_GEREKLI' ).
          CATCH cx_salv_not_found cx_salv_data_error cx_salv_existing.
        ENDTRY.
        o_alv->refresh(
          EXPORTING
*            s_stable     = value lvc_s_stbl( row = 'X' )     " ALV Control: Refresh Stability
            refresh_mode = if_salv_c_refresh=>full    " ALV: Data Element for Constants
        ).
    ENDCASE.
  ENDMETHOD.

  METHOD create_top_of_page.

    DATA: lo_top_element  TYPE REF TO cl_salv_form_layout_grid,
          lo_end_element  TYPE REF TO cl_salv_form_layout_flow,
          lo_grid         TYPE REF TO cl_salv_form_layout_grid,
          lo_header       TYPE REF TO cl_salv_form_header_info,
          lo_action       TYPE REF TO cl_salv_form_action_info,
          lo_textview1    TYPE REF TO cl_salv_form_text,
          lo_textview2    TYPE REF TO cl_salv_form_text,
          lo_textview3    TYPE REF TO cl_salv_form_text,
          lo_textview4    TYPE REF TO cl_salv_form_text,
          lo_icon         TYPE REF TO cl_salv_form_icon,
          lo_layout_grid1 TYPE REF TO cl_salv_form_layout_data_grid,
          lo_layout_grid2 TYPE REF TO cl_salv_form_layout_data_grid,
          lo_layout_grid3 TYPE REF TO cl_salv_form_layout_data_grid,
          lo_layout_grid4 TYPE REF TO cl_salv_form_layout_data_grid,
          lo_logo         TYPE REF TO cl_salv_form_layout_logo.

    CREATE OBJECT lo_top_element
      EXPORTING
        columns = 2.

    "Büyük harfli sayfa başlığı
    lo_top_element->create_header_information(
        row = 1
        column = 1
        text     = 'BAŞLIK'
        tooltip  = 'Alv Başlığı' ).

    "italik küçük harfli bilgi metnü
    lo_top_element->create_action_information(
        row     = 2    " Natural Number
        column  = 1    " Natural Number
        text    = 'Action Info'
        tooltip = 'Italik Text'
    ).

    "yeni bir grid yarat. Giriş parametleri grid'in pozisyonudur
    lo_grid = lo_top_element->create_grid(
              row     = 3
              column  = 1 ).

    lo_textview1 = lo_grid->create_text(
      row     = 1
      column  = 1
      text    = 'New Grid Row 1 Column 1'                   "#EC NOTEXT
      tooltip = 'Tooltip' ).                                "#EC NOTEXT

    lo_textview2 = lo_grid->create_text(
        row     = 1
        column  = 2
        text    = 'New Grid Row 1 Column 2'                 "#EC NOTEXT
        tooltip = 'Tooltip' ).                              "#EC NOTEXT

    "Label & Text
    "Label bold text normal
    lo_grid->create_label(
      EXPORTING
        row         = 2    " Natural Number
        column      = 1    " Natural Number
        text        = 'Ad:'
        tooltip     = 'Label'
        r_label_for = lo_textview3    " Text
    ).

    lo_textview3 = lo_grid->create_text(
        row     = 2
        column  = 2
        text    = 'Özkan Çınar'                             "#EC NOTEXT
        tooltip = 'Labellı TextView' ).                     "#EC NOTEXT

    "Set alignment
    lo_layout_grid1 ?= lo_textview1->get_layout_data( ).
    lo_layout_grid2 ?= lo_textview2->get_layout_data( ).
    lo_layout_grid3 ?= lo_textview3->get_layout_data( ).

    lo_layout_grid1->set_h_align( if_salv_form_c_h_align=>left ).
    lo_layout_grid2->set_h_align( if_salv_form_c_h_align=>right ).
    lo_layout_grid3->set_h_align( if_salv_form_c_h_align=>left ).

    "insert icon
    CREATE OBJECT lo_icon
      EXPORTING
        icon    = '@0A@'     "#EC NOTEXT
        tooltip = 'Air'.     "#EC NOTEXT

    lo_grid->set_element(
      EXPORTING
        row       = 2
        column    = 3
        r_element = lo_icon ).

    "logosuz
    o_alv->set_top_of_list( value = lo_top_element ).

    "insert logo
*    create OBJECT lo_logo.
*    lo_logo->set_left_content( value = lo_top_element ).
*    lo_logo->set_right_logo( value = 'ALV_BACKGROUND' ).
*
*    o_alv->set_top_of_list( value = lo_logo ).

    "*-----------------FOOTER-------------------------*
    DATA: lr_eol TYPE REF TO cl_salv_form_header_info.
    CREATE OBJECT lr_eol
      EXPORTING
        text = 'This is my Footer'.     "#EC NOTEXT

    o_alv->set_end_of_list( lr_eol ).

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA(lo_salv) = NEW lcl_salv( ).
  lo_salv->init( ).
