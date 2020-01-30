POPUP MESAJLAR

-----------------------------------
Popup mesaj göstermek

* Standart uyarı popup
call function 'POPUP_TO_INFORM'
         exporting
              titel = text-i01
              txt1  = text-i02
              txt2  = text-i03
              txt3  = text-i04
              txt4  = text-i05.

DATA : lt_valuetab TYPE STANDARD TABLE OF ly_valuetab,
       ls_valuetab TYPE ly_valuetab,
       lv_choise   TYPE sy-tabix.

CALL FUNCTION 'POPUP_WITH_TABLE_DISPLAY' "Popup mesaj göstermek için
  EXPORTING
    endpos_col         = 80
    endpos_row         = 5
    startpos_col       = 1
    startpos_row       = 1
    titletext          = 'Select from the list'
  IMPORTING
    choise             = lv_choise
  TABLES
    valuetab           = lt_valuetab
  EXCEPTIONS
    break_off          = 1
    OTHERS             = 2.

------------------------------------
Popup Select Mesajı

TYPE-POOLS: slis.

DATA: lt_outtab   TYPE spfli OCCURS 0,
      ls_selfield TYPE slis_selfield,
      lv_exit(1).

START-OF-SELECTION.
  SELECT *
    FROM spfli INTO TABLE lt_outtab.

  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title                 = 'Select from the list'
      i_selection             = 'X'
      i_zebra                 = ' '
      i_screen_start_column   = 0
      i_screen_start_line     = 0
      i_screen_end_column     = 0
      i_screen_end_line       = 0
      i_scroll_to_sel_line    = 'X'
      i_tabname               = 'LT_OUTTAB'
      i_structure_name        = 'SPFLI'
    IMPORTING
      es_selfield             = ls_selfield
      e_exit                  = lv_exit
    TABLES
      t_outtab                = lt_outtab

  WRITE ls_selfield-tabindex.

""--------------------------------------------
bapiret2 tablosunu popup şeklinde gösteren fonksiyon
call function 'RSCRMBW_DISPLAY_BAPIRET2'
"bapiret2 tablosu popup şeklinde göster
call function 'C14Z_MESSAGES_SHOW_AS_POPUP'
"---------------------------------------------
Giriş alanı olan popup input popup

data: ivals  type table of sval.
data: xvals  type sval.
xvals-tabname   = 'BSIK'.
xvals-fieldname = 'BUDAT'.
xvals-value = sy-datum.
append xvals to ivals.

CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
*      NO_VALUE_CHECK        = ' '
      POPUP_TITLE           = 'Kayıt Tarihi?'
*      START_COLUMN          = '5'
*      START_ROW             = '5'
*    IMPORTING
*      RETURNCODE            =
    TABLES
      FIELDS                = ivals
   EXCEPTIONS
     ERROR_IN_FIELDS       = 1
     OTHERS                = 2
            .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
dönen değer = ivals-VALUE

*-----------------------------------------
Popup Yes-No Question - Evet Hayır Mesajı - Evet Hayır Sorusu

DATA lv_answer(1).
DATA : lt_parameter TYPE STANDARD TABLE OF spar,
       ls_parameter TYPE spar.

ls_parameter-param = 'M1'.
ls_parameter-value = '— Text —'.
APPEND ls_parameter TO lt_parameter.

CALL FUNCTION 'POPUP_TO_CONFIRM'
  EXPORTING
    titlebar                = 'Warning'
    diagnose_object         = 'BZAL_MSG1'
    text_question           = 'Do you want to continue?'
    display_cancel_button   = 'X'
    start_column            = 30
    start_row               = 10
  IMPORTING
    answer                  = lv_answer
  TABLES
    parameter               = lt_parameter.

Evet = 1 - Hayır = 2
------------------------------------------
Popup Kaydedilsin mi?

DATA : lv_titel(70),
       lv_answer(1).

lv_titel = 'Title'.

CALL FUNCTION 'POPUP_TO_CONFIRM_DATA_LOSS'
  EXPORTING
    defaultoption       = 'Y'
    titel               = lv_titel
    start_column        = 25
    start_row           = 6
  IMPORTING
    answer              = lv_answer.

  WRITE lv_answer.

Evet = J Hayır = N Iptal = A

-------------------------------------------
"Hata POPUP. is_error boş ise uyarı mesajı gösterir
"MESSAGE E103 INTO data(msg).
call FUNCTION 'FC_POPUP_ERR_WARN_MESSAGE'
  EXPORTING
    popup_title  = 'Hata'(007)
    is_error     = 'X'
    message_text = msg.
*------------------------------------------
"radio button şeklinde seçim imkanı sunan popup
data lt_spopli type standard table of spopli .

call FUNCTION 'POPUP_TO_DECIDE_LIST'
  EXPORTING
    textline1          = 'Varyant Seçiniz'    " first text line
    titel              = 'Varyant Seçimi'    " Popup header line
  TABLES
    t_spopli           = lt_spopli    " Possible Selections
.
*-----------------------------------------
"popup text editör
call function 'CATSXT_SIMPLE_TEXT_EDITOR'
*-----------------------------------------
"metin girilebilen popup
call function 'TXW_TEXTNOTE_EDIT'
*-----------------------------------------
"ay seçim popupı"
CALL FUNCTION 'POPUP_TO_SELECT_MONTH'
