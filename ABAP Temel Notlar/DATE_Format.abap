
DATA lv_date TYPE d.
DATA lv_time TYPE t.

lv_date = sy_datum.
WRITE: 'date:' , lv_date. "Formatsız gösterim MMDDYYYY

DATA lv_date2 TYPE c LENGTH 30.
WRITE lv_date to lv_date2 DD/MM/YYY. "Birinci değişkeni lv_date2'ye belirtilen formatta yazar

*Ekrana yazdıralım

WRITE: / 'Formatlı tarih:' , lv_date2. "DD.MM.YYYY.

* Zaman için uygulayalım
DATA lv_time2 TYPE c LENGTH 30.
WRITE lv_time to lv_time2 USING EDIT MAST '__:__:__'. "Formatı belirliyoruz

*Ekrana yazalım

WRITE: / 'Formatlı zaman:', lv_time2. "HH:MM:SS

"Timestamp'a çevir
CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP g_timestmp1 TIME ZONE sy-zonlo.