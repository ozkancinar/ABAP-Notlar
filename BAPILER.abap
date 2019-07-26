* Siparişe ait veriler
CALL FUNCTION 'BAPI_PRODORD_GET_DETAIL'
*------------------------------------------------
* Malzemeye göre sipariş bilgisi
 call function 'BAPI_RESERVATION_GETITEMS1'
*------------------------------------------------
"Muhatap adres bilgilerini al
CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'

CALL FUNCTION 'BAPI_BUPA_ADDRESS_GETDETAIL'
*-------------------------------------------------
"kur verilerini toplu kaydet
call function 'BAPI_EXCHRATE_CREATEMULTIPLE'
*-------------------------------------------------
*kur verilerini kaydet
call function 'BAPI_EXCHANGERATE_CREATE'
*------------------------------------------------
