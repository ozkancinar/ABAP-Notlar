PARAMETERS: p_city(100) LOWER CASE.

data: gd_ucomm type sy-ucomm.

parameters pa_yarat radiobutton group grp1 user-command abc. "radio butonun tek clickte tetiklemesi için

selection-screen begin of block blckyarat with frame.
select-options so_yarat for vbak-erdat modif id gr1. "gruplandır
selection-screen end of block blckyarat .
SELECT-OPTIONS s_aufnr FOR afko-aufnr matchcode object ASH_ORDE. "Search help ile tanımla"
SELECT-OPTIONS S_DATE FOR afko-ftrms .

SELECT-OPTIONS so_yonet for vbpa-kunnr no INTERVALS NO-EXTENSION. "parametre gibi gösterir"
parameters pa_diger radiobutton group grp1.

selection-screen begin of block blckdiger with frame.

select-options so_diger for vbak-erdat obligatory modif id gr2 .

selection-screen comment 1(20) text-002.
** Label
selection-screen comment 5(20) text-003.

selection-screen end of block blckdiger .

initialization.
  pa_yarat = 'X'.

start-of-selection.
  message so_diger-low type 'S'.

end-of-selection.

at selection-screen output.
"Radio buton click yakala ve görünürlüğünü değiştir
  loop at screen.
    if screen-group1 = 'GR1' .
      if pa_yarat eq 'X'.
        screen-active = '1'.
      else.
        screen-active = '0'.
      endif.
      modify screen.
    elseif screen-group1 = 'GR2'.
      screen-required = '1'. "Zorunlu yapar
      if pa_diger eq 'X'.
        screen-active = '1'.
      else.
        screen-active = '0'.
      endif.
      modify screen.

    endif.
  endloop.

  *&---------------------------------------------------------------------*
  *& Report  ZCOMPLEX_SELECTION_SCREEN
  *&
  *&---------------------------------------------------------------------*
  *& Block tipinde selection screen
  *& Radiobutton
  *  Checkbox

  *&---------------------------------------------------------------------*

  REPORT  ZCOMPLEX_SELECTION_SCREEN.

  TABLES: pgmi, sscrfields.

  DATA: BEGIN OF ipgmi occurs 0,
    werks type pgmi-werks,
    prgrp type pgmi-prgrp,
    nrmit TYPE pgmi-nrmit,
    END OF ipgmi.

  DATA: wa_ipgmi LIKE LINE OF ipgmi.

  "Selection screen 1
  SELECTION-SCREEN BEGIN OF block b1 WITH FRAME TITLE
    text-t01.
  " Giriş yapılacak parametrelerin tanımlanması
  SELECT-OPTIONS: prgrp for pgmi-prgrp OBLIGATORY MODIF ID OB. " doldurulması zorunlu alan
  PARAMETERS: werks LIKE marc-werks DEFAULT '3110',
              " Define radiobuttons
              s1 RADIOBUTTON GROUP g1,
              s2 RADIOBUTTON GROUP g1,
              s3 RADIOBUTTON GROUP g1.

  selection-SCREEN end OF BLOCK b1.

  "Selection screen 2
  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-t02.
  "Define radiobuttons
  PARAMETERS: s4 RADIOBUTTON GROUP g2,
              s5 RADIOBUTTON GROUP g2.

  SELECTION-SCREEN END OF BLOCK b2.

  SELECTION-SCREEN BEGIN OF block b3 with FRAME TITLE text-t03.
  "define radiobuttons
  PARAMETERS: s6 RADIOBUTTON GROUP g3 USER-COMMAND radyo,
              s7 RADIOBUTTON GROUP g3.

  " Define checkboxes
  SELECTION-SCREEN BEGIN OF LINE.
  PARAMETERS p_ch1 as CHECKBOX MODIF ID sl.

  " define screen text
  SELECTION-SCREEN COMMENT 3(20) text-001 MODIF ID s1.
  PARAMETERS p_ch2 as CHECKBOX MODIF ID s1.
  SELECTION-SCREEN COMMENT 27(20) text-002 MODIF ID s1.
  PARAMETERS p_ch3 as CHECKBOX MODIF ID s1.
  SELECTION-SCREEN COMMENT 51(20) text-003 MODIF ID s1.
  SELECTION-SCREEN end of line.

  SELECTION-SCREEN end of BLOCK b3.

  SELECTION-SCREEN:
    BEGIN OF SCREEN 500 AS WINDOW TITLE title,
      PUSHBUTTON 2(10)  but1 USER-COMMAND cli1,
      PUSHBUTTON 12(30) but2 USER-COMMAND cli2
                             VISIBLE LENGTH 10,
    END OF SCREEN 500.

  AT SELECTION-SCREEN.
    CASE sscrfields.
      WHEN 'CLI1'.
        ...
      WHEN 'CLI2'.
        ...
    ENDCASE.

  START-OF-SELECTION.
    title  = 'Push button'.
    but1 = 'Button 1'.

  TYPE-POOLs icon.
  data functxt TYPE smp_dyntxt.

  " add button to screen
  SELECTION-SCREEN: FUNCTION KEY 1,
                    FUNCTION KEY 2.

  INITIALIZATION.
    s7 = 'X'.
    functxt-icon_id = icon_alarm.
    functxt-quickinfo = 'alarm'.
    functxt-icon_text = 'alarm'.
    sscrfields-functxt_01 = functxt.
    sscrfields-functxt_02 = 'Button 2'.

    " Üstte bulunan butona tıklanmaları yakala
    AT SELECTION-SCREEN.
      CASE sscrfields-ucomm.
        WHEN 'FC01'.
          MESSAGE 'Alarm Button' TYPE 'I'.
        WHEN 'FC02'.
          MESSAGE 'Button 2' TYPE 'I'.
        WHEN OTHERS.
      ENDCASE.
    AT SELECTION-SCREEN OUTPUT.
      PERFORM checkradio.

    START-OF-SELECTION.
      PERFORM getdata.
  *&---------------------------------------------------------------------*
  *&      Form  CHECKRADIO
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM CHECKRADIO .
    loop AT SCREEN.
      " Nesneyi göster veya gizle
      IF s6 = 'X'.
        IF screen-group1 = 'SL'.
           screen-active = 1.
        ENDIF.
        ELSEIF s7 = 'X'.
          IF screen-group1 = 'SL'.
            screen-active = 0.
          ENDIF.
      ENDIF.

      " Display blue color parameters
      IF screen-group1 = 'OB'.
        screen-intensified = '1'.
      ENDIF.

      " Disable an object
      IF screen-name = 'S5'.
        screen-input = 0.
      ENDIF.

      MODIFY SCREEN.
    ENDLOOP.
  ENDFORM.                    " CHECKRADIO
  *&---------------------------------------------------------------------*
  *&      Form  GETDATA
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM GETDATA .
    " add code to select data

  ENDFORM.                    " GETDATA


