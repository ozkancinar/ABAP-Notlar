*&---------------------------------------------------------------------*
*& Report ZOZ_SALV_FULL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoz_salv_full.

CLASS lcl_salv DEFINITION.

  PUBLIC SECTION.
    DATA t_data TYPE TABLE OF mara.
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
    METHODS set_color IMPORTING name TYPE lvc_fname
                                col TYPE lvc_col
                                int  type lvc_int
                                inv  type lvc_inv
                      changing lo_columns TYPE REF TO cl_salv_columns_table.


  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_salv IMPLEMENTATION.

  METHOD init.
    get_data( ).
    display_alv( ).
  ENDMETHOD.

  METHOD get_data.
    SELECT * FROM mara INTO TABLE t_data.
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
    o_alv->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    lo_functions = o_alv->get_functions( ).
*    lo_functions->set_default( abap_true ). "Alternatif
    lo_functions->set_all( abap_true ).
    "Alternatif2
    "Eğer özel pf status tasarladıysan üstteki lo_functions kodlarını kapat ve alta pf statusun adını ver
*    o_alv->set_screen_status( report        = 'SAPLSLVC_FULLSCREEN'
*                              pfstatus      = 'STANDARD_FULLSCREEN'
*                              set_functions = o_alv->c_functions_all ).

    "*-----------------Layout-Display Settings-------------------------*
    lo_display = o_alv->get_display_settings( ).
    lo_display->set_striped_pattern( cl_salv_display_settings=>true ). "zebra
    lo_display->set_list_header( 'SALV Full Template' ). "gui_title
    lo_display->set_horizontal_lines( cl_salv_display_settings=>false ). "yatay çerçeve çizgisi
    lo_display->set_vertical_lines( cl_salv_display_settings=>true ). "dikey çerçeve çizgisi

    "*-----------------Columns - Fieldcatalog-------------------------*
    lo_columns = o_alv->get_columns( ).
    lo_columns->set_optimize( abap_true ).
    lo_columns->set_key_fixation( abap_true ).
    build_columns( CHANGING lo_columns = lo_columns ).



    "*-----------------Display-------------------------*
    o_alv->display( ).

  ENDMETHOD.

  METHOD build_columns.
    DATA lo_column  TYPE REF TO cl_salv_column_table.

    "*-----------------Set Column Texts-------------------------*
*   set_text( EXPORTING name =  s_text = m_text =  l_text =  CHANGING lo_columns =  ).
    set_text( EXPORTING name = 'ERSDA' s_text = 'Tarih' m_text = 'Tarih' l_text = 'Tarih' CHANGING lo_columns = lo_columns ).
    set_text( EXPORTING name = 'MATNR' s_text = 'Malzeme' m_text = 'Malzeme' l_text = 'Malzeme' CHANGING lo_columns = lo_columns ).

    "*-----------------Set Color-------------------------*
    set_color( EXPORTING name = 'ERSDA'  col = 5 int = 0 inv = 0 CHANGING lo_columns = lo_columns ).
    set_color( EXPORTING name = 'ERNAM'  col = 6 int = 1 inv = 0 CHANGING lo_columns = lo_columns ).

    "*-----------------Colum Design-------------------------*
    TRY.
        lo_column ?= lo_columns->get_column( 'LAEDA' ).
        lo_column->set_technical( ). "technical
        lo_column ?= lo_columns->get_column( 'AENAM' ).
        lo_column->set_visible( abap_false ). "no_out
        lo_column ?= lo_columns->get_column( 'PSTAT' ).
      CATCH cx_salv_not_found INTO DATA(err).
    ENDTRY.

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
        data ls_col TYPE lvc_s_colo .
        lo_column ?= lo_columns->get_column( name ).
        lo_column->set_color( value = VALUE lvc_s_colo( col = col int = int inv = inv ) ).
      CATCH cx_salv_not_found INTO DATA(err).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA(lo_salv) = NEW lcl_salv( ).
  lo_salv->init( ).
