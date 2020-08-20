*&---------------------------------------------------------------------*
*& Report zoz_salv_tree_full_template
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoz_salv_tree_full_template.

CLASS lcl_main DEFINITION.

  PUBLIC SECTION.
    METHODS run.

  PROTECTED SECTION.
    DATA: o_tree   TYPE REF TO cl_salv_tree.
    DATA: t_alv_data TYPE TABLE OF spfli.
    DATA: t_db_data TYPE TABLE OF spfli.

    METHODS display_alv.
    METHODS fetch_data.
    METHODS build_header.
    METHODS build_tree.
    METHODS add_carrid_line IMPORTING is_data         TYPE spfli
                                      iv_related_node TYPE lvc_nkey
                            CHANGING  cv_key          TYPE lvc_nkey .
    METHODS add_connid_line IMPORTING is_data         TYPE spfli
                                      iv_related_node TYPE lvc_nkey
                            CHANGING  cv_key          TYPE lvc_nkey .
    METHODS add_complete_line IMPORTING is_data         TYPE spfli
                                        iv_related_node TYPE lvc_nkey
                              CHANGING  cv_key          TYPE lvc_nkey .
    METHODS build_columns.
    METHODS show_event_info IMPORTING i_node_key          TYPE salv_de_node_key
                                      VALUE(i_columnname) TYPE lvc_fname
                                      i_text              TYPE string.
    METHODS show_function_info IMPORTING i_function TYPE salv_de_function
                                         i_text     TYPE string.
    "*-----------------Events-------------------------*
    METHODS:
      on_double_click FOR EVENT double_click OF cl_salv_events_tree
        IMPORTING node_key columnname,
      on_link_click FOR EVENT link_click OF cl_salv_events_tree
        IMPORTING columnname,
      on_before_user_command FOR EVENT before_salv_function OF cl_salv_events
        IMPORTING e_salv_function,
      on_after_user_command FOR EVENT after_salv_function OF cl_salv_events
        IMPORTING e_salv_function,
      on_keypress FOR EVENT keypress OF cl_salv_events_tree
        IMPORTING node_key columnname key,
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD run.
    display_alv( ).
  ENDMETHOD.


  METHOD fetch_data.
    SELECT * FROM spfli ORDER BY carrid, connid INTO TABLE @t_db_data.
  ENDMETHOD.


  METHOD display_alv.
    TRY.
        cl_salv_tree=>factory(
          IMPORTING
            r_salv_tree = o_tree
          CHANGING
            t_table      = t_alv_data ).
      CATCH cx_salv_no_new_data_allowed cx_salv_error INTO DATA(err).
        DATA(asd) = err->get_text( ).
        RETURN.
    ENDTRY.

    build_header( ).
    fetch_data( ).
    build_tree( ).

*    o_tree->set_screen_status(
*        pfstatus      =  'SALV_STANDARD'
*        report        =  sy-repid
*        set_functions =  o_tree->c_functions_all ).
    DATA: lo_functions TYPE REF TO cl_salv_functions_tree.
    lo_functions = o_tree->get_functions( ).
*  lr_functions->set_group_print( abap_false ).
    lo_functions->set_help( abap_false ).
    lo_functions->set_all( ).

    build_columns( ).

    "*-----------------Set Layout-------------------------*
    DATA: lo_layout TYPE REF TO cl_salv_layout,
          ls_key    TYPE salv_s_layout_key.

    lo_layout = o_tree->get_layout( ).
    ls_key-report = sy-repid.
    lo_layout->set_key( ls_key ).
    lo_layout->set_default( abap_true ).
    lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

    "*-----------------Top of & End of Page-------------------------*
    DATA: lo_content TYPE REF TO cl_salv_form_header_info,
          l_text     TYPE string.

