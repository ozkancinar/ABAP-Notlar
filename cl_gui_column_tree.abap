*&---------------------------------------------------------------------*
*&  Include           ZOZ_ALV_COLUMN_TREE_TOP
*&---------------------------------------------------------------------*
CLASS lcl_alvtree DEFINITION DEFERRED.
 CLASS cl_gui_cfw DEFINITION LOAD.

* CAUTION: MTREEITM is the name of the item structure which must
* be defined by the programmer. DO NOT USE MTREEITM!
 TYPES: item_table_type LIKE STANDARD TABLE OF mtreeitm
        WITH DEFAULT KEY.

 DATA: g_alv              TYPE REF TO lcl_alvtree,
       g_custom_container TYPE REF TO cl_gui_custom_container,
       g_tree             TYPE REF TO cl_gui_column_tree,
       gt_fcat TYPE lvc_t_fcat,  " Field Catalog
       g_ok_code              TYPE sy-ucomm.

* Fields on Dynpro 100
 DATA: g_event(30),
       g_node_key    TYPE tv_nodekey,
       g_item_name   TYPE tv_itmname,
       g_header_name TYPE tv_hdrname.

 data: gt_data TYPE TABLE OF sflight,
       gt_sort         TYPE lvc_t_sort.         " Sorting Table

 CONSTANTS:
   BEGIN OF c_nodekey,
     root   TYPE tv_nodekey VALUE 'Root',                   "#EC NOTEXT
     child1 TYPE tv_nodekey VALUE 'Child1',                 "#EC NOTEXT
*    child2 type tv_nodekey value 'Child2',                  "#EC NOTEXT
     new1   TYPE tv_nodekey VALUE 'New1',                   "#EC NOTEXT
     new2   TYPE tv_nodekey VALUE 'New2',                   "#EC NOTEXT
*    new3   type tv_nodekey value 'New3',                    "#EC NOTEXT
*    new4   type tv_nodekey value 'New4',                    "#EC NOTEXT
   END OF c_nodekey,
   BEGIN OF c_column,
     column1 TYPE tv_itmname VALUE 'Column1',               "#EC NOTEXT
     column2 TYPE tv_itmname VALUE 'Column2',               "#EC NOTEXT
     column3 TYPE tv_itmname VALUE 'Column3',               "#EC NOTEXT
   END OF c_column.

*&---------------------------------------------------------------------*
*&  Include           ZOZ_ALV_COLUMN_TREE_CL01
*&---------------------------------------------------------------------*
CLASS lcl_alvtree DEFINITION.

  PUBLIC SECTION.
    METHODS:
      handle_node_double_click
      FOR EVENT node_double_click
                    OF cl_gui_column_tree
        IMPORTING node_key,

      handle_header_click
      FOR EVENT header_click
                    OF cl_gui_column_tree
        IMPORTING header_name,

      handle_expand_no_children
      FOR EVENT expand_no_children
                    OF cl_gui_column_tree
        IMPORTING node_key,

      handle_item_double_click
      FOR EVENT item_double_click
                    OF cl_gui_column_tree
        IMPORTING node_key item_name,

      handle_button_click
      FOR EVENT button_click
                    OF cl_gui_column_tree
        IMPORTING node_key item_name,

      handle_link_click
      FOR EVENT link_click
                    OF cl_gui_column_tree
        IMPORTING node_key item_name,

      handle_checkbox_change
      FOR EVENT checkbox_change
                    OF cl_gui_column_tree
        IMPORTING node_key item_name checked.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_alvtree IMPLEMENTATION.

  METHOD handle_button_click.
    " this method handles the button click event of the tree
    G_EVENT = 'BUTTON_CLICK'.
    G_NODE_KEY = NODE_KEY.
    G_ITEM_NAME = ITEM_NAME.
    CLEAR G_HEADER_NAME.
  ENDMETHOD.

  METHOD handle_checkbox_change.
    " this method handles the checkbox_change event of the tree
    G_EVENT = 'CHECKBOX_CHANGE'.
    G_NODE_KEY = NODE_KEY.
    G_ITEM_NAME = ITEM_NAME.
    CLEAR  G_HEADER_NAME.
  ENDMETHOD.

  METHOD handle_header_click.
    " this method handles header click event of the tree
    g_event = 'HEADER_CLICK'.
    g_header_name = header_name.
    CLEAR: g_node_key, g_item_name.
  ENDMETHOD.

  METHOD handle_item_double_click.
    " this method handles the item double click event of the tree
    g_event = 'ITEM_DOUBLE_CLICK'.
    g_node_key = node_key.
    g_item_name = item_name.
    CLEAR g_header_name.
  ENDMETHOD.

  METHOD handle_link_click.
    " this method handles the link click event of the tree
    g_event = 'LINK_CLICK'.
    g_node_key = node_key.
    g_item_name = item_name.
    CLEAR g_header_name.
  ENDMETHOD.

  METHOD handle_node_double_click.
    " this method handles the node double click event of the tree
    g_event = 'NODE_DOUBLE_CLICK'.
    g_node_key = node_key.
    CLEAR: g_item_name, g_header_name.
    MESSAGE g_event TYPE 'S'.
  ENDMETHOD.

    METHOD handle_expand_no_children.
      DATA: NODE_TABLE TYPE TREEV_NTAB,
          NODE TYPE TREEV_NODE,
          ITEM_TABLE TYPE ITEM_TABLE_TYPE,
          ITEM TYPE MTREEITM.

