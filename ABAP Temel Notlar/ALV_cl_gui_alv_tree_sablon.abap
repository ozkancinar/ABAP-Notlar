* init_tree -> build_catalog -> create container -> create tree object -> build_hierarchy_header
* -> build_comment -> set_table_for_first_display -> ağaç yapısını oluştur -> toolbar eventlarını ekle

TYPES: BEGIN OF ty_zmsaa_organization.
    INCLUDE STRUCTURE zmsaa_st_organization .
TYPES: tablename  LIKE dd02d-dbtabname,
       tablename1 LIKE dd02d-dbtabname,
       tablename2 LIKE dd02d-dbtabname.
TYPES: END OF ty_zmsaa_organization.

DATA: gr_custom_container TYPE REF TO cl_gui_custom_container,
      tree1  TYPE REF TO cl_gui_alv_tree,
      toolbar_event_receiver TYPE REF TO lcl_toolbar_event_receiver.
data: gt_fieldcatalog      TYPE lvc_t_fcat.
DATA: gt_zmii_organizasyon TYPE table of ty_zmsaa_organization.

"Event class"
CLASS lcl_toolbar_event_receiver DEFINITION.

  PUBLIC SECTION.
    METHODS: on_function_selected
                  FOR EVENT function_selected OF cl_gui_toolbar
      IMPORTING fcode,

      on_toolbar_dropdown
                    FOR EVENT dropdown_clicked OF cl_gui_toolbar
        IMPORTING fcode
                    posx
                    posy.

ENDCLASS.                    "lcl_toolbar_event_receiver DEFINITION

MODULE pbo OUTPUT.

  SET PF-STATUS 'MAIN100'.
  IF tree1 IS INITIAL.
    PERFORM init_tree.
  ENDIF.
  CALL METHOD cl_gui_cfw=>flush.
ENDMODULE.                             " PBO  OUTPUT


FORM init_tree.

* create fieldcatalog for structure ZMSAA_ST_ORGANIZATION
  PERFORM build_fieldcatalog.

* create container for alv-tree
  DATA: l_tree_container_name(30) TYPE c,
        l_custom_container        TYPE REF TO cl_gui_custom_container.
  l_tree_container_name = 'TREE1'. "Containerın adı"

  IF sy-batch IS INITIAL.
    CREATE OBJECT gr_custom_container
      EXPORTING
        container_name              = l_tree_container_name
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.
    IF sy-subrc <> 0.
      MESSAGE x208(00) WITH 'ERROR'.                        "#EC NOTEXT
    ENDIF.
  ENDIF.

* create tree control
  CREATE OBJECT tree1
    EXPORTING
      parent                      = gr_custom_container
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_multiple
      item_selection              = space
      no_html_header              = 'X'
      no_toolbar                  = ''
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      illegal_node_selection_mode = 5
      failed                      = 6
      illegal_column_name         = 7.
  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

* create Hierarchy-header
  DATA l_hierarchy_header TYPE treev_hhdr.
  PERFORM build_hierarchy_header CHANGING l_hierarchy_header.

* create info-table for html-header
  DATA: lt_list_commentary TYPE slis_t_listheader,
        l_logo             TYPE sdydo_value.
  PERFORM build_comment USING
                 lt_list_commentary
                 l_logo.

* repid for saving variants
  DATA: ls_variant TYPE disvariant.
  ls_variant-report = sy-repid.

* create emty tree-control
  CALL METHOD tree1->set_table_for_first_display
    EXPORTING
      is_hierarchy_header = l_hierarchy_header
      it_list_commentary  = lt_list_commentary
      i_logo              = l_logo
      i_background_id     = 'ALV_BACKGROUND'
      i_save              = 'A'
      is_variant          = ls_variant
    CHANGING
      it_outtab           = gt_zmii_organizasyon "table must be emty !!
      it_fieldcatalog     = gt_fieldcatalog.

* create hierarchy
  PERFORM create_hierarchy.

