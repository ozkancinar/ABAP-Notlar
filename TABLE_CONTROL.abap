* Wizard ile oluşturulur
* İstenilen alanları seç ve o senin için oluştursun

* Sütun gizleme:
PROCESS BEFORE OUTPUT.
*&SPWIZARD: PBO FLOW LOGIC FOR TABLECONTROL 'TBL_MLZ'
  MODULE TBL_MLZ_CHANGE_TC_ATTR.
*&SPWIZARD: MODULE TBL_MLZ_CHANGE_COL_ATTR.
  LOOP AT   GT_DATA
       INTO GT_DATA
       WITH CONTROL TBL_MLZ
       CURSOR TBL_MLZ-CURRENT_LINE.
    MODULE TBL_MLZ_GET_LINES.
    MODULE MODIFY_table. "Sütun gizleme modülümüz"
*&SPWIZARD:   MODULE TBL_MLZ_CHANGE_FIELD_ATTR
  ENDLOOP.


MODULE MODIFY_TABLE OUTPUT.
*  Table control sütun gizleme
*  Table control column invisible
  DATA wa_tabctrl TYPE cxtab_column .

* loop at the table control
  LOOP AT TBL_MLZ-COLS INTO WA_TABCTRL.
    IF WA_TABCTRL-SCREEN-NAME =  'GT_DATA-KUNNR'
      or WA_TABCTRL-SCREEN-NAME =  'GT_DATA-BUKRS'
      or WA_TABCTRL-SCREEN-NAME =  'GT_DATA-EBELP'.
      WA_TABCTRL-SCREEN-INVISIBLE =  'X'.
*     Modify the table for table control
      MODIFY TBL_MLZ-COLS FROM WA_TABCTRL.
     ENDIF.
  ENDLOOP.
ENDMODULE.                 " MODIFY_TABLE  OUTPUT