* show the key of the expanded node in a dynpro field
    G_EVENT = 'EXPAND_NO_CHILDREN'.
    G_NODE_KEY = NODE_KEY.
    CLEAR: G_ITEM_NAME, G_HEADER_NAME.

    IF node_key = c_nodekey-child1.
* add two nodes

* Node with key 'New1'
      CLEAR NODE.
      node-node_key = c_nodekey-New1.
      node-relatkey = c_nodekey-child1.
      NODE-RELATSHIP = CL_GUI_COLUMN_TREE=>RELAT_LAST_CHILD.
      APPEND NODE TO NODE_TABLE.

* Node with key 'New2'
      CLEAR NODE.
      node-node_key = c_nodekey-New2.
      node-relatkey = c_nodekey-child1.
      NODE-RELATSHIP = CL_GUI_COLUMN_TREE=>RELAT_LAST_CHILD.
      NODE-N_IMAGE = '@10@'.
      APPEND NODE TO NODE_TABLE.

* Items of node with key 'New1'
      CLEAR ITEM.
      item-node_key = c_nodekey-New1.
      item-item_name = c_column-Column1.
      item-class = cl_gui_column_tree=>item_class_text.
      item-text = 'New1 Col. 1'(n11).
      APPEND ITEM TO ITEM_TABLE.

      CLEAR ITEM.
      item-node_key = c_nodekey-New1.
      item-item_name = c_column-Column2.
      ITEM-CLASS = CL_GUI_COLUMN_TREE=>ITEM_CLASS_LINK.
      item-t_image = '@3C@'.
      APPEND ITEM TO ITEM_TABLE.

      CLEAR ITEM.
      item-node_key = c_nodekey-New1.
      item-item_name = c_column-Column3.
      item-class = cl_gui_column_tree=>item_class_text.
      item-text = 'New1 Col. 3'(n13).
      APPEND ITEM TO ITEM_TABLE.

* Items of node with key 'New2'
      CLEAR ITEM.
      item-node_key = c_nodekey-New2.
      item-item_name = c_column-Column1.
      item-class = cl_gui_column_tree=>item_class_text.
      item-text = 'New2 Col. 1'(n21).
      APPEND ITEM TO ITEM_TABLE.

      CLEAR ITEM.
      item-node_key = c_nodekey-New2.
      item-item_name = c_column-Column2.
      item-class = cl_gui_column_tree=>item_class_text.
      item-text = 'New2 Col. 2'(n22).
      APPEND ITEM TO ITEM_TABLE.

      CLEAR ITEM.
      item-node_key = c_nodekey-New2.
      item-item_name = c_column-Column3.
      item-class = cl_gui_column_tree=>item_class_text.
      item-text = 'New2 Col. 3'(n23).
      APPEND ITEM TO ITEM_TABLE.


      CALL METHOD g_tree->ADD_NODES_AND_ITEMS
        EXPORTING
          NODE_TABLE = NODE_TABLE
          ITEM_TABLE = ITEM_TABLE
          ITEM_TABLE_STRUCTURE_NAME = 'MTREEITM'
        EXCEPTIONS
          FAILED = 1
          CNTL_SYSTEM_ERROR = 3
          ERROR_IN_TABLES = 4
          DP_ERROR = 5
          TABLE_STRUCTURE_NAME_NOT_FOUND = 6.
      IF SY-SUBRC <> 0.
        MESSAGE 'HATA' TYPE 'E'.
      ENDIF.
    endif.
  ENDMETHOD.
