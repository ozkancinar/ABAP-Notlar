*&---------------------------------------------------------------------*
*& Report  ZCL_SALV_TABLE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZCL_SALV_TABLE.

CLASS lcl_event DEFINITION DEFERRED.

data: lt_vbap TYPE STANDARD TABLE OF vbap.
data: lcl_salv TYPE REF TO cl_salv_table,
       calv_const_post  TYPE REF TO cl_gui_custom_container,
       lcl_function TYPE REF TO cl_salv_functions_list.
data: gr_events type ref to lcl_event. " Oluşturduğumuz event classı
DATA: lo_aggrs TYPE REF TO cl_salv_aggregations,
      lr_layout TYPE REF TO cl_salv_layout.
DATA: lr_columns TYPE REF TO cl_salv_columns_table,
     lr_column  TYPE REF TO cl_salv_column_table,
     ls_col TYPE lvc_s_colo.
DATA : lr_display TYPE REF TO cl_salv_display_settings.

*&---------------------------------------------------------------------*
*&       Class LCL_EVENT
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS LCL_EVENT DEFINITION.
  PUBLIC SECTION.
    METHODS: on_double_click for event double_click
      of cl_salv_events_table importing row column,

        on_single_click FOR EVENT link_click
        of cl_salv_events_table IMPORTING ROW COLUMN.
    methods:
      on_top_of_page for event top_of_page of cl_salv_events_table
        importing r_top_of_page page table_index,

      on_end_of_page for event end_of_page of cl_salv_events_table
        importing r_end_of_page page.
    methods:
      on_user_command for event added_function of cl_salv_events
        importing e_salv_function,

      on_before_salv_function for event before_salv_function of cl_salv_events
        importing e_salv_function,

      on_after_salv_function for event after_salv_function of cl_salv_events
        importing e_salv_function.

ENDCLASS.               "LCL_EVENT

class LCL_EVENT IMPLEMENTATION.
  METHOD on_double_click.
    perform show_cell_info using 0 row column text-i05.
    MESSAGE 'Double Click' TYPE 'S'.
  ENDMETHOD.

  METHOD on_single_click.
    perform show_cell_info using 1 row column text-i05.
    MESSAGE 'Link Clicked' TYPE 'S'.
  ENDMETHOD.

  "Method on_user_command için SALV_DEMO_TABLE_SELECTIONS programını incele"
ENDCLASS.

START-OF-SELECTION.

  SELECT * FROM vbap INTO TABLE lt_vbap
      UP TO 100 ROWS.

  data ls_key type salv_s_layout_key .

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
*          EXPORTING
*            R_CONTAINER  = calv_const_post
        IMPORTING
          R_SALV_TABLE = lcl_salv
        CHANGING
          T_TABLE      = lt_vbap.
    CATCH CX_SALV_MSG .
      exit.
  ENDTRY.
  ls_key-report = sy-repid.

  lcl_salv->get_layout( )->set_key( value = ls_key ).
  lcl_salv->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ). "value = '3' ). "user and standard"

  lcl_function = lcl_salv->get_functions( ).
  lcl_function->set_default( abap_true ).
  lcl_function->set_all( abap_true ). "alternatif"

  lr_columns = lcl_salv->get_columns( ).
  PERFORM build_columns USING lr_columns.

  CALL METHOD LCL_SALV->SET_SCREEN_STATUS
    EXPORTING
      REPORT        = 'SAPLSLVC_FULLSCREEN'
      PFSTATUS      = 'STANDARD_FULLSCREEN'
      SET_FUNCTIONS = lcl_salv->c_functions_all.

  lr_display = lcl_salv->get_display_settings( ).
  lr_display->set_striped_pattern( cl_salv_display_settings=>true ). "zebra

  data: lr_events type ref to cl_salv_events_table.

  lr_events = lcl_salv->get_event( ).
  CREATE OBJECT gr_events.
  set handler gr_events->on_double_click for lr_events.
  set HANDLER gr_events->on_single_click FOR lr_events.

  "-top of page bknz. SALV_DEMO_TABLE_FORM_EVENTS
  DATA: lr_content TYPE REF TO cl_salv_form_element.
  set_top_of_page( CHANGING cr_content = lr_content ).
  go_salv->set_top_of_list( lr_content ).

*... set list title
*  data: lr_display_settings type ref to cl_salv_display_settings,
*        l_title type lvc_title.
*
*  l_title = text-t01. "BAşlık metni"
*  lr_display_settings = lcl_salv->get_display_settings( ).
*  lr_display_settings->set_list_header( l_title ).


*... §7 selections
* data: lr_selections type ref to cl_salv_selections,
*        lt_rows       type salv_t_row,
*        lt_column     type salv_t_column,
*        ls_cell       type salv_s_cell.
*
*  lr_selections = gr_table->get_selections( ).
*
**... §7.1 set selection mode
*  lr_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).
*
**... §7.2 set selected columns.
*  append 'CARRID' to lt_column.
*  append 'CONNID' to lt_column.
*  append 'FLDATE' to lt_column.
*  lr_selections->set_selected_columns( lt_column ).
*
**... §7.3 set selected rows.
*  append 1 to lt_rows.
*  append 2 to lt_rows.
*  append 3 to lt_rows.
*  lr_selections->set_selected_rows( lt_rows ).
*
**... §7.4 set current cell
*  ls_cell-row        = 4.
*  ls_cell-columnname = 'PRICE'.
*  lr_selections->set_current_cell( ls_cell ).

* ... §8.1 set the size and position of the Popup via coordinates
*  lcl_salv->set_screen_popup(
*    start_column = 20
*    end_column   = 120
*    start_line   = 1
*    end_line     = 20 ).

  lcl_salv->display( ).


end-of-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  BUILD_COLUMNS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LR_COLUMNS  text
*----------------------------------------------------------------------*
FORM BUILD_COLUMNS  USING LR_COLUMNS
  type ref to cl_salv_columns_table.

  lr_columns->set_optimize( 'X' ).

*   DEFINE set_text.
*    try .
*        lr_column ?= lr_columns->get_column( &1 ).
*        if &2 ne space.
*          lr_column->set_short_text( &2 ).
*           lr_column->set_short_text( ' ' ).
*        endif.
*        if &3 ne space.
*          lr_column->set_medium_text( &3 ).
*           lr_column->set_medium_text( ' ' ).
*        endif.
*        if &a4 ne space.
*          lr_column->set_long_text( &4 ).
*        endif.
*      catch cx_salv_not_found.                          "#EC NO_HANDLER
*    endtry.
*  END-OF-DEFINITION.
*
*  set_text: 'ZREADAT' 'Real Date' 'Real Date' 'Real Date'.
*  set_text: 'ZCODE' 'Transaction Code'
*     'Transaction Code' 'Transaction Code'.
*
*  set_text: 'ZPRIDIS' 'PRI Disb' 'PRI Disbursment' 'PRI Disbursment'.
*
* HOTSPOT - Tıklanılabilir hücre
try.
      lr_column ?= lr_columns->get_column( 'VBELN' ).
      lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
*      lr_column->set_icon( if_salv_c_bool_sap=>true ).
      lr_column->set_technical( 'X' ). "Gizle"
      lr_column->set_long_text( 'Vbeln' ).
    catch cx_salv_not_found.                            "#EC NO_HANDLER
  endtry.

  DEFINE set_color.
    TRY .
        lr_column ?= lr_columns->get_column( &1 ).
        ls_col-COL = &2.
        ls_col-INT = '1'.
        ls_col-INV = '0'.
        lr_column->set_color( ls_col ).
      CATCH cx_salv_not_found.                          "#EC NO_HANDLER
    ENDTRY.
  END-OF-DEFINITION.

  set_color: 'MATNR' '7'.
ENDFORM.                    " BUILD_COLUMNS

form show_cell_info using i_level  type i
                          i_row    type i
                          i_column type lvc_fname
                          i_text   type string.

  data: l_row_string type string,
        l_col_string type string,
        l_row        type char128.

  write i_row to l_row left-justified.

  concatenate text-i02 l_row into l_row_string separated by space.
  concatenate text-i03 i_column into l_col_string separated by space.

  if i_level is initial.
    message i000(0k) with i_text l_row_string l_col_string.
  else.
    case i_level.
      when 1.
        message i000(0k) with text-i06 i_text l_row_string l_col_string.
      when 2.
        message i000(0k) with text-i07 i_text l_row_string l_col_string.
    endcase.
  endif.

endform.                    " show_cell_info

METHOD set_top_of_page.
  DATA: lr_grid   TYPE REF TO cl_salv_form_layout_grid,
         lr_grid_1 TYPE REF TO cl_salv_form_layout_grid,
         lr_label  TYPE REF TO cl_salv_form_label,
         lr_text   TYPE REF TO cl_salv_form_text,
         l_text    type string.

   CREATE OBJECT lr_grid.
   l_text = 'TOP OF PAGE for the report' .
   lr_grid->create_header_information(
     row    = 1
     column = 1
     text    = l_text
     tooltip = l_text ).

   lr_grid->add_row( ).

   lr_grid_1 = lr_grid->create_grid(
                 row    = 3
                 column = 1 ).

   lr_label = lr_grid_1->create_label(
     row     = 1
     column  = 1
     text    = 'Number of Data Records'
     tooltip = 'Number of Data Records' ).

   lr_text = lr_grid_1->create_text(
     row     = 1
     column  = 2
     text    = '10'
     tooltip = '10' ).

   lr_label->set_label_for( lr_text ).
   lr_label = lr_grid_1->create_label(
     row    = 2
     column = 1
     text    = 'date'
     tooltip = 'date' ).

   l_text = 'today'.
   lr_text = lr_grid_1->create_text(
     row    = 2
     column = 2
     text    = 'today'
     tooltip = 'today' ).

   lr_label->set_label_for( lr_text ).
   cr_content = lr_grid.
ENDMETHOD.
