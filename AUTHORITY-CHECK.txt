Kullanıcının veri tabanı üzerinde bir işlem yapmaya yetkisi olup olmadığına bakılır
AUTHORITY-CHECK OBJECT'e SU21'den erişebilirsin

Yarat - 01
Değiştir - 02
Display - 03

PARAMETERS carr TYPE spfli-carrid. 

AT SELECTION-SCREEN. 
  AUTHORITY-CHECK OBJECT 'S_CARRID' 
    ID 'CARRID' FIELD carr 
    ID 'ACTVT'  FIELD '03'. 

  IF sy-subrc <> 0. 
    MESSAGE 'No authorization' TYPE 'E'. 
  ENDIF. 

