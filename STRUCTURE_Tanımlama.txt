1.	DATA struc_name TYPE struc_type. 
2.	TABLES global_structure_type. "global structure type(structure,view,table vs.) ile aynı isimde ve aynı satır yapısına ait bir structure oluşturulur.

* --- Bir type'ı referans alarak tanımlama ----- "Tavsiye edilir"

*-----  STRUCTURE TANIMLAMA   ----------

TYPES : BEGIN OF st_flightinfo,
            carrid TYPE s_carr_id,
            connid TYPE s_conn_id,
            fldate TYPE s_date,
            percentage(3) TYPE p DECIMALS 2,
  END OF st_flightinfo.

DATA : lv_flig htinfo TYPE st_flightinfo.

lv_flightinfo-carrid = 'TON'.
lv_flightinfo-connid = '0001'.
lv_flightinfo-fldate = sy-datum.

WRITE: 'carrid: ', lv_flightinfo-carrid,
      / 'conid' , lv_flightinfo-connid.

* -----------------------------------------------

*-------------- Include ---------------
data: BEGIN OF gt_data occurs 0.
      include STRUCTURE zczms_pp_satis_tahmin.
      data: del, color(4).
      data: END OF gt_data.
*--------------------------------------
* Eğer aynı alanlara sahip structurelar eklenecekse renaming with suffix kullanılabilir
CLASS-DATA: wa1 TYPE demo_join1,
            wa2 TYPE demo_join2,
            out TYPE REF TO if_demo_output.
CLASS-DATA BEGIN OF wa.
        INCLUDE STRUCTURE wa1 AS wa1 RENAMING WITH SUFFIX 1.
        INCLUDE STRUCTURE wa2 AS wa2 RENAMING WITH SUFFIX 2.
CLASS-DATA END OF wa.

* ----- Direkt datayı tanımlama -------

DATA : BEGIN OF wa_flightinfo,     
    carrid TYPE s_carr_id,
    connid TYPE s_conn_id,
    fldate TYPE s_date ,
    percentage(3) TYPE p DECIMALS 2,
END OF wa_flightinfo.

* ------------------------------------

* ----- İç içe Structure Tanımlama ---------

TYPES : BEGIN OF st_flightinfo,
           carrid TYPE s_carr_id,
           connid TYPE s_conn_id,
           fldate TYPE s_date,
END OF st_flightinfo.

DATA : BEGIN OF st_flight,             
           flightinfo TYPE st_flightinfo,
           url type scarr-url,
           bookid type sbook_bookid,
 END OF st_flight.

* -------------------------------------------