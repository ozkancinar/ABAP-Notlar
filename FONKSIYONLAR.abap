*Alv Tablolarında fieldcat oluşturmak

lv_progname = sy-repid .
gt_flcat  type slis_t_fieldcat_alv
call function 'REUSE_ALV_FIELDCATALOG_MERGE' "Alv Tablolarında fieldcat oluşturmak için
    exporting
      i_program_name         = lv_progname
      i_internal_tabname     = 'GT_MRP'
      i_client_never_display = 'X'
      i_inclname             = lv_progname
    changing
      ct_fieldcat            = gt_flcat
    exceptions
      inconsistent_interface = 1
      program_error          = 2
      others                 = 3.

------------------------------------
*Satın alma talebi oluşturmak

Data: int_pohead like BAPIEKKOC, "satın alma belgesinin tarihi
      int_poitem like BAPIEKPOC occurs 0 with header line, "satın alma belge numarası
      int_posched like BAPIEKET occurs 0 with header line, "satın alam belgesi kalem numarası
      int_ret like BAPIRETURN occurs 0 with header line. "S Success, E Error, W Warning, I Info, A Abort
Data: d_purchord like BAPIEKKOC-PO_NUMBER. "Satınalma belge numarası

CALL FUNCTION 'BAPI_PO_CREATE' "Satın alma talebi oluşturmak için
  EXPORTING
   PO_HEADER                        = int_pohead
    SKIP_ITEMS_WITH_ERROR            = 'X'

 IMPORTING
   PURCHASEORDER                     = d_purchord
  TABLES
    PO_ITEMS                         = int_poitem
    PO_ITEM_SCHEDULES                = int_posched
    RETURN                           = int_ret
          .
If sy-subrc = 0.
  Write:/ 'Purchase Order Number is', d_purchord.
endif.

----------------------------------------
*Malzeme detaylarını al

DATA: lv_material    TYPE bapimatdet-material, "MATNR
      lv_plant       TYPE bapimatall-plant,
      lv_valar       TYPE bapimatall-val_area,
      lv_valty       TYPE bapimatall-val_type,
      ls_matgendata  TYPE bapimatdoa,
      ls_matplantdat TYPE bapimatdoc,
      ls_matvaldat   TYPE bapimatdobew,
      ls_return      LIKE bapireturn.

lv_plant    = '3110'.
lv_material = 'MATERIAL1'.

CALL FUNCTION 'BAPI_MATERIAL_GET_DETAIL' "Malzeme detaylarını al
  EXPORTING
   material                    = lv_material
   plant                       = lv_plant
   valuationarea               = lv_valar
   valuationtype               = lv_valty
 IMPORTING
   material_general_data       = ls_matgendata
   return                      = ls_return
   materialplantdata           = ls_matplantdat
   materialvaluationdata       = ls_matvaldat .

-----------------------------------------
*Malzeme uygunluğu kontrolü

DATA: lv_plant      LIKE  bapimatvp-werks,
      lv_material   LIKE  bapimatvp-matnr,
      lv_unit       LIKE  bapiadmm-unit,
      lv_endleadtme LIKE  bapicm61m-wzter,
      lv_av_qty_plt LIKE  bapicm61v-wkbst,
      lv_dialogflag LIKE  bapicm61v-diafl,
      ls_return     LIKE  bapireturn,
      lt_wmdvsx     TYPE STANDARD TABLE OF bapiwmdvs,
      ls_wmdvsx     LIKE LINE OF lt_wmdvsx,
      lt_wmdvex     TYPE STANDARD TABLE OF bapiwmdve,
      ls_wmdvex     LIKE LINE OF lt_wmdvex.

* Assign the material info.
lv_plant    = '1000'.
lv_material = 'MATERIAL1'.
lv_unit     = 'ST'.

CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
  EXPORTING
    plant                    = lv_plant
    material                 = lv_material
    unit                     = lv_unit
 IMPORTING
    endleadtme               = lv_endleadtme
    av_qty_plt               = lv_av_qty_plt
    dialogflag               = lv_dialogflag
    return                   = ls_return
  TABLES
    wmdvsx                   = lt_wmdvsx
    wmdvex                   = lt_wmdvex.

----------------------------------------
*Progress Bar oluşturmak

CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR' "Progress bar
  EXPORTING
    percentage       = 25
    text             = 'First step…'.

WAIT UP TO 3 SECONDS.

---------------------------------------
*Malzeme Birimi dönüşümü

DATA gv_menge TYPE mseg-menge.

PARAMETERS: pa_matnr TYPE mara-matnr,
            pa_in_me TYPE mara-meins,
            pa_out_m TYPE mara-meins,
            pa_menge TYPE ekpo-menge.

CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
  EXPORTING
    i_matnr              = pa_matnr
    i_in_me              = pa_in_me
    i_out_me             = pa_out_m
    i_menge              = pa_menge
  IMPORTING
    e_menge              = gv_menge

----------------------------------------
*Kur Dönüşümü

DATA gv_rate TYPE tcurr-ukurs.

CALL FUNCTION 'READ_EXCHANGE_RATE'
  EXPORTING
    client           = sy-mandt
    date = sy-datum
    foreign_currency = 'EUR'
    local_currency   = 'USD'
    type_of_rate     = 'M'
  IMPORTING
    exchange_rate    = gv_rate


WRITE: 'Rate:', gv_rate.

-----------------------------------------
*Mesaj Fonksiyonu

DATA: lt_message TYPE STANDARD TABLE OF bapiret2,
    ls_message TYPE bapiret2.

ls_message-id         = 'FB'.
ls_message-number     = '001'.
ls_message-type       = 'S'.
APPEND ls_message to lt_message.

ls_message-number     = '002'.
APPEND ls_message to lt_message.

CALL FUNCTION 'MESSAGES_INITIALIZE'.

LOOP AT lt_message INTO ls_message.
CALL FUNCTION 'MESSAGE_STORE'
  EXPORTING
    arbgb                   = ls_message-id
    exception_if_not_active = space
    msgty                   = ls_message-type
    msgv1                   = ls_message-message_v1
    msgv2                   = ls_message-message_v2
    msgv3                   = ls_message-message_v3
    msgv4                   = ls_message-message_v4
    txtnr                   = ls_message-number
ENDLOOP.

CALL FUNCTION 'MESSAGES_SHOW'.
------------------------------------------
*Fazla sıfırları silerek integera çevirir  0000300014 -> 300014

call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
    exporting
      input  = ptext
    importing
      output = ptext.

* > V7.40
DATA(lv_without_zeros) = |{ lv_num ALPHA = OUT }|

" lv_without_zeros value is now '1'.

-----------------------------------------
*Başa sıfır ekleyerek stringe çevirir 300014 -> 0000300014

call function 'CONVERSION_EXIT_ALPHA_INPUT'
    exporting
      input  = ptext
    importing
      output = ptext.

* > 7.40
DATA(lv_with_zeros) = |{ lv_without_zeros ALPHA = IN }|.

" lv_with_zeros value is now '0000000001'.

-----------------------------------------
*Bir transaction kodu çalıştırma

data: BEGIN OF imess OCCURS 0.
  include STRUCTURE bdcmsgcoll.
  data: END OF imess.

CALL FUNCTION 'ABAP4_CALL_TRANSACTION'
  EXPORTING
    TCODE                         = 'SE38'
 TABLES
   MESS_TAB                      = imess

----------------------------------------
*Bir transaction kodunu yeni bir pencerede çalıştırma

CALL FUNCTION 'TRANSACTION_CALL'
EXPORTING
TRANSACTION_NAME = 'SE37'
EXCEPTIONS
OTHERS = 1.
WRITE:/ 'FUNCTION CALLED'.

-----------------------------------------
*Kullanıcı erişim izni sorgulama

