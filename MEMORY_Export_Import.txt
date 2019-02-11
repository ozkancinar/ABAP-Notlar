" MEMORY bellekte bir alan olarak tutulur. Bu alana değişken, tablo, structure atılabilir. Bu alan globaldir her yerden aynı isimle erişilir.

"report ZPRG1.
EXPORT lt_mara TO MEMORY ID 'PRG5'.

*report ZPRG2.
DATA lt_mara_import TYPE TABLE OF mara.
IMPORT lt_mara TO lt_mara_import FROM MEMORY ID 'PRG5'.

TYPES: BEGIN OF t_data,
         id    TYPE c LENGTH 2,
         ltext TYPE c LENGTH 15,
       END OF t_data.

DATA : gs_data  TYPE t_data,
       gt_edata TYPE STANDARD TABLE OF t_data,
       gt_idata TYPE STANDARD TABLE OF t_data.

gs_data-id    = '1'.
gs_data-ltext = 'Metin 1'.
APPEND gs_data TO gt_edata.

gs_data-id    = '2'.
gs_data-ltext = 'Metin 2'.
APPEND gs_data TO gt_edata.

EXPORT data_tab = gt_edata TO MEMORY ID 'EXXX'.

IMPORT data_tab = gt_idata FROM MEMORY ID 'EXXX'.

WRITE: 3 'ID', 8 'Text'.

LOOP AT gt_idata INTO gs_data.
  WRITE: /3 gs_data-id, 8 gs_data-ltext.
ENDLOOP.

******** Export & Import Variable *********

DATA : gv_text1 TYPE c LENGTH 15 VALUE 'ABAP memory',
       gv_text2 TYPE c LENGTH 15.

EXPORT ex_text = gv_text1 TO MEMORY ID 'EXXX'.

IMPORT ex_text = gv_text2 FROM MEMORY ID 'EXXX'.
WRITE: 'Export text:', gv_text2.

