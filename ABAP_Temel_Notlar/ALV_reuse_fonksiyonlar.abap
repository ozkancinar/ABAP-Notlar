* Değişen veriyi oku
data REF_GRID TYPE REF TO CL_GUI_ALV_GRID.
IF REF_GRID IS INITIAL.
        CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
          IMPORTING
            E_GRID = REF_GRID.
      ENDIF.
      IF NOT REF_GRID IS INITIAL.
        CALL METHOD REF_GRID->CHECK_CHANGED_DATA .
      ENDIF.
*-------------------------------------------
* Seçili satırı al
 data : REF_GRID TYPE REF TO CL_GUI_ALV_GRID,
        lt_index_rows type lvc_t_row with header line,
        ref1 type ref to cl_gui_alv_grid.
IF REF_GRID IS INITIAL.
  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      E_GRID = REF_GRID.
ENDIF.
IF NOT REF_GRID IS INITIAL.
  CALL METHOD ref_grid->get_selected_rows
    IMPORTING
      et_index_rows = lt_index_rows[].
ENDIF.
loop at lt_index_rows where index > 0 and rowtype is initial.
  read table lt_data into wa_data index lt_index_rows-index.
endloop.
*-------------------------------------------