* add own functioncodes to the toolbar
  PERFORM change_toolbar.

  tree1->column_optimize(
    EXCEPTIONS
      start_column_not_found = 1
      end_column_not_found   = 2
      OTHERS                 = 3 ).
* register events
*  perform register_events.

* adjust column_width
* call method tree1->COLUMN_OPTIMIZE.

ENDFORM.                    " init_tree

FORM build_fieldcatalog.

* get fieldcatalog
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZMSAA_ST_ORGANIZATION'
    CHANGING
      ct_fieldcat      = gt_fieldcatalog.

  SORT gt_fieldcatalog BY scrtext_l.

* change fieldcatalog
  DATA: ls_fieldcatalog TYPE lvc_s_fcat.
*  LOOP AT gt_fieldcatalog INTO ls_fieldcatalog.
*    CASE ls_fieldcatalog-fieldname.
*      WHEN 'WERKS' OR 'CONNID' OR 'FLDATE'.
*        ls_fieldcatalog-no_out = 'X'.
*        ls_fieldcatalog-key    = ''.
*      WHEN 'PRICE' OR 'SEATSOCC' OR 'SEATSMAX' OR 'PAYMENTSUM'.
*        ls_fieldcatalog-do_sum = 'X'.
*    ENDCASE.
*    MODIFY gt_fieldcatalog FROM ls_fieldcatalog.
*  ENDLOOP.
ENDFORM.                               " build_fieldcatalog

FORM build_hierarchy_header CHANGING
                               p_hierarchy_header TYPE treev_hhdr.

  p_hierarchy_header-heading = text-001."'Hierarchy Header'.          "#EC NOTEXT
  p_hierarchy_header-tooltip = text-002. "'This is the Hierarchy Header !'.  "#EC NOTEXT
  p_hierarchy_header-width = 30.
  p_hierarchy_header-width_pix = ''.

ENDFORM.                               " build_hierarchy_header

FORM build_comment USING
      pt_list_commentary TYPE slis_t_listheader
      p_logo             TYPE sdydo_value.

  DATA: ls_line TYPE slis_listheader.
*
* LIST HEADING LINE: TYPE H
  CLEAR ls_line.
  ls_line-typ  = 'H'.
* LS_LINE-KEY:  NOT USED FOR THIS TYPE
  ls_line-info = text-003."'ALV-tree-demo: flight-overview'.          "#EC NOTEXT
  APPEND ls_line TO pt_list_commentary.
* STATUS LINE: TYPE S
  CLEAR ls_line.
  ls_line-typ  = 'S'.
  ls_line-key  = text-004."'valid until'.                             "#EC NOTEXT
  ls_line-info = text-005."'January 29 1999'.                         "#EC NOTEXT
  APPEND ls_line TO pt_list_commentary.
  ls_line-key  = text-006."'time'.
  ls_line-info = text-007."'2.00 pm'.                                 "#EC NOTEXT
  APPEND ls_line TO pt_list_commentary.
* ACTION LINE: TYPE A
  CLEAR ls_line.
  ls_line-typ  = 'A'.
* LS_LINE-KEY:  NOT USED FOR THIS TYPE
  ls_line-info = text-008."'actual data'.                             "#EC NOTEXT
  APPEND ls_line TO pt_list_commentary.

  p_logo = 'ENJOYSAP_LOGO'.
ENDFORM.                    "build_comment