*    ... create header information
    CONCATENATE 'TOP_OF_LIST' 'SALV Tree Test' INTO l_text SEPARATED BY space.

    CREATE OBJECT lo_content
      EXPORTING
        text    = l_text
        tooltip = l_text.

    o_tree->set_top_of_list( lo_content ).

    CONCATENATE 'END_OF_LIST' 'SALV Tree Test' INTO l_text SEPARATED BY space.

    CREATE OBJECT lo_content
      EXPORTING
        text    = l_text
        tooltip = l_text.

    o_tree->set_end_of_list( lo_content ).

    "*-----------------Register Events-------------------------*
    DATA: lr_events TYPE REF TO cl_salv_events_tree.

    lr_events = o_tree->get_event( ).

    SET HANDLER me->on_user_command FOR lr_events.
    SET HANDLER me->on_before_user_command FOR lr_events.
    SET HANDLER me->on_after_user_command FOR lr_events.
    SET HANDLER me->on_double_click FOR lr_events.
    SET HANDLER me->on_keypress FOR lr_events.
    SET HANDLER me->on_link_click FOR lr_events.

* register the keys for which keypress should be raised
    TRY.
*    lr_events->add_key_for_keypress( if_salv_c_keys=>f1 ).
        lr_events->add_key_for_keypress( if_salv_c_keys=>f4 ).
        lr_events->add_key_for_keypress( if_salv_c_keys=>enter ).
      CATCH cx_salv_msg.
    ENDTRY.


    o_tree->display( ).

  ENDMETHOD.


  METHOD build_header.

    DATA: settings TYPE REF TO cl_salv_tree_settings.

    settings = o_tree->get_tree_settings( ).
    settings->set_hierarchy_header( CONV #( 'Hierarchy' ) ).
    settings->set_hierarchy_tooltip( CONV #( 'Airline' ) ).
    settings->set_hierarchy_size( 30 ).

    DATA: title TYPE salv_de_tree_text.
    title = 'SALV Tree Template'.
    settings->set_header( title ).

  ENDMETHOD.


  METHOD build_tree.

    DATA: lv_carrid_key TYPE lvc_nkey,
          lv_connid_key TYPE lvc_nkey,
          lv_last_key   TYPE lvc_nkey.

    LOOP AT t_db_data ASSIGNING FIELD-SYMBOL(<alv_data>).

      AT NEW carrid.
        add_carrid_line(
          EXPORTING
            is_data         = <alv_data>
            iv_related_node = ''
          CHANGING
            cv_key          = lv_carrid_key
        ).
      ENDAT.

      AT NEW connid.
        add_connid_line(
          EXPORTING
            is_data         = <alv_data>
            iv_related_node = lv_carrid_key
          CHANGING
            cv_key          = lv_connid_key
        ).
      ENDAT.

      add_complete_line(
        EXPORTING
          is_data         = <alv_data>
          iv_related_node = lv_connid_key
        CHANGING
          cv_key          = lv_last_key
      ).

    ENDLOOP.

  ENDMETHOD.


  METHOD add_carrid_line.
    DATA: nodes TYPE REF TO cl_salv_nodes,
          node  TYPE REF TO cl_salv_node,
          text  TYPE lvc_value,
          item  TYPE REF TO cl_salv_item.

    nodes = o_tree->get_nodes( ).

    TRY.
        node = nodes->add_node( related_node = iv_related_node
                                relationship = cl_gui_column_tree=>relat_last_child ).
        "give node name
        SELECT SINGLE carrname FROM scarr WHERE carrid = @is_data-carrid INTO @DATA(carrname).
        text = carrname.
        node->set_text( text ).

        "set node data
        node->set_data_row( is_data ).
        "set link
        item = node->get_hierarchy_item( ).
        item->set_type( if_salv_c_item_type=>link ).


        cv_key = node->get_key( ).
      CATCH cx_salv_msg.
    ENDTRY.
  ENDMETHOD.


  METHOD add_connid_line.

    DATA: nodes TYPE REF TO cl_salv_nodes,
          node  TYPE REF TO cl_salv_node,
          text  TYPE lvc_value.

    nodes = o_tree->get_nodes( ).

    TRY.
        node = nodes->add_node( related_node = iv_related_node
                                relationship = cl_gui_column_tree=>relat_last_child ).

*   set the connid as text for this node
        text = is_data-connid.
        node->set_text( text ).

        node->set_data_row( is_data ).

        cv_key = node->get_key( ).
      CATCH cx_salv_msg.
    ENDTRY.

  ENDMETHOD.


  METHOD add_complete_line.

    DATA: nodes TYPE REF TO cl_salv_nodes,
          node  TYPE REF TO cl_salv_node,
          text  TYPE lvc_value.

    nodes = o_tree->get_nodes( ).

    TRY.
        node = nodes->add_node( related_node = iv_related_node
                            data_row     = is_data
*                            text         = 'text'
                            relationship = cl_gui_column_tree=>relat_last_child ).

        text = is_data-connid.
        node->set_text( text ).

        cv_key = node->get_key( ).
      CATCH cx_salv_msg.
    ENDTRY.

  ENDMETHOD.


  METHOD build_columns.
    DATA: lo_columns TYPE REF TO cl_salv_columns,
          lo_column  TYPE REF TO cl_salv_column.
    DATA: lo_aggregations TYPE REF TO cl_salv_aggregations.

    lo_columns = o_tree->get_columns( ).

    lo_columns->set_optimize( abap_true ).

    lo_columns->set_column_position( columnname = 'PRICE'
                                     position   = 1 ).
* change a column's alignment
    TRY.
        lo_column ?= lo_columns->get_column( 'CURRENCY' ).
        lo_column->set_alignment( if_salv_c_alignment=>right ).
      CATCH cx_salv_not_found.                          "#EC NO_HANDLER
    ENDTRY.

    TRY.
        lo_column = lo_columns->get_column( 'MANDT' ).
        lo_column->set_technical( ).
        lo_column ?= lo_columns->get_column( 'CARRID' ).
        lo_column->set_visible( abap_false ).

        lo_column ?= lo_columns->get_column( 'CONNID' ).
        lo_column->set_visible( abap_false ).

      CATCH cx_salv_not_found.                          "#EC NO_HANDLER
    ENDTRY.

    lo_aggregations = o_tree->get_aggregations( ).

    lo_aggregations->clear( ).

    TRY.
        lo_aggregations->add_aggregation( columnname  = 'FLTIME' ).  "sum total
        lo_aggregations->add_aggregation( columnname  = 'DISTANCE'
                                          aggregation = if_salv_c_aggregation=>maximum ).
      CATCH cx_salv_not_found cx_salv_data_error cx_salv_existing. "#EC NO_HANDLER
    ENDTRY.

  ENDMETHOD.


  METHOD on_after_user_command.
    show_function_info(
      EXPORTING
        i_function = e_salv_function
        i_text     = 'On after user command'
    ).

  ENDMETHOD.


  METHOD on_before_user_command.
    show_function_info(
      EXPORTING
        i_function = e_salv_function
        i_text     = 'On before user command'
    ).

  ENDMETHOD.


  METHOD on_user_command.
    show_function_info(
      EXPORTING
        i_function = e_salv_function
        i_text     = 'On user command'
    ).
  ENDMETHOD.

  METHOD on_double_click.
    DATA(nodes) = o_tree->get_nodes( ).
    TRY.
        DATA(node) = nodes->get_node( node_key = node_key ).
        DATA(selected_line_data) = node->get_data_row( ).
      CATCH cx_salv_msg.
    ENDTRY.
    show_event_info( EXPORTING i_node_key = node_key
                     i_columnname = columnname i_text = 'Double Click' ).

  ENDMETHOD.

  METHOD on_keypress.
    show_event_info( EXPORTING i_node_key = node_key
                     i_columnname = columnname i_text = 'Key press' ).
  ENDMETHOD.

  METHOD on_link_click.
    DATA: key TYPE salv_de_node_key.

    show_event_info( EXPORTING i_node_key = key
                     i_columnname = columnname i_text = 'Link click' ).
  ENDMETHOD.


  METHOD show_event_info.

    DATA: l_string TYPE string.

* double click on node: i_colname is initial./node selection!
    IF i_columnname IS INITIAL.
      i_columnname = '&Hierarchy'.
    ENDIF.

    CONCATENATE TEXT-g01 i_node_key TEXT-g02 i_columnname INTO l_string SEPARATED BY space.

    MESSAGE i000(0k) WITH i_text l_string.

  ENDMETHOD.

  METHOD show_function_info.
    DATA: l_string TYPE string.

    CONCATENATE i_text i_function INTO l_string SEPARATED BY space.

    MESSAGE i000(0k) WITH l_string.
  ENDMETHOD.

ENDCLASS.




START-OF-SELECTION.
  DATA(main) = NEW lcl_main( ).
  main->run( ).