**********************************************************************
"Selection screen 1
SELECTION-SCREEN BEGIN OF block b1 WITH FRAME TITLE
  text-t01.
" Giriş yapılacak parametrelerin tanımlanması
SELECT-OPTIONS: prgrp for pgmi-prgrp OBLIGATORY MODIF ID OB. " doldurulması zorunlu alan
PARAMETERS: werks LIKE marc-werks DEFAULT '3110',
            " Define radiobuttons
            s1 RADIOBUTTON GROUP g1,
            s2 RADIOBUTTON GROUP g1,
            s3 RADIOBUTTON GROUP g1.

selection-SCREEN end OF BLOCK b1.

"Selection screen 2
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-t02.
"Define radiobuttons
PARAMETERS: s4 RADIOBUTTON GROUP g2,
            s5 RADIOBUTTON GROUP g2.

SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF block b3 with FRAME TITLE text-t03.
"define radiobuttons
PARAMETERS: s6 RADIOBUTTON GROUP g3 USER-COMMAND radyo,
            s7 RADIOBUTTON GROUP g3.

" Define checkboxes
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_ch1 as CHECKBOX MODIF ID sl.

" define screen text
SELECTION-SCREEN COMMENT 3(20) text-001 MODIF ID s1.
PARAMETERS p_ch2 as CHECKBOX MODIF ID s1.
SELECTION-SCREEN COMMENT 27(20) text-002 MODIF ID s1.
PARAMETERS p_ch3 as CHECKBOX MODIF ID s1.
SELECTION-SCREEN COMMENT 51(20) text-003 MODIF ID s1.
SELECTION-SCREEN end of line.

