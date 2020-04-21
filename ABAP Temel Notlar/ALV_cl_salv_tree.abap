DATA: it_sflight type standard table of sflight,
      it_outtab                            like it_sflight,
      wa_sflight                           type sflight.
DATA: lo_tree type ref to cl_salv_tree.
DATA: nodes type ref to cl_salv_nodes,
      node                        type ref to cl_salv_node,
      columns                     type ref to cl_salv_columns,
      lo_functions                type ref TO cl_salv_functions_tree,
      key                         type salv_de_node_key.
SELECT-OPTIONS s_carrid for wa_sflight-carrid.
* Selectdata
SELECT * from sflight into table it_sflight where carrid in s_carrid.
* Createinstancewithanemptytable
  CALL method cl_salv_tree=>factory
  IMPORTING
  r_salv_tree = lo_tree
  CHANGING
  t_table = it_outtab.
* Addthenodestothetree
  NODES = lo_tree->get_nodes( ).
  LOOP at it_sflight into wa_sflight.
    ON change of wa_sflight-carrid.
      CLEAR key.
      TRY.
          node = nodes->add_node( related_node = key
                                  relationship = cl_gui_column_tree=>relat_first_child
                                  data_row = wa_sflight ).
          key = node->get_key( ).
        CATCH cx_salv_msg.
      ENDTRY.
    ENDON.
    TRY.
        node = nodes->add_node( related_node = key
                                relationship = cl_gui_column_tree=>relat_last_child
                                data_row = wa_sflight ).
      CATCH cx_salv_msg.
    ENDTRY.
  ENDLOOP.
  columns = lo_tree->get_columns( ).
  columns->set_optimize( abap_true ).
*Set defaultstatus
  lo_functions = lo_tree->get_functions( ).
  lo_functions->set_all( abap_true ).
*Display table
  lo_tree->display( ).