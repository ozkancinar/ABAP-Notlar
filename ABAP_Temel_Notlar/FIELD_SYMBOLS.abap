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

"casting
TYPES:
  BEGIN OF time,
    hours   TYPE c LENGTH 2,
    minute  TYPE c LENGTH 2,
    seconds TYPE c LENGTH 2,
  END OF time.
FIELD-SYMBOLS <fs> TYPE any.
ASSIGN sy-timlo TO <fs> CASTING TYPE time.
cl_demo_output=>display( <fs> ).

"casting to predefined type
DATA: pack1 TYPE p DECIMALS 2 VALUE '400'.
ASSIGN pack1 TO <f1> CASTING TYPE p DECIMALS 1.
"pack1: 400.00 
"<f1>: 4000.0