SELECTION-SCREEN end of BLOCK b3.

TYPE-POOLs icon.
data functxt TYPE smp_dyntxt.

" add button to screen
SELECTION-SCREEN: FUNCTION KEY 1,
                  FUNCTION KEY 2.

INITIALIZATION.
  s7 = 'X'.
  functxt-icon_id = icon_alarm.
  functxt-quickinfo = 'alarm'.
  functxt-icon_text = 'alarm'.
  sscrfields-functxt_01 = functxt.
  sscrfields-functxt_02 = 'Button 2'.

  " Üstte bulunan butona tıklanmaları yakala
  AT SELECTION-SCREEN.
    CASE sscrfields-ucomm.
      WHEN 'FC01'.
        MESSAGE 'Alarm Button' TYPE 'I'.
      WHEN 'FC02'.
        MESSAGE 'Button 2' TYPE 'I'.
      WHEN OTHERS.
    ENDCASE.
  AT SELECTION-SCREEN OUTPUT.
    PERFORM checkradio.

  START-OF-SELECTION.
    PERFORM getdata.

FORM CHECKRADIO .
  loop AT SCREEN.
    " Nesneyi göster veya gizle
    IF s6 = 'X'.
      IF screen-group1 = 'SL'.
         screen-active = 1.
      ENDIF.
      ELSEIF s7 = 'X'.
        IF screen-group1 = 'SL'.
          screen-active = 0.
        ENDIF.
    ENDIF.

    " Display blue color parameters
    IF screen-group1 = 'OB'.
      screen-intensified = '1'.
    ENDIF.

    " Disable an object
    IF screen-name = 'S5'.
      screen-input = 0.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.                    " CHECKRADIO

*--------------------------------------------------------------------------*
* Button on selection screen
TABLES: vbap, klah, SSCRFIELDS.

SELECT-OPTIONS: so_plant for vbap-werks, "plant
                so_class for klah-clint. "class

SELECTION-SCREEN: FUNCTION KEY 1,
                  FUNCTION KEY 2,
                  FUNCTION KEY 3.

INITIALIZATION.

  data: lv_fcntext TYPE smp_dyntxt.

  clear lv_fcntext.
  lv_fcntext-text = 'Görüntüle'.
  sscrfields-functxt_01 = lv_fcntext.

  clear lv_fcntext.
  lv_fcntext-text = 'Değiştir'.
  sscrfields-functxt_02 = lv_fcntext.

  clear lv_fcntext.
  lv_fcntext-text = 'Yarat'.
  sscrfields-functxt_03 = lv_fcntext.

at SELECTION-SCREEN OUTPUT.
  set PF-STATUS 'STATUS100'.

at SELECTION-SCREEN .
  CASE sy-ucomm.
    WHEN 'FC01'.
      MESSAGE 'Görüntüle' TYPE 'S'.
    WHEN 'FC02'.
      MESSAGE 'Düzenle' TYPE 'S'.
    WHEN 'FC03'.
      MESSAGE 'Yarat' TYPE 'S'.
    WHEN OTHERS.
  ENDCASE.
