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

data(cell) = |CLASS{ up_level_ind }|.
ASSIGN COMPONENT cell OF STRUCTURE <alv_data> TO FIELD-SYMBOL(<up_level>).

ASSIGN generic->* TO FIELD-SYMBOL(<generic>).
ASSIGN COMPONENT name OF STRUCTURE structure TO FIELD-SYMBOL(<component>).
ASSIGN (class_name)=>(static_member) TO FIELD-SYMBOL(<member>).


field-symbols: <fs_tab> type standard table,
               <fs_wa> type mara.

loop at <fs_tab> assigning <fs_wa>.
  <fs_wa>-matnr = ‘NEW CHANGE MATERIAL’.
endloop.

UNASSIGN <lfs_mara>.
* Check if Field-Symbol is assigned
IF <lfs_mara> IS ASSIGNED.
  WRITE: 'Assigned'.
ELSE.
  WRITE: 'Unassigned'.
ENDIF.