data: atype(20),
      P_FNAME LIKE AUTHB-FILENAME.

atype = 'WRITE'.

CALL FUNCTION 'AUTHORITY_CHECK_DATASET'
  EXPORTING
*   PROGRAM                =
    ACTIVITY               = atype
    FILENAME               = p_fname

 ----------------------------------------
*Kullanıcı sistem ve bilgisayar bilgilerini al

-2 SAP system directory
1 Computer name
2 Windows directory
3 Windows system directory
4 Temporary directory
5 Windows user name
6 Windows OS
7 Windows build number
8 Windows version
9 SAP GUI program name
10 SAP GUI program path
11 SAP current directory
l2 Desktop directory

CALL FUNCTION 'GUI_GET_DESKTOP_INFO'
    EXPORTING
      TYPE          = inforeq
    CHANGING
      RETURN        = v_value

CASE inforeq.
  WHEN '-2'.
    WRITE: / 'sap system directory ', v_value.
  WHEN '1'.
    WRITE: / 'computer name ', v_value.

-----------------------------------------
*Yeni oturum açma

CALL FUNCTION 'HLP_MODE_CREATE'
  EXPORTING
    TCODE                 = 'se38'
          .

-----------------------------------------
*Tür dönüşümü örn: KG to TON

FIELD-SYMBOLS <field>.

data: return_value like plfh-mgvgw,
      unit_value like plfh-mgvgw.

SELECT SINGLE * from mara WHERE gewei eq 'KG' and
  brgew gt 0.

ASSIGN ('MARA-BRGEW') to <field>.
MOVE: <field> to unit_value.

CALL FUNCTION 'CF_UT_UNIT_CONVERSION'
  EXPORTING
   MATNR_IMP           = MARA-MATNR
   MEINS_IMP           = MARA-MEINS
    UNIT_NEW_IMP        = 'TON'
    UNIT_OLD_IMP        = MARA-GEWEI
    VALUE_OLD_IMP       = unit_value
 IMPORTING
   VALUE_NEW_EXP       = return_value

----------------------------------------
*Satış belgesi numaralarını SAP formatına çevirir

data: v_auart like tvakt-auart,
      v_auart_in1(4),
      v_auart_in2(4).

CALL FUNCTION 'CONVERSION_EXIT_AUART_OUTPUT'
    EXPORTING
      INPUT         = tvakt-auart
   IMPORTING
     OUTPUT        = v_auart
            .

  CALL FUNCTION 'CONVERSION_EXIT_AUART_INPUT'
    EXPORTING
      INPUT         = v_auart
   IMPORTING
     OUTPUT        = v_auart_in2

----------------------------------------
*String to an amount - string değer tip dönüşümü

