* MODIFY veri tabanına bir veya daha fazla satır ekler. Eğer primary key tekrar ediyorsa update olarak çalışır hata vermez

DATA lt_paket LIKE TABLE OF zknt_fire.

MODIFY zknt_fire FROM TABLE lt_paket.
modify zlog_satis_th from ls_log.
COMMIT WORK and wait.

sy-subrc 0 - En az bir satır eklendi
sy-subrc 4 - HATA
-----------------------------------------------

* INSERT veri tabanına bir veya daha fazla satır ekler. Tekrara izin vermez primary key bazında ekler. Tekrar anında hata verir.

DATA scarr_wa TYPE scarr. 

scarr_wa-carrid   = 'FF'. 
scarr_wa-carrname = 'Funny Flyers'. 
scarr_wa-currcode = 'EUR'. 
scarr_wa-url      = 'http://www.funnyfly.com'. 

INSERT INTO scarr VALUES scarr_wa.

alternate: Insert into scarr FROM TABLE itab [ACCEPTING DUPLICATE KEYS]
sy-subrc 0 - En az bir satır eklendi
sy-subrc 4 - HATA

* Eğer bir veri tabanı tablosuna veri eklenecekse
insert zveri_tabanı_tablosu from gt_table.
if sy-subrc eq 0.
  commit work.
else.
  rollback work.
ENDIF.
----------------------------------------------

* UPDATE var olan bir satırı primary key'e göre değiştirir

DATA: lt_paket1 LIKE TABLE OF zkntfis.

UPDATE zkntfis FROM TABLE lt_paket1.
COMMIT WORK.

update zdy_planes set plane_description = pa_pldes
                      plane_type = pa_type.
                  where plane_id = pa_id.
if  sy-subrc eq 0.
    commit work.
else.
  rollback work.
ENDIF.
----------------------------------------------

* DELETE veri tabanından bir veya daha fazla kayıt sil

DELETE FROM sflight 
WHERE  carrid = p_carrid AND 
       fldate = sy-datum AND 
       seatsocc = 0. 

*------
DATA sflight_key_tab TYPE TABLE OF sflight_key. 
DELETE sflight FROM TABLE sflight_key_tab.