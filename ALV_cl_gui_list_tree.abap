*&---------------------------------------------------------------------*
*& Report zoz_alvtree
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoz_alvtree.

CLASS lcl_alvtree DEFINITION DEFERRED.
CLASS cl_gui_cfw DEFINITION LOAD.

* CAUTION: MTREEITM is the name of the item structure which must
* be defined by the programmer. DO NOT USE MTREEITM!
TYPES: item_table_type LIKE STANDARD TABLE OF mtreeitm
       WITH DEFAULT KEY.

DATA: g_alv              TYPE REF TO lcl_alvtree,
      g_custom_container TYPE REF TO cl_gui_custom_container,
      g_tree             TYPE REF TO cl_gui_list_tree,
      g_ok_code          TYPE sy-ucomm.

* Fields on Dynpro 100
DATA: g_event(30),
      g_node_key  TYPE tv_nodekey,
      g_item_name TYPE tv_itmname.


CONSTANTS:
  BEGIN OF c_nodekey,
    root   TYPE tv_nodekey VALUE 'Root',                    "#EC NOTEXT
    child1 TYPE tv_nodekey VALUE 'Child1',                  "#EC NOTEXT
    child2 TYPE tv_nodekey VALUE 'Child2',                  "#EC NOTEXT
    new1   TYPE tv_nodekey VALUE 'New1',                    "#EC NOTEXT
    new2   TYPE tv_nodekey VALUE 'New2',                    "#EC NOTEXT
    new3   TYPE tv_nodekey VALUE 'New3',                    "#EC NOTEXT
    new4   TYPE tv_nodekey VALUE 'New4',                    "#EC NOTEXT
  END OF c_nodekey.


INCLUDE zoz_alvtree_status_o01.

INCLUDE zoz_alvtree_user_command_i01.


CLASS lcl_alvtree DEFINITION.

  PUBLIC SECTION.
    METHODS:
      handle_node_double_click
      FOR EVENT node_double_click
                    OF cl_gui_list_tree
        IMPORTING node_key,

      handle_expand_no_children
      FOR EVENT expand_no_children
                    OF cl_gui_list_tree
        IMPORTING node_key,

      handle_item_double_click
      FOR EVENT item_double_click
                    OF cl_gui_list_tree
        IMPORTING node_key item_name,

      handle_button_click
      FOR EVENT button_click
                    OF cl_gui_list_tree
        IMPORTING node_key item_name,

      handle_link_click
      FOR EVENT link_click
                    OF cl_gui_list_tree
        IMPORTING node_key item_name,

      handle_checkbox_change
      FOR EVENT checkbox_change
                    OF cl_gui_list_tree
        IMPORTING node_key item_name checked.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_alvtree IMPLEMENTATION.

  METHOD handle_button_click.
    " this method handles the button click event of the tree
    g_event = 'BUTTON_CLICK'.
    g_node_key = node_key.
    g_item_name = item_name.
    MESSAGE g_event TYPE 'S'.
  ENDMETHOD.

  METHOD handle_checkbox_change.
    " this method handles the checkbox_change event of the tree
    g_event = 'CHECKBOX_CHANGE'.
    g_node_key = node_key.
    g_item_name = item_name.
    MESSAGE g_event TYPE 'S'.
  ENDMETHOD.

  METHOD handle_expand_no_children.
    DATA: node_table TYPE treev_ntab,
          node       TYPE treev_node,
          item_table TYPE item_table_type,
          item       TYPE mtreeitm.

* show the key of the expanded node in a dynpro field
    g_event = 'EXPAND_NO_CHILDREN'.
    g_node_key = node_key.
    MESSAGE g_event TYPE 'S'.
    IF node_key = c_nodekey-child2.
* add the children for node with key 'Child2'
* Node with key 'New3'
      CLEAR node.
      node-node_key = c_nodekey-new3.
      node-relatkey = c_nodekey-child2.
      node-relatship = cl_gui_list_tree=>relat_last_child.
      APPEND node TO node_table.

