* var olan tabloyu sıfırlamadan gelen verileri tabloya eklemek istersek appending kullanılır
 select * from makt appending CORRESPONDING FIELDS OF table gt_tanim
  where matnr eq pa_matnr.

* > 7.40
select a~* b~abc from ztable1 inner join a on …

 if it_component[] is not initial.
    select *
     from mara
      into CORRESPONDING FIELDS OF TABLE lt_mara
       FOR ALL ENTRIES IN it_component
        where matnr eq it_component-material
          and mtart in ('Z001','Z004').

    sort lt_mara by matnr.
  endif.

  
select single odeme_tipi_tnm
     from zmmt_odeme_tipi
      into gt_masraf_hdr-odeme_tipi_tnm
       where odeme_tipi eq gt_masraf_hdr-odeme_tipi.
  
 report ztx0202.
 tables ztxlfa1.
 select * from ztxlfa1 into ztxlfa1 order by lifnr.
	write / ztxlfa1-lifnr.
 	endselect.

// Alternatif kullanım //

 report ztx0203.
 tables ztxlfa1.
 select * from ztxlfa1 order by lifnr.
	write / ztxlfa1-lifnr.
 	endselect.

////////////////////////////////

* ///////// Select single ///////

Veri tabanından yalnızca bir değer dönmesini sağlar. select/endselect''ten daha hızlıdır
Bir döngü oluşturmaz yalnızca bir değer döner

report ztx0209.
tables ztxlfa1.
select single * from ztxlfa1 where lifnr = 'V1'.
if sy-subrc = 0.
	write: / ztxlfa1-lifnr, ztxlfa1-name1.
else.
	write 'record not found'.
endif. 

/////////////////////////////



////// Work Area //////

tables statement her zaman varsayılan bir work areaya sahiptir ancak biz kendimiz de tanımlayabiliriz.
ilave table work area oluşturmak için 'data' ifadesi kullanılır. data wa like t1. 
wa: Tanımlamak istenen Table work areanın adı
t1: work areanın modeli olan bir tablo


report ztx0204.
* kullanılacak tablo tanımlanıyor
tables ztxlfa1. 
data wa like ztxlfal. " ztxlfa1 tablosunu model alan Work area tanımlanıyor
select * from ztxlfa1 into wa order by lifnr.
	write / wa-lifnr.
	endselect.


//////////////////////////////////////////////

///// WHERE KULLANIMI /////////

report ztx0205.
tables ztxlfa1.
select * from ztxlfa1 where lifnr < '0000002000' order by lifnr.
	write / ztxlfa1-lifnr.
	endselect.

////////////////////////////////

//////////////// CHAIN OPERATOR KULLANIMI /////////////

tables ztxlfa1.
tables ztxlfb1. 

yerine şu şekilde tanımlama yapabiliriz

tables: ztxlfa1, ztxlfb1.


report ztx0208.
tables ztxlfa1.
select * from ztxlfa1 order by lifnr.
	write: / sy-dbcnt, ztxlfa1-lifnr
	endselect.
write: / sy-dbcnt, 'records found'.

////////////////////////////////////////////////////////

-------------- TABLES KULLANIMI ----------

report ztx0810.
tables ztxlfa1.
select * from ztxlfa1 into ztxlfa1 order by lifnr.
		write / ztxlfa1-lifnr.
		endselect.

------------------------------------------

*---------------- Type olmadan veriyi doğrudan data'ya yazma ----------
Data : gd_carrid type sflight-carrid,
             gd_connid type sflight-connid,
   gd_fldate type sflight-fldate.
 
SELECT carrid connid fldate FROM sflight INTO (gd_carrid, gd_connid, gd_fldate).
---------------------------------------------

---- UP TO 100 ROWS -------

SELECT carrid connid fldate FROM sflight INTO (gd_carrid, gd_connid, gd_fldate)
	UP TO 100 ROWS.

--------