DATA: V_AMT(10l, V-AMT2(10l.
PARAMETER: P_BETRG LIKE T5GI5-AMUNT.

CALL FUNCTION 'HRCM_STRING_TO_AMOUNT_CONVERT'
	EXPORTING
		STRING = V_AMT
		DECIMAL_SEPARATOR
		THOUSANDS_SEPARATOR = '.'
	IMPORTING
		BETRG = V_AMT2
	EXCEPTIONS
		CONVERT_ERROR = 1
		OTHERS = 2.

-----------------------------------------
* CURR tipindeki değeri stringe çevirir
call function 'HRCM_AMOUNT_TO_STRING_CONVERT'
    exporting
      betrg  = lt_malzeme-fkimg
    importing
      string = fkimg.

----------------------------------------
*İki tarih arasındaki yıl farkını verir
data age TYPE i.
PARAMETERS p_birthd LIKE sy-datum.

CALL FUNCTION 'COMPUTE_YEARS_BETWEEN_DATES'
  EXPORTING
    FIRST_DATE                        = p_birthd
*   MODIFY_INTERVAL                   = ' '
    SECOND_DATE                       = sy-datum
 IMPORTING
   YEARS_BETWEEN_DATES               = age

---------------------------------------
*İki tarih arasındaki saat farkını verir
PARAMETERS: P_CI_DAT LIKE SY-DATUM,
            p_ci_tim LIKE sy-uzeit,
            p_co_dat LIKE sy-datum,
            p_co_tim like sy-uzeit.

CALL FUNCTION 'COPF_DETERMINE_DURATION'
  EXPORTING
    I_START_DATE             = p_ci_dat
    I_START_TIME             = p_ci_tim
    I_END_DATE               = p_co_dat
    I_END_TIME               = p_co_tim
   I_UNIT_OF_DURATION       = 'H'
 IMPORTING
   E_DURATION               = i_dur
*----------------------------------------
"Dile göre haftanın günlerini dön"
call function 'WEEKDAY_GET'
*---------------------------------------
"Bir tarihin haftanın kaçıncı gününe geldiğini veren fonksiyon"
 call function 'DAY_IN_WEEK'.
*---------------------------------------
call function 'GET_WEEK_INFO_BASED_ON_DATE'
*---------------------------------------
"Haftanın gününü dile göre metin olarak döner"
call FUNCTION 'ISP_GET_WEEKDAY_NAME'
*---------------------------------------
" Get date of next occuring week day"
call function '/OSP/GETDATE_WEEKDAY'
*---------------------------------------
"Bir tarihe saniye saat ekle
call function 'C14Z_CALC_DATE_TIME'
*--------------------------------------
* RANDOM
CALL FUNCTION 'RANDOM_12'
  EXPORTING
    RND MIN = 1 "aralık min"
    RND MAX = 9 "aralık max"
  IMPORTING
    RND_VALUE = RNDVALUE "Dönen rastgele sayı"
  EXCEPTIONS
    OTHERS 1.
PSTKY = RNDVALUE.

"-----------------------------------------"
*random rastgele
call function 'QF05_RANDOM_INTEGER'
"-----------------------------------------"
*--------------------------------------
* PDF'i mail için binarye çevirme
"Adobe form oluştur. İmport kısmından gelen veriyi kullanacağız"
CALL FUNCTION l_fm_name
    EXPORTING
      /1bcdwb/docparams  = fp_docparams
      emp_info           = fs_per_info
    IMPORTING
      /1BCDWB/FORMOUTPUT = FP_FORMOUTPUT
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.
"binarye çevir"
CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      BUFFER                = FP_FORMOUTPUT-pdf
*   APPEND_TO_TABLE       = ' '
* IMPORTING
*   OUTPUT_LENGTH         =
    TABLES
      BINARY_TAB            = t_att_content_hex .
*----------------------------------------
* Dosya seçme ekranı açma. Popup file dialog

DATA: LT_FILE TYPE FILETABLE,
        LS_FILE LIKE LINE OF LT_FILE.

  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_OPEN_DIALOG
    EXPORTING
      WINDOW_TITLE = 'Select File'
      DEFAULT_FILENAME = '*.txt' "Default txt dosyalarını getirir
    CHANGING
      FILE_TABLE              = lt_file
      RC                      = lv_ret
*      USER_ACTION             =
*      FILE_ENCODING           =
    EXCEPTIONS
      FILE_OPEN_DIALOG_FAILED = 1
      CNTL_ERROR              = 2
      ERROR_NO_GUI            = 3
      NOT_SUPPORTED_BY_GUI    = 4
      others                  = 5
          .
  READ TABLE LT_FILE INTO LS_FILE INDEX 1.
  IF SY-SUBRC eq 0.
     LV_FILENAME = LS_FILE-FILENAME.
  ENDIF.

  CL_GUI_FRONTEND_SERVICES=>GUI_UPLOAD(
    EXPORTING
      FILENAME                = LV_FILENAME    " Name of file
      FILETYPE                = 'BIN'
    IMPORTING
      FILELENGTH              =  LV_LENGTH   " File length
    CHANGING
      DATA_TAB                = LT_DATA    " Transfer table for file contents
    EXCEPTIONS
      OTHERS                  = 19 ).
*-----------------------------------------------------------------*
"file dialogflag"
  DATA: ld_filename TYPE string,
       ld_path TYPE string,
       ld_fullpath TYPE string,
       ld_result TYPE i,
       gd_file TYPE c.

  data(lv_name) = gv_user && |_CV.pdf|.

  call method cl_gui_frontend_services=>file_save_dialog
    exporting
     window_title      = 'Dosya Kaydet'
*      default_extension = 'pdf'
      default_file_name = lv_name
      initial_directory = 'C:\'
    changing
      filename          = ld_filename "o.pdf
      path              = ld_path "yol
      fullpath          = ld_fullpath "yol+dosya
      user_action       = ld_result.

     if sy-subrc eq 0.

     endif.

*------------------------------------------------
"file dialog
call function 'WD_FILENAME_GET'

--------------------------------------------------
* Siparişin DUE Date, Teslimat tarihini al
call function 'J_1A_SD_CI_DUEDATE_CHECK'
    exporting
      iv_vbeln                 = ls_head-vbeln
      iv_zterm                 = ls_head-zterm
    importing
      ev_netdate               = ls_head-due_date
    exceptions
      time_below_limit         = 1
      fi_document_not_found    = 2
      payment_terms_incomplete = 3
      invoice_not_found        = 4
      others                   = 5.

--------------------------------------------------
* Bir ayın başlangıç ve bitiş tarihlerini verir. month begin end date
  data: lv_date      type sy-datum,
        lv_begindate type sy-datum,
        lv_enddate   type sy-datum.

  lv_date = sy-datum.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date             = lv_date
    importing
      ev_month_begin_date = lv_begindate
      ev_month_end_date   = lv_enddate.
*----------------------------------------------------
"Bir tarihe ay ekle veya çıkart date"
call function 'HR_JP_ADD_MONTH_TO_DATE'
"------------------------------------------------"
"Ayın son günü"
call function 'RP_LAST_DAY_OF_MONTHS'
--------------------------------------------------
* CRM siparişlerini oku
 SELECT guid FROM crmd_orderadm_h INTO TABLE gt_header
    WHERE object_id EQ objid.

    DELETE ADJACENT DUPLICATES FROM gt_header COMPARING table_line.

    CALL FUNCTION 'CRM_ORDER_READ'
      EXPORTING
        it_header_guid     = gt_header
      IMPORTING
        et_orderadm_h      = lt_orderadmh
        et_orderadm_i      = lt_orderadmi
        et_customer_h      = lt_customerh
        et_appointment     = lt_appointment
        et_partner         = lt_partner
        et_cumulat_h       = lt_cumulath
        et_ordprp_objl_i_d = lt_ordprp
        et_pricing         = lt_pricing
        et_pricing_i       = lt_pricingi
*     CHANGING
*       CV_LOG_HANDLE      =
      EXCEPTIONS
        document_not_found = 1
        error_occurred     = 2
*       DOCUMENT_LOCKED    = 3
*       NO_CHANGE_AUTHORITY               = 4
*       NO_DISPLAY_AUTHORITY              = 5
*       NO_CHANGE_ALLOWED  = 6
*       OTHERS             = 7
      .
*------------------------------------------------------

call function 'READ_TEXT' "Metin oku"

*------------------------------------------------------

"iki karakterli dil anahtarını tek karakterli SAP dil anaharına çevir TR > T"
call function 'CONVERSION_EXIT_ISOLA_INPUT'

*-----------------------------------------------------
"f4 help ALV search help"

 data lt_ret type table of ddshretval. "f4 hep dönüş verisi
    field-symbols: <ft_modi> type lvc_t_modi.
    data wa_modi type lvc_s_modi.


    if e_fieldname eq 'PROJE_TIPI'.
      " gt_proje_tipi tablosu zcrm_hr_007 veri tabanı tablosundan daha önce dolduruldu.

      call function 'F4IF_INT_TABLE_VALUE_REQUEST'
        exporting
*         DDIC_STRUCTURE         = ' '
          retfield     = 'PROJE_TIPI'
          window_title = 'Proje Seçimi'
          value_org    = 'S'

* IMPORTING
*         USER_RESET   =
        tables
          value_tab    = gt_proje_tipi[]
*         FIELD_TAB    =
          return_tab   = lt_ret[]
*         DYNPFLD_MAPPING        =
* EXCEPTIONS
*         PARAMETER_ERROR        = 1
*         NO_VALUES_FOUND        = 2
*         OTHERS       = 3
        .
      if sy-subrc eq 0.
        assign er_event_data->m_data->* to <ft_modi>.
        wa_modi-row_id = es_row_no-row_id.

        read table lt_ret into data(ls_ret) index 1.
        wa_modi-fieldname = 'PROJE_TIPI'.
        wa_modi-value = ls_ret-fieldval.
        append wa_modi to <ft_modi>.
      endif.
      er_event_data->m_event_handled = 'X'.

    endif.
*---------------------------------------------------
"f4 help se11'den yaratılan search help ile input parametrelerini vererek"
 CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
      EXPORTING
        tabname           = 'ZOZ_DOKTORLAR'    " Table/structure name from Dictionary
        fieldname         = 'DOKTOR_NO'    " Field name from Dictionary
        searchhelp        = 'ZOZSH_DOKTOR'    " Search help as screen field attribute
*       shlpparam         = 'GV_DEPARTMAN'   " Search help parameter in screen field
        dynpprog          = sy-repid    " Current program
        dynpnr            = sy-dynnr    " Screen number
        dynprofield       = 'GS_RANDEVULAR-DOKTOR_NO'    " Name of screen field for value return
        callback_program  = sy-repid    " Program for callback before F4 start
        callback_form     = 'SET_PARAM_VAL'    " Form for callback before F4 start (-> long docu)
*    IMPORTING
*       user_reset        =     " Single-Character Flag
      TABLES
        return_tab        = lt_return_tab   " Return the selected value
      EXCEPTIONS
        field_not_found   = 1
        no_help_for_field = 2
        inconsistent_help = 3
        no_values_found   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

"--------------------------------------------------------------
data lt_return_tab type standard table of ddshretval.
CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
EXPORTING
     searchhelp = 'ZSLV_HR_SH_ENDUSTRILER'
     tabname     = 'ZCRM_HR_04'
     fieldname   = 'ENDUSTRI'
     dynpprog    = sy-repid
     dynpnr      = sy-dynnr
     dynprofield = 'GS_PROJE_DETAY-ENDUSTRI'
TABLES
 return_tab        = lt_return_tab
EXCEPTIONS
 field_not_found   = 1
 no_help_for_field = 2
 inconsistent_help = 3
 no_values_found   = 4
 OTHERS            = 5.

FORM set_param_val TABLES record_tab STRUCTURE seahlpres
                 CHANGING shlp        TYPE shlp_descr_t
                          callcontrol LIKE ddshf4ctrl.

" f4 için gerekli form
  DATA : lwa_ddshifaces TYPE ddshiface.
  READ TABLE shlp-interface INTO lwa_ddshifaces
                            WITH KEY shlpfield = 'DEPARTMAN'."Document Type

  IF sy-subrc = 0.
    CLEAR lwa_ddshifaces-f4field.
    lwa_ddshifaces-value = gv_departman."Document Type Value
    MODIFY shlp-interface FROM lwa_ddshifaces INDEX sy-tabix.
  ENDIF.

ENDFORM.

*----------------------------------------------------
"Bir text eleemntin sonraki müsait numarasını al"
call function 'NUMBER_GET_NEXT'
  exporting
    nr_range_nr = gv_nr_range
    object      = 'ZCV_PROJ'
  importing
    number      = lv_proje_no.

*----------------------------------------------------
"Programdaki text elementleri belirtilen dilde okumayı sağlar"
call function RS_TEXTPOOL_READ

*----------------------------------------------------
"Progress bar, yükleniyor"
CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
  EXPORTING
    percentage = w_percentage
    text       = w_text.

*----------------------------------------------------
"Kullanıcı adına göre kullanıcı verileri"
call function 'BAPI_USER_GET_DETAIL'.

*---------------------------------------------------
"Tarih saat fonkiyonları"
call function 'fima_*'.

*--------------------------------------------------
"HR Personel resmi al"
DATA: lv_exist TYPE c,
      lt_connect_info LIKE toav0.
DATA: lv_length TYPE int4,
      ls_message TYPE bapiret2,
      lt_document LIKE TABLE OF tbl1024,
      gv_persnumber TYPE P_PERNR.
gv_persnumber = '00088844'.

CALL FUNCTION 'HR_IMAGE_EXISTS'
  EXPORTING
    p_pernr               = gv_persnumber
   p_tclas               = 'A'
   p_begda               = '18000101'
   p_endda               = '99991231'
  IMPORTING
    p_exists              = lv_exist
    p_connect_info        =
  EXCEPTIONS
    error_connectiontable = 1
    OTHERS                = 2.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
IF lv_exist EQ '1'.
  "Resim var
  DATA: url(255) TYPE c.
  CALL FUNCTION 'SCMS_DOC_URL_READ'
    EXPORTING
*      mandt                = SY-MANDT    " Client
      stor_cat             =  space   " Category
      crep_id              =   lt_connect_info-archiv_id  " Repository (Only Allowed if Category = SPACE)
      doc_id               =  lt_connect_info-arc_doc_id    " Document ID
      comp_id              = 'DATA'    " Component ID
      dp_url_only          = 'X'    " Only Return DataProvider URL
    IMPORTING
      url                  = url    " Generated URL
    .
*------------------------------------
"HR personel bilgilerini oku
call function 'HREIC_READ_EMPDATA'
*------------------------------------
"Excel xls dosyalarını sap yükle"
call function 'TEXT_CONVERT_XLS_TO_SAP'
*------------------------------------
"Mesaj sınıfındaki mesaj numaasının metnini döndür"
call FUNCTION 'MESSAGE_TEXT_BUILD'
    EXPORTING
      msgid               = messtab-msgid    " Message ID
      msgnr               = messtab-msgnr    " Number of message
      msgv1               = messtab-msgv1  " Parameter 1
      msgv2               = messtab-msgv2    " Parameter 2
      msgv3               = messtab-msgv3    " Parameter 3
      msgv4               = messtab-msgv4    " Parameter 4
    IMPORTING
      message_text_output =  gs_alv-mesaj   " Output message text
          .
*--------------------------------------
"bir değişken sayı integer mı kontrolü"
call function 'NUMERIC_CHECK'.
*-------------------------------------
"programın alt nesneleri"
call function 'WB_TREE_SELECT'
*------------------------------------
"program versiyonu üreten fonksiyon"
call function 'SVRS_AFTER_CHANGED_ONLINE_NEW'
*-----------------------------------
"sm30 bakım ekranını çağır"
call function 'VIEW_MAINTENANCE_CALL'
*----------------------------------
"ekrandaki alanların değerini anında okumak için"
call function 'DYNP_VALUES_READ'
*----------------------------------
"Ekrandaki alanları anında güncellemek için"
DATA lt_dynpfields  TYPE STANDARD TABLE OF dynpread .
CLEAR lt_dynpfields.
APPEND VALUE #( fieldname = |GS_PROJE_DETAY-{ lv_field }| fieldvalue = COND #( WHEN field EQ 'ENDUSTRI' THEN ls_hr04-endustri ELSE ls_hr04-endustri_en ) ) TO lt_dynpfields.
APPEND VALUE #( fieldname = |GS_PROJE_DETAY-{ lv_field2 }| fieldvalue = lv_text ) TO lt_dynpfields.
call FUNCTION 'DYNP_VALUES_UPDATE'
  EXPORTING
    dyname               = sy-repid
    dynumb               = sy-dynnr
  TABLES
    dynpfields           = lt_dynpfields
  .
"------------------------------------
"DYNP_VALUES_UPDATE alternatifi ve daha iyisi
"f4 helpte kullandığında sapıtabiliyor. Dikkat etmek gerekli
APPEND VALUE #( fieldname = 'GS_PROJE_DETAY-ENDUSTRI_EN' fieldvalue = ls_hr04-endustri_en ) to lt_dynpfields.
call FUNCTION 'DYNP_UPDATE_FIELDS'
  EXPORTING
    dyname                         = sy-repid    " Program Name
    dynumb                         = '2001'    " Screen Number
  TABLES
    dynpfields                     = lt_dynpfields    " Screen field value reset table
  EXCEPTIONS
    invalid_abapworkarea           = 1
    invalid_dynprofield            = 2
    invalid_dynproname             = 3
    invalid_dynpronummer           = 4
    invalid_request                = 5
    no_fielddescription            = 6
    undefind_error                 = 7
    others                         = 8
  .
*----------------------------------
"internal table html dönüşümü"
call function 'WWW_ITAB_TO_HTML_LAYOUT'
CALL FUNCTION 'WWW_ITAB_TO_HTML'
*---------------------------------
"SM62'den yaratılan eventı tetikleyen FM
CALL FUNCTION 'BP_EVENT_RAISE'
  EXPORTING
    eventid    = 'ZOZ_EVENT_TEST'.
*-----------------------------------
"kullanıcı favoriler menusune tcode ekle
call function 'GUI_ADD_TCODE_TO_FAVORITES'
*----------------------------------
"Tarih saat to Timestamp
call function 'IB_CONVERT_INTO_TIMESTAMP'.
*----------------------------------
"Timestamp to tarih saat
call function 'IB_CONVERT_FROM_TIMESTAMP'
*---------------------------------
"Email verification kontrolü
call function 'SX_INTERNET_ADDRESS_TO_NORMAL '
*---------------------------------
"Kullanıcı bilgisayar adını al computer name
call function ' TMP_GUI_GET_COMPUTERNAME'
*---------------------------------
"date: YYYYMMDD -> DD/MM/YYYY
call function 'CONVERSION_EXIT_GDATE_OUTPUT'
*---------------------------------
"read_text to text"
call function 'CONVERT_ITF_TO_STREAM_TEXT'
"-----------------------------------
"kullanıcı tarih formatını al user date formatınac
call function 'SLS_MISC_GET_USER_DATE_FORMAT'
"------------------------------------
"tarihi formata çevirir
call function 'SLS_MISC_CONVERT_TO_DATE'
*------------------------------------
"belirtilen tarihler aralığındaki tatilleri verir
call function 'HOLIDAY_GET'
"-----------------------------------"
"virgülden sonraki sıfırlaı siler decimal sıfırlar"
 call function 'FTR_CORR_SWIFT_DELETE_ENDZERO'
 "---------------------------------------"
"data element textini döndür header
call function 'DDIF_DOMA_GET'
*-----------------------------------------
"tooltipli ve metinli icon yarat"
CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name       = '@08@'    " Icon name  (Name from INCLUDE <ICON> )
      text       = ''    " Icon text (shown behind)
      info       = 'Tooltip Info'    " Quickinfo (if SPACE: standard quickinfo)
      add_stdinf = 'X'    " 'X': Qinfo.   ' ': No Qinfo, no std. Qinfo
    IMPORTING
      result     = lv_icon.
*----------------------------------------
"domain fixed valueyu oku"
call function 'DD_DOMVALUES_GET'