* Node with key 'New4'
      CLEAR node.
      node-node_key = c_nodekey-new4.
      node-relatkey = c_nodekey-child2.
      node-relatship = cl_gui_list_tree=>relat_last_child.
      APPEND node TO node_table.

* Items of node with key 'New3'
      CLEAR item.
      item-node_key = c_nodekey-new3.
      item-item_name = '1'.
      item-class = cl_gui_list_tree=>item_class_text.
      item-length = 11.
      item-usebgcolor = 'X'. "
      item-text = 'SAPTROX1'.
      APPEND item TO item_table.

      CLEAR item.
      item-node_key = c_nodekey-new3.
      item-item_name = '2'.
      item-class = cl_gui_list_tree=>item_class_text.
      item-alignment = cl_gui_list_tree=>align_auto.
      item-font = cl_gui_list_tree=>item_font_prop.
      item-text = 'Kommentar zu SAPTROX1'(001).
      APPEND item TO item_table.

* Items of node with key 'New4'
      CLEAR item.
      item-node_key = c_nodekey-new4.
      item-item_name = '1'.
      item-class = cl_gui_list_tree=>item_class_text.
      item-length = 11.
      item-usebgcolor = 'X'. "
      item-text = 'SAPTRIXTROX'.
      APPEND item TO item_table.

      CLEAR item.
      item-node_key = c_nodekey-new4.
      item-item_name = '2'.
      item-class = cl_gui_list_tree=>item_class_text.
      item-alignment = cl_gui_list_tree=>align_auto.
      item-font = cl_gui_list_tree=>item_font_prop.
      item-text = 'Kommentar zu SAPTRIXTROX'(002).
      APPEND item TO item_table.
    ENDIF.

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
    IF sy-subrc <> 0.
      MESSAGE 'Düğümler Eklenirken Hata' TYPE 'W'.
    ENDIF.
  ENDMETHOD.

  METHOD handle_item_double_click.
    " this method handles the item double click event of the tree
    g_event = 'ITEM_DOUBLE_CLICK'.
    g_node_key = node_key.
    g_item_name = item_name.
    MESSAGE g_event TYPE 'S'.
  ENDMETHOD.

  METHOD handle_link_click.
    " this method handles the link click event of the tree
    g_event = 'LINK_CLICK'.
    g_node_key = node_key.
    g_item_name = item_name.
    MESSAGE g_event TYPE 'S'.
  ENDMETHOD.

  METHOD handle_node_double_click.
    " this method handles the node double click event of the tree
    g_event = 'NODE_DOUBLE_CLICK'.
    g_node_key = node_key.
    CLEAR g_item_name.
    MESSAGE g_event TYPE 'S'.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  CREATE OBJECT g_alv.

  SET SCREEN 0100.

*&---------------------------------------------------------------------*
*&      Form  CREATE_AND_INIT_TREE
*&---------------------------------------------------------------------*
FORM create_and_init_tree.
  DATA: node_table TYPE treev_ntab,
        item_table TYPE item_table_type,
        events     TYPE cntl_simple_events,
        event      TYPE cntl_simple_event.

* create a container for the tree control
  CREATE OBJECT g_custom_container
    EXPORTING      " the container is linked to the custom control with the
      " name 'TREE_CONTAINER' on the dynpro
      container_name              = 'TREE_CONTAINER'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc <> 0.
    MESSAGE 'Hata' TYPE 'W'.
  ENDIF.
* create a list tree
  CREATE OBJECT g_tree
    EXPORTING
      parent                      = g_custom_container
      node_selection_mode         = cl_gui_list_tree=>node_sel_mode_single
      item_selection              = 'X'
      with_headers                = ' '
    EXCEPTIONS
      cntl_system_error           = 1
      create_error                = 2
      failed                      = 3
      illegal_node_selection_mode = 4
      lifetime_error              = 5.
  IF sy-subrc <> 0.
    MESSAGE 'Hata' TYPE 'W'.
  ENDIF.