ENDCLASS.

  START-OF-SELECTION.
* create the application object
* this object is needed to handle the ABAP Objects Events of
* Controls
  CREATE OBJECT g_alv.

  SET SCREEN 100.

  MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.
*  SET TITLEBAR 'xxx'.
  IF G_TREE IS INITIAL.
    " The Tree Control has not been created yet.
    " Create a Tree Control and insert nodes into it.
    PERFORM CREATE_AND_INIT_TREE.
  ENDIF.
ENDMODULE.

MODULE user_command_0100 INPUT.
    data: return_code type i.
* CL_GUI_CFW=>DISPATCH must be called if events are registered
* that trigger PAI
* this method calls the event handler method of an event
  CALL METHOD CL_GUI_CFW=>DISPATCH
    importing return_code = return_code.
  if return_code <> cl_gui_cfw=>rc_noevent.
    " a control event occured => exit PAI
    clear g_ok_code.
    exit.
  endif.

  CASE G_OK_CODE.
    WHEN 'BACK' or 'EXIT' or 'CANCEL'. " Finish program
      IF NOT G_CUSTOM_CONTAINER IS INITIAL.
        " destroy tree container (detroys contained tree control, too)
        CALL METHOD G_CUSTOM_CONTAINER->FREE
          EXCEPTIONS
            CNTL_SYSTEM_ERROR = 1
            CNTL_ERROR        = 2.
        IF SY-SUBRC <> 0.
          MESSAGE 'hata' TYPE 'E'.
        ENDIF.
        CLEAR G_CUSTOM_CONTAINER.
        CLEAR G_TREE.
      ENDIF.
      LEAVE PROGRAM.
  ENDCASE.

* CAUTION: clear ok code!
  CLEAR G_OK_CODE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&  Include           ZOZ_ALV_COLUMN_TREE_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CREATE_AND_INIT_TREE
*&---------------------------------------------------------------------*
FORM create_and_init_tree.
  DATA: node_table       TYPE treev_ntab,
        item_table       TYPE item_table_type,
        event            TYPE cntl_simple_event,
        events           TYPE cntl_simple_events,
        hierarchy_header TYPE treev_hhdr.

  PERFORM get_data.
  PERFORM build_fcat.


  CREATE OBJECT g_custom_container
    EXPORTING
      container_name              = 'TREE_CONTAINER' "Screen painterdaki containerÄ±n adÄ±
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.

  "*-------------HiyerarÅŸi BaÅŸlÄ±ÄŸÄ±---------------------*
  hierarchy_header-heading = 'HiyerarÅŸi BaÅŸlÄ±ÄŸÄ±'.
  hierarchy_header-width = 30.

  "*-------------ALV OluÅŸtur---------------------*
  CREATE OBJECT g_tree
    EXPORTING
      parent                      = g_custom_container
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
      item_selection              = 'X'
      hierarchy_column_name       = c_column-column1
      hierarchy_header            = hierarchy_header
    EXCEPTIONS
      cntl_system_error           = 1
      create_error                = 2
      failed                      = 3
      illegal_node_selection_mode = 4
      illegal_column_name         = 5
      lifetime_error              = 6.

  "*-------------Event AtamalarÄ±---------------------*
  event-eventid = cl_gui_column_tree=>eventid_node_double_click.
  event-appl_event = 'X'.
  APPEND event TO events.
  event-eventid = cl_gui_column_tree=>eventid_item_double_click.
  event-appl_event = 'X'.
  APPEND event TO events.
  event-eventid = cl_gui_column_tree=>eventid_expand_no_children.
  event-appl_event = 'X'.
  APPEND event TO events.
  event-eventid = cl_gui_column_tree=>eventid_link_click.
  event-appl_event = 'X'.
  APPEND event TO events.
  event-eventid = cl_gui_column_tree=>eventid_button_click.
  event-appl_event = 'X'.
  APPEND event TO events.
  event-eventid = cl_gui_column_tree=>eventid_checkbox_change.
  event-appl_event = 'X'.
  APPEND event TO events.
  event-eventid = cl_gui_column_tree=>eventid_header_click.
  event-appl_event = 'X'.
  APPEND event TO events.

  CALL METHOD g_tree->set_registered_events
    EXPORTING
      events                    = events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.

  SET HANDLER g_alv->handle_node_double_click FOR g_tree.
  SET HANDLER g_alv->handle_item_double_click FOR g_tree.
  SET HANDLER g_alv->handle_expand_no_children FOR g_tree.
  SET HANDLER g_alv->handle_link_click FOR g_tree.
  SET HANDLER g_alv->handle_button_click FOR g_tree.
  SET HANDLER g_alv->handle_checkbox_change FOR g_tree.
  SET HANDLER g_alv->handle_header_click FOR g_tree.


  "*-------------SÃ¼tun Ekle---------------------*
  " 2 yeni sÃ¼tun ekle

* Column2
  CALL METHOD g_tree->add_column
    EXPORTING
      name                         = c_column-column2
      width                        = 21
      header_text                  = 'Column2'(co2)
    EXCEPTIONS
      column_exists                = 1
      illegal_column_name          = 2
      too_many_columns             = 3
      illegal_alignment            = 4
      different_column_types       = 5
      cntl_system_error            = 6
      failed                       = 7
      predecessor_column_not_found = 8.
  IF sy-subrc <> 0.
    MESSAGE 'Hata' TYPE 'E'.
  ENDIF.
* Column3
  CALL METHOD g_tree->add_column
    EXPORTING
      name                         = c_column-column3
      width                        = 21
      alignment                    = cl_gui_column_tree=>align_right
      header_text                  = 'Column3'(co3)
    EXCEPTIONS
      column_exists                = 1
      illegal_column_name          = 2
      too_many_columns             = 3
      illegal_alignment            = 4
      different_column_types       = 5
      cntl_system_error            = 6
      failed                       = 7
      predecessor_column_not_found = 8.
  IF sy-subrc <> 0.
    MESSAGE 'Hata' TYPE 'E'.
  ENDIF.

  PERFORM build_node_and_item_table USING node_table item_table.

  CALL METHOD g_tree->add_nodes_and_items
    EXPORTING
      node_table                     = node_table
      item_table                     = item_table
      item_table_structure_name      = 'MTREEITM'
    EXCEPTIONS
      failed                         = 1
      cntl_system_error              = 3
      error_in_tables                = 4
      dp_error                       = 5
      table_structure_name_not_found = 6.

  CALL METHOD g_tree->expand_node
    EXPORTING
      node_key            = c_nodekey-root
    EXCEPTIONS
      failed              = 1
      illegal_level_count = 2
      cntl_system_error   = 3
      node_not_found      = 4
      cannot_expand_leaf  = 5.
ENDFORM.                    " CREATE_AND_INIT_TREE

*&---------------------------------------------------------------------*
*&      Form  build_node_and_item_table
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM build_node_and_item_table
  USING
    node_table TYPE treev_ntab
    item_table TYPE item_table_type.

  DATA: node TYPE treev_node,
        item TYPE mtreeitm.

* Build the node table.

* Caution: The nodes are inserted into the tree according to the order
* in which they occur in the table. In consequence, a node must not
* must not occur in the node table before its parent node.

* Node with key 'Root'
  node-node_key = c_nodekey-root.
  " Key of the node
  CLEAR node-relatkey.      " Special case: A root node has no parent
  CLEAR node-relatship.     " node.

  node-hidden = ' '.        " The node is visible,
  node-disabled = ' '.      " selectable,
  node-isfolder = 'X'.      " a folder.
  CLEAR node-n_image.       " Folder-/ Leaf-Symbol in state "closed":
  " use default.
  CLEAR node-exp_image.     " Folder-/ Leaf-Symbol in state "open":
  " use default
  CLEAR node-expander.      " see below.
  APPEND node TO node_table.