FORM create_hierarchy. "Düğümlerin doldurulduğu form"
  CLEAR gt_available_nodes[].

  DATA: lt_000   LIKE TABLE OF zmsaa_t_arbpl WITH HEADER LINE,
        lt_001   LIKE TABLE OF zmsaa_t_shift WITH HEADER LINE,
        lt_002   LIKE TABLE OF zmsaa_t_group WITH HEADER LINE,
        lt_003   LIKE TABLE OF zmsaa_t_team WITH HEADER LINE,
        lt_004   LIKE TABLE OF zmsaa_t_team_sec WITH HEADER LINE,
        lt_004_1 LIKE TABLE OF zmsaa_t_team_mac WITH HEADER LINE,
        lt_004_2 LIKE TABLE OF zmsaa_t_team_per WITH HEADER LINE.
  CLEAR: gt_zmii_organizasyon,gt_zmii_organizasyon[],gs_zmii_organizasyon.

  LOOP AT it_topnodes INTO wa_topnodes.
    CALL METHOD tree1->delete_subtree
      EXPORTING
        i_node_key            = wa_topnodes-nodekey
      EXCEPTIONS
        node_key_not_in_model = 1
        OTHERS                = 2.
  ENDLOOP.
  CALL METHOD cl_gui_cfw=>flush.
  CLEAR: it_topnodes[].

  DATA: ls_zmii_organizasyon TYPE ty_zmsaa_organization,
        lt_zmii_organizasyon TYPE TABLE OF ty_zmsaa_organization. "düğümlerin koyulacağı internal table"
  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_000
  FROM zmsaa_t_arbpl.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_001
  FROM zmsaa_t_shift.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_002
  FROM zmsaa_t_group.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_003
  FROM zmsaa_t_team.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_004
  FROM zmsaa_t_team_sec.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_004_1
  FROM zmsaa_t_team_mac.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_004_2
  FROM zmsaa_t_team_per.

  DATA: l_uretimyeri_key    TYPE lvc_nkey,
        l_uretimbolum_key   TYPE lvc_nkey,
        l_grupno_key        TYPE lvc_nkey,
        l_bolummakine_key   TYPE lvc_nkey,
        l_takimno_key       TYPE lvc_nkey,
        l_takimbolum_key    TYPE lvc_nkey,
        l_takimmakine_key   TYPE lvc_nkey,
        l_takimpersonel_key TYPE lvc_nkey,
        l_yok_key           TYPE lvc_nkey,
        l_last_key          TYPE lvc_nkey,
        lv_deger            TYPE char250.

  LOOP AT lt_000."Production Locations
    CLEAR: ls_zmii_organizasyon.
    MOVE-CORRESPONDING  lt_000 TO ls_zmii_organizasyon.
    APPEND ls_zmii_organizasyon TO lt_zmii_organizasyon.
    CONCATENATE 'Üretim Yeri'(009) ls_zmii_organizasyon-uretimyeri
    INTO lv_deger SEPARATED BY '-'.
    ls_zmii_organizasyon-tablename  = 'ZMSAA_T_ARBPL'.
    ls_zmii_organizasyon-tablename1 = 'ZMSAA_T_SHIFT'.
    PERFORM add_carrid_line USING    ls_zmii_organizasyon
                                     ''
                                     lv_deger
                            CHANGING l_uretimyeri_key.
    CLEAR gs_available_nodes.
    gs_available_nodes = ls_zmii_organizasyon.
    gs_available_nodes-node = l_uretimyeri_key.
    APPEND gs_available_nodes TO gt_available_nodes.

    wa_topnodes-nodekey = l_uretimyeri_key.
    APPEND wa_topnodes TO it_topnodes.

    LOOP AT lt_001 "Shift Group Catalog
                  WHERE
                  uretimyeri = lt_000-uretimyeri.
      CLEAR: ls_zmii_organizasyon.
      MOVE-CORRESPONDING lt_001 TO ls_zmii_organizasyon.
      APPEND ls_zmii_organizasyon TO lt_zmii_organizasyon.

      CONCATENATE text-010 ls_zmii_organizasyon-uretimvardiya
      INTO lv_deger SEPARATED BY '-'.
      ls_zmii_organizasyon-tablename  = 'ZMSAA_T_SHIFT'.
      ls_zmii_organizasyon-tablename1 = 'ZMSAA_T_GROUP'.
      PERFORM add_carrid_line USING    ls_zmii_organizasyon
                                       l_uretimyeri_key
                                       lv_deger
                              CHANGING l_grupno_key.
      CLEAR gs_available_nodes.
      gs_available_nodes = ls_zmii_organizasyon.
      gs_available_nodes-node = l_grupno_key.
      gs_available_nodes-ust_node = l_uretimyeri_key.
      APPEND gs_available_nodes TO gt_available_nodes.

      LOOP AT lt_002 "Group Catalog
      WHERE
      uretimyeri = lt_001-uretimyeri AND
      uretimvardiya = lt_001-uretimvardiya.
        MOVE-CORRESPONDING lt_002 TO ls_zmii_organizasyon.
        APPEND ls_zmii_organizasyon TO lt_zmii_organizasyon.

        CONCATENATE text-011 ls_zmii_organizasyon-grupno
        INTO lv_deger SEPARATED BY '-'.
        ls_zmii_organizasyon-tablename  = 'ZMSAA_T_GROUP'.
        ls_zmii_organizasyon-tablename1 = 'ZMSAA_T_TEAM'.
        CLEAR:ls_zmii_organizasyon-tablename2.

        PERFORM add_carrid_line USING    ls_zmii_organizasyon
                                         l_grupno_key
                                         lv_deger
                                CHANGING l_takimno_key.
        CLEAR gs_available_nodes.
        gs_available_nodes = ls_zmii_organizasyon.
        gs_available_nodes-node = l_takimno_key.
        gs_available_nodes-ust_node = l_grupno_key.
        APPEND gs_available_nodes TO gt_available_nodes.

        LOOP AT lt_003 "Teams
        WHERE
        uretimyeri = lt_002-uretimyeri AND
        uretimvardiya = lt_002-uretimvardiya AND
        grupno = lt_002-grupno.
          MOVE-CORRESPONDING lt_003 TO ls_zmii_organizasyon.
          APPEND ls_zmii_organizasyon TO lt_zmii_organizasyon.

          CONCATENATE text-012 ls_zmii_organizasyon-takimno
          INTO lv_deger SEPARATED BY '-'.
          ls_zmii_organizasyon-tablename  = 'ZMSAA_T_TEAM'.
          ls_zmii_organizasyon-tablename1 = 'ZMSAA_T_TEAM_SEC'.
          PERFORM add_carrid_line USING    ls_zmii_organizasyon
                                           l_takimno_key
                                           lv_deger
                                  CHANGING l_takimbolum_key.
          CLEAR gs_available_nodes.
          gs_available_nodes = ls_zmii_organizasyon.
          gs_available_nodes-node = l_takimbolum_key.
          gs_available_nodes-ust_node = l_takimno_key.
          APPEND gs_available_nodes TO gt_available_nodes.

          LOOP AT lt_004 "Team/Section Catalog
          WHERE
          uretimyeri = lt_003-uretimyeri AND
          uretimvardiya = lt_003-uretimvardiya AND
          grupno = lt_003-grupno AND
          takimno = lt_003-takimno.
            MOVE-CORRESPONDING lt_004 TO ls_zmii_organizasyon.
            APPEND ls_zmii_organizasyon TO lt_zmii_organizasyon.

            CONCATENATE text-013 ls_zmii_organizasyon-bolum
            INTO lv_deger SEPARATED BY '-'.
            ls_zmii_organizasyon-tablename  = 'ZMSAA_T_TEAM_SEC'.
            ls_zmii_organizasyon-tablename1 = 'ZMSAA_T_TEAM_MAC'.
            ls_zmii_organizasyon-tablename2 = 'ZMSAA_T_TEAM_PER'.
            PERFORM add_carrid_line USING    ls_zmii_organizasyon
                                             l_takimbolum_key
                                             lv_deger
                                    CHANGING l_takimmakine_key.
            CLEAR gs_available_nodes.
            gs_available_nodes = ls_zmii_organizasyon.
            gs_available_nodes-node = l_takimmakine_key.
            gs_available_nodes-ust_node = l_takimbolum_key.
            APPEND gs_available_nodes TO gt_available_nodes.

            LOOP AT lt_004_1 "Team Machines
            WHERE
            uretimyeri = lt_004-uretimyeri AND
            uretimvardiya = lt_004-uretimvardiya AND
            grupno = lt_004-grupno AND
            takimno = lt_004-takimno AND
            bolum   = lt_004-bolum.
              MOVE-CORRESPONDING lt_004_1 TO ls_zmii_organizasyon.
              APPEND ls_zmii_organizasyon TO lt_zmii_organizasyon.

              CONCATENATE text-014 ls_zmii_organizasyon-makine
              INTO lv_deger SEPARATED BY '-'.
              ls_zmii_organizasyon-tablename  = 'ZMSAA_T_TEAM'.
              CLEAR:ls_zmii_organizasyon-tablename1,ls_zmii_organizasyon-tablename2.

              PERFORM add_carrid_line USING    ls_zmii_organizasyon
                                               l_takimmakine_key
                                               lv_deger
                                      CHANGING l_yok_key.
              CLEAR gs_available_nodes.
              gs_available_nodes = ls_zmii_organizasyon.
              gs_available_nodes-node = l_yok_key.
              gs_available_nodes-ust_node = l_takimmakine_key.
              APPEND gs_available_nodes TO gt_available_nodes.

            ENDLOOP.
            LOOP AT lt_004_2 "Team Personnel
            WHERE
            uretimyeri = lt_004-uretimyeri AND
            uretimvardiya = lt_004-uretimvardiya AND
            grupno = lt_004-grupno AND
            takimno = lt_004-takimno AND
            bolum   = lt_004-bolum.
              MOVE-CORRESPONDING lt_004_2 TO ls_zmii_organizasyon.
              APPEND ls_zmii_organizasyon TO lt_zmii_organizasyon.

              CONCATENATE text-015 ls_zmii_organizasyon-personelno
              INTO lv_deger SEPARATED BY '-'.
              ls_zmii_organizasyon-tablename  = 'ZMSAA_T_TEAM'.
              CLEAR:ls_zmii_organizasyon-tablename1,ls_zmii_organizasyon-tablename2.
              PERFORM add_carrid_line USING    ls_zmii_organizasyon
                                               l_takimmakine_key
                                               lv_deger
                                      CHANGING l_yok_key.
              CLEAR gs_available_nodes.
              gs_available_nodes = ls_zmii_organizasyon.
              gs_available_nodes-node = l_yok_key.
              gs_available_nodes-ust_node = l_takimmakine_key.
              APPEND gs_available_nodes TO gt_available_nodes.

            ENDLOOP.
          ENDLOOP.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDLOOP.
  SORT lt_zmii_organizasyon BY uretimyeri uretimvardiya grupno takimno pozisyon
  .