* define the events which will be passed to the backend
  " node double click
  event-eventid = cl_gui_list_tree=>eventid_node_double_click.
  event-appl_event = 'X'.                                   "
  APPEND event TO events.

  " item double click
  event-eventid = cl_gui_list_tree=>eventid_item_double_click.
  event-appl_event = 'X'.
  APPEND event TO events.

  " expand no children
  event-eventid = cl_gui_list_tree=>eventid_expand_no_children.
  event-appl_event = 'X'.
  APPEND event TO events.

  " link click
  event-eventid = cl_gui_list_tree=>eventid_link_click.
  event-appl_event = 'X'.
  APPEND event TO events.

  " button click
  event-eventid = cl_gui_list_tree=>eventid_button_click.
  event-appl_event = 'X'.
  APPEND event TO events.

  " checkbox change
  event-eventid = cl_gui_list_tree=>eventid_checkbox_change.
  event-appl_event = 'X'.
  APPEND event TO events.

  CALL METHOD g_tree->set_registered_events
    EXPORTING
      events                    = events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.
  IF sy-subrc <> 0.
    MESSAGE 'Hata' TYPE 'W'.
  ENDIF.

* assign event handlers in the application class to each desired event
  SET HANDLER g_alv->handle_node_double_click FOR g_tree.
  SET HANDLER g_alv->handle_item_double_click FOR g_tree.
  SET HANDLER g_alv->handle_expand_no_children FOR g_tree.
  SET HANDLER g_alv->handle_link_click FOR g_tree.
  SET HANDLER g_alv->handle_button_click FOR g_tree.
  SET HANDLER g_alv->handle_checkbox_change FOR g_tree.

* add some nodes to the tree control
* NOTE: the tree control does not store data at the backend. If an
* application wants to access tree data later, it must store the
* tree data itself.

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
  IF sy-subrc <> 0.
    MESSAGE 'Hata' TYPE 'W'.
  ENDIF.
ENDFORM.                    " CREATE_AND_INIT_TREE

*&---------------------------------------------------------------------*
*&      Form  BUILD_NODE_AND_ITEM_TABLE
*&---------------------------------------------------------------------*
FORM build_node_and_item_table USING node_table TYPE treev_ntab
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
  CLEAR node-relatship.                " node.

  node-hidden = ' '.                   " The node is visible,
  node-disabled = ' '.                 " selectable,
  node-isfolder = 'X'.                 " a folder.
  CLEAR node-n_image.       " Folder-/ Leaf-Symbol in state "closed":
  " use default.
  CLEAR node-exp_image.     " Folder-/ Leaf-Symbol in state "open":
  " use default
  CLEAR node-expander.                 " see below.
  " the width of the item is adjusted to its content (text)
  APPEND node TO node_table.

* Node with key 'Child1'
  CLEAR node.
  node-node_key = c_nodekey-child1.
  " Key of the node
  " Node is inserted as child of the node with key 'Root'.
  node-relatkey = c_nodekey-root.
  node-relatship = cl_gui_list_tree=>relat_last_child.
  node-isfolder = 'X'.
  APPEND node TO node_table.

* Node with key 'New1'
  CLEAR node.
  node-node_key = c_nodekey-new1.
  node-relatkey = c_nodekey-child1.
  node-relatship = cl_gui_list_tree=>relat_last_child.
  APPEND node TO node_table.

* Node with key 'New2'
  CLEAR node.
  node-node_key = c_nodekey-new2.
  node-relatkey = c_nodekey-child1.
  node-relatship = cl_gui_list_tree=>relat_last_child.
  APPEND node TO node_table.


* Node with key 'Child2'
  CLEAR node.
  node-node_key = c_nodekey-child2.
  node-relatkey = c_nodekey-root.
  node-relatship = cl_gui_list_tree=>relat_last_child.
  node-isfolder = 'X'.
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
  item-item_name = '1'.                " Item with name '1'
  item-class = cl_gui_list_tree=>item_class_text. " Text Item
  " the with of the item is adjusted to its content (text)
  item-alignment = cl_gui_list_tree=>align_auto.
  " use proportional font for the item
  item-font = cl_gui_list_tree=>item_font_prop.
  item-text = 'Objekte'(003).
  APPEND item TO item_table.


* Node with key 'Child1'
  CLEAR item.
  item-node_key = c_nodekey-child1.
  item-item_name = '1'.
  item-class = cl_gui_list_tree=>item_class_text.
  item-alignment = cl_gui_list_tree=>align_auto.
  item-font = cl_gui_list_tree=>item_font_prop.
  item-text = 'Dynpros'(004).
  APPEND item TO item_table.

* Node with key 'Child2'
  CLEAR item.
  item-node_key = c_nodekey-child2.
  item-item_name = '1'.
  item-class = cl_gui_list_tree=>item_class_text.
  item-alignment = cl_gui_list_tree=>align_auto.
  item-font = cl_gui_list_tree=>item_font_prop.
  item-text = 'Programme'(005).
  APPEND item TO item_table.

* Items of node with key 'New1'
  CLEAR item.
  item-node_key = c_nodekey-new1.
  item-item_name = '1'.
  item-class = cl_gui_list_tree=>item_class_text.
  item-length = 4. " the width of the item is 4 characters
  item-ignoreimag = 'X'.               " see documentation of Structure
  " TREEV_ITEM
  item-usebgcolor = 'X'.               " item has light grey background
  item-t_image = '@01@'.               " icon of the item
  APPEND item TO item_table.

  CLEAR item.
  item-node_key = c_nodekey-new1.
  item-item_name = '2'.
  item-class = cl_gui_list_tree=>item_class_text.
  item-length = 4.
  item-usebgcolor = 'X'.
  item-text = '0100'.
  APPEND item TO item_table.

  CLEAR item.
  item-node_key = c_nodekey-new1.
  item-item_name = '3'.
  item-class = cl_gui_list_tree=>item_class_text.
  item-length = 11.
  item-usebgcolor = 'X'.                                    "
  item-text = 'MUELLER'.
  APPEND item TO item_table.

  CLEAR item.
  item-node_key = c_nodekey-new1.
  item-item_name = '4'.
  item-class = cl_gui_list_tree=>item_class_text.
  item-alignment = cl_gui_list_tree=>align_auto.
  item-font = cl_gui_list_tree=>item_font_prop.
  item-text = 'Kommentar zu Dynpro 100'(006).
  APPEND item TO item_table.

* Items of node with key 'New2'
  CLEAR item.
  item-node_key = c_nodekey-new2.
  item-item_name = '1'.
  item-class = cl_gui_list_tree=>item_class_text.
  item-length = 4. " the width of the item is 2 characters
  item-ignoreimag = 'X'.               " see documentation of Structure
  " TREEV_ITEM
  item-usebgcolor = 'X'.               " item has light grey background
  item-t_image = '@02@'.               " icon of the item
  APPEND item TO item_table.

  CLEAR item.
  item-node_key = c_nodekey-new2.
  item-item_name = '2'.
  item-class = cl_gui_list_tree=>item_class_text.
  item-length = 4.
  item-usebgcolor = 'X'.
  item-text = '0200'.
  APPEND item TO item_table.

  CLEAR item.
  item-node_key = c_nodekey-new2.
  item-item_name = '3'.
  item-class = cl_gui_list_tree=>item_class_text.
  item-length = 11.
  item-usebgcolor = 'X'.                                    "
  item-text = 'HARRYHIRSCH'.
  APPEND item TO item_table.

  CLEAR item.
  item-node_key = c_nodekey-new2.
  item-item_name = '4'.
  item-class = cl_gui_list_tree=>item_class_text.
  item-alignment = cl_gui_list_tree=>align_auto.
  item-font = cl_gui_list_tree=>item_font_prop.
  item-text = 'Kommentar zu Dynpro 200'(007).
  APPEND item TO item_table.
ENDFORM.                    " BUILD_NODE_AND_ITEM_TABLE