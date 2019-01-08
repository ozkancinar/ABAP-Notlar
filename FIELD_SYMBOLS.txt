* Field symbols bellekte yer tutmayacak şekilde değişken tanımlama yöntemidir.
* C'deki pointer'a benzer. Tanımlandıktan sonra kullanabilmek için assign komutuna ihtiyaç duyulur.
* Field symbol üzerinde yaptığımız her değişiklik otomatik olarak assign ile daha önce bağladığımız
* ifade güncellenir.

"Text şeklinde verilen değişkeni bir field symbole atayabiliriz"
assign ('(SAPLZA_CALC_01)GV_MEMORY') to <fs_string>.
if <fs_string> is assigned.
endif.

assign component 2 of structure gs_mara to <fs_mara>. "bir structure'ın birinci alanına erişir"
assign component 'MATNR' of structure gs_mara to <fs_any>. "bir strucure'ın alan ismine göre erişme"


field-symbols: <fs_tab> type standard table,
               <fs_wa> type mara.

data : itab_mara like mara occurs 0 with header line.

select * from mara up to 10 rows into table itab_mara.

assign : itab_mara[] to <fs_tab>.

loop at <fs_tab> assigning <fs_wa>.
  <fs_wa>-matnr = ‘NEW CHANGE MATERIAL’.
endloop.

loop at <fs_tab> assigning field-symbol(<fs_wa>).
  <fs_wa>-matnr = ‘NEW CHANGE MATERIAL’.
endloop.

UNASSIGN <lfs_mara>. 
* Check if Field-Symbol is assigned
IF <lfs_mara> IS ASSIGNED.
  WRITE: 'Assigned'.
ELSE.
  WRITE: 'Unassigned'.
ENDIF.
 

FIELD-SYMBOLS: <fs_mara> LIKE LINE OF gt_mara.
FIELD-SYMBOLS: <fs_any> TYPE any.
DATA: gv_fieldname TYPE string.
TYPES: ty_mara TYPE TABLE OF mara.
FIELD-SYMBOLS: <fs_mara_t> TYPE ty_mara.

ASSIGN gt_mara[] TO <fs_mara_t>.
CLEAR <fs_mara_t>[].
SELECT * FROM mara INTO TABLE <fs_mara_t>
  UP TO 100 ROWS.

ASSIGN gs_mara TO <fs_mara>.
LOOP AT <fs_mara_t> INTO <fs_mara>.

ENDLOOP.

gv_fieldname = 'GS_MARA-MATNR'.
LOOP AT gt_mara INTO gs_mara.
*  ASSIGN gs_mara TO <fs_any>.
*  ASSIGN COMPONENT 2 OF STRUCTURE gs_mara TO <fs_any>.
  ASSIGN (gv_fieldname) TO <fs_any>.
  <fs_any> = 324234.
*  UNASSIGN <fs_any>.
*  ASSIGN COMPONENT 'MATNR' OF STRUCTURE gs_mara TO <fs_any>.
*  <fs_any> = 'test'.
*  MODIFY gt_mara FROM gs_mara.
ENDLOOP.

*LOOP AT gt_mara ASSIGNING <fs_mara>.
*
*  <fs_mara>-matnr = 'test'.
*ENDLOOP.