* calculate totals
  CALL METHOD tree1->update_calculations.

* this method must be called to send the data to the frontend
  CALL METHOD tree1->frontend_update.

ENDFORM.                               " create_hierarchy

FORM change_toolbar.

* get toolbar control
  CALL METHOD tree1->get_toolbar_object
    IMPORTING
      er_toolbar = mr_toolbar.

  CHECK NOT mr_toolbar IS INITIAL.

* add seperator to toolbar
  CALL METHOD mr_toolbar->add_button
    EXPORTING
      fcode     = ''
      icon      = ''
      butn_type = cntb_btype_sep
      text      = ''
      quickinfo = text-016."'This is a Seperator'.                    "#EC NOTEXT

* add Standard Button to toolbar (for Delete Subtree)
  CALL METHOD mr_toolbar->add_button
    EXPORTING
      fcode     = 'DELETE'
      icon      = '@18@'
      butn_type = cntb_btype_button
      text      = ''
      quickinfo = 'Delete subtree'.                         "#EC NOTEXT

* add Dropdown Button to toolbar (for Insert Line)
  CALL METHOD mr_toolbar->add_button
    EXPORTING
      fcode     = 'DEGISTIR'
      icon      = icon_change
      butn_type = cntb_btype_dropdown
      text      = ''
      quickinfo = 'Insert Line'.                            "#EC NOTEXT

* set event-handler for toolbar-control
  CREATE OBJECT toolbar_event_receiver.
  SET HANDLER toolbar_event_receiver->on_function_selected
                                                      FOR mr_toolbar.
  SET HANDLER toolbar_event_receiver->on_toolbar_dropdown
                                                      FOR mr_toolbar.

ENDFORM.                               " change_toolbar