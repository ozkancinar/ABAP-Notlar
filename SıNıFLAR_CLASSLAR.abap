CL_SYSTEM_UUID ""-> Guid oluşturmak için kullanılır
CL_RECA_GUID ""-> Guid oluştur
CL_RECA_GUI_SERVICES ""-> Call transaction
CL_RECA_STRING_SERVICES ""-> String işlemleri split, substring vs
CL_REEXC_COMPANY_CODE ""-> Müşteri koduna göre detaylı bilgiler
CL_PT_EMPLOYEE ""-> çalışan personel koduna göre detaylı bilgiler
CL_GUI_CFW ""-> Control screen framework işlemleri set_new_ok_code
CL_GUI_FRONTEND_SERVICES ""-> dosya yükle, indir, işletim sistemi, gui bilgileri
/UI2/CL_ABAP2JSON ""-> Abap to json
/UI2/CL_JSON ""-> json
/UI5/CL_JSON_UTIL ""-> json
C_UTILS ""-> bir çok konuda işe yarar metotlara sahip
CL_ABAP_ITAB_UTILITIES
CL_ABAP_CORRESPONDING "iki tabloyu birleştirme mapleme
CL_ABAP_DBFEATURES "abap db özellikleri kontrolü"
CL_ABAP_MATCHER "regex
CL_ABAP_REGEX "regex
CL_APC_TIMER_MANAGER "timer"
CL_ABAP_TSTMP "timestamp ekleme çıkarma işlemleri
CL_RECA_TIMESTAMP "timestamp çevrim vs işlemleri
"---------------------------------------------------"
"değişken tipini döndür
cl_abap_elemdescr=>describe_by_name(
  EXPORTING
    p_name         =  'MATNR'   " Type name
  RECEIVING
    p_descr_ref    = data(lo_ref)    " Reference to description object
).
lv_data_kind = lo_ref->type_kind.

*------------------------------------------------------
*data element metni
CL_ABAP_STRUCTDESCR  DESCRIBE_BY_NAME GET_DDIC_FIELD
