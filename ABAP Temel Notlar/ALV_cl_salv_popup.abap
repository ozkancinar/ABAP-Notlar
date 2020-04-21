try.
    cl_salv_table=>factory(
      importing
        r_salv_table = gr_table
      changing
        t_table      = gt_outtab ).
  catch cx_salv_msg.                                  "#EC NO_HANDLER
endtry.

*... §3 Functions
*... §3.1 activate ALV generic Functions
data: lr_functions type ref to cl_salv_functions_list.

lr_functions = gr_table->get_functions( ).
lr_functions->set_all( gc_true ).

*... set the columns technical
data: lr_columns type ref to cl_salv_columns.

lr_columns = gr_table->get_columns( ).
lr_columns->set_optimize( gc_true ).

*  TRY.
*  CALL METHOD gr_table->set_screen_status
*    EXPORTING
*      report        = 'SALV_DEMO_TABLE_EVENTS'
*      pfstatus      = 'D0100'
**      SET_FUNCTIONS = C_FUNCTIONS_NONE
    .
*  ENDTRY.


perform set_columns_technical using lr_columns.

*... §4.1 set the size and position of the Popup via coordinates
gr_table->set_screen_popup(
  start_column = 1
  end_column   = 100
  start_line   = 1
  end_line     = 20 ).

*... §4.2 set the selection mode of the Popup: multiple or single row selection
if gs_test-selection eq gc_true.
  data: lr_selections type ref to cl_salv_selections.

  lr_selections = gr_table->get_selections( ).
  lr_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).
endif.

*... §5 display the table
gr_table->display( ).