* Node with key 'Child1'
  node-node_key = c_nodekey-child1.
  " Key of the node
  " Node is inserted as child of the node with key 'Root'.
  node-relatkey = c_nodekey-root.
  node-relatship = cl_gui_column_tree=>relat_last_child.

  node-hidden = ' '.
  node-disabled = ' '.
  node-isfolder = 'X'.
  CLEAR node-n_image.
  CLEAR node-exp_image.
  node-expander = 'X'. " The node is marked with a '+', although
  " it has no children. When the user clicks on the
  " + to open the node, the event expand_nc is
  " fired. The programmerr can
  " add the children of the
  " node within the event handler of the expand_nc
  " event  (see callback handle_expand_nc).
  APPEND node TO node_table.

* The items of the nodes:

* Node with key 'Root'
  CLEAR item.
  item-node_key = c_nodekey-root.
  item-item_name = c_column-column1.     " Item of Column 'Column1'
  item-class = cl_gui_column_tree=>item_class_text. " Text Item
  item-text = 'Root Col. 1'(ro1).
  APPEND item TO item_table.

  CLEAR item.
  item-node_key = c_nodekey-root.
  item-item_name = c_column-column2.     " Item of Column 'Column2'
  item-class = cl_gui_column_tree=>item_class_text.
  item-text = 'Root Col. 2'(ro2).
  APPEND item TO item_table.

  CLEAR item.
  item-node_key = c_nodekey-root.
  item-item_name = c_column-column3.     " Item of Column 'Column3'
  " Item is a link (click on link fires event LINK_CLICK)
  item-class = cl_gui_column_tree=>item_class_link.
  item-text = 'Root Col. 3'(ro3).
  APPEND item TO item_table.

* Node with key 'Child1'
  CLEAR item.
  item-node_key = c_nodekey-child1.
  item-item_name = c_column-column1.
  item-class = cl_gui_column_tree=>item_class_text.
  item-text = 'Child1 Col. 1'(c11).
  APPEND item TO item_table.

  CLEAR item.
  item-node_key = c_nodekey-child1.
  item-item_name = c_column-column2.     "
  item-class = cl_gui_column_tree=>item_class_button. " Item is a button
  item-text = 'Child1 Col. 2'(c12).
  item-t_image = '@0B@'.
  APPEND item TO item_table.

  CLEAR item.
  item-node_key = c_nodekey-child1.
  item-item_name = c_column-column3.
  " Item is a checkbox
  item-class = cl_gui_column_tree=>item_class_checkbox.
  item-editable = 'X'.
  item-text = 'Child1 Col. 3'(c13).
  item-t_image = '@0C@'.
  APPEND item TO item_table.

ENDFORM.                    " build_node_and_item_table

*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
FORM get_data.
  SELECT * FROM sflight INTO TABLE gt_data.
ENDFORM.                    " get_data

*&---------------------------------------------------------------------*
*&      Form  build_fcat
*&---------------------------------------------------------------------*
FORM build_fcat.
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      ct_fieldcat      = gt_fcat.

* change fieldcatalog
  LOOP AT gt_fcat INTO DATA(ls_fcat).
    CASE ls_fcat-fieldname.
      WHEN 'CARRID' OR 'CONNID' OR 'FLDATE'.
        ls_fcat-no_out = 'X'.
        ls_fcat-key    = ''.
      WHEN 'PRICE' OR 'SEATSOCC' OR 'SEATSMAX' OR 'PAYMENTSUM'.
        ls_fcat-do_sum = 'X'.
    ENDCASE.
    MODIFY gt_fcat FROM ls_fcat.
  ENDLOOP.
ENDFORM.                    " build_fcat

*&---------------------------------------------------------------------*
*&      Form  build_sort_table
*&---------------------------------------------------------------------*
FORM build_sort_table.
  DATA ls_sort_wa TYPE lvc_s_sort.

* create sort-table
  ls_sort_wa-spos = 1.
  ls_sort_wa-fieldname = 'CARRID'.
  ls_sort_wa-up = 'X'.
  ls_sort_wa-subtot = 'X'.
  APPEND ls_sort_wa TO gt_sort.

  ls_sort_wa-spos = 2.
  ls_sort_wa-fieldname = 'CONNID'.
  ls_sort_wa-up = 'X'.
  ls_sort_wa-subtot = 'X'.
  APPEND ls_sort_wa TO gt_sort.

  ls_sort_wa-spos = 3.
  ls_sort_wa-fieldname = 'FLDATE'.
  ls_sort_wa-up = 'X'.
  APPEND ls_sort_wa TO gt_sort.
ENDFORM.                    " build_sort_table