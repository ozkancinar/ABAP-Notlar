"Bir programı çağımak için submit kullanılır"
PARAMETERS pa_001 TYPE char10.
data: lv_val1 TYPE char30.
data: lt_seltab TYPE TABLE OF rsparams,
      ls_seltab LIKE LINE OF lt_seltab.

"çağırılan program içerisinde kullanılacak alanların doldurulması"
clear ls_seltab.
ls_seltab-selname = 'PA_001'.
ls_seltab-kind = 'P'.
ls_seltab-low = pa_001.
APPEND ls_seltab TO lt_seltab.

SUBMIT zaa_test2 AND RETURN with SELECTION-TABLE lt_seltab. "programı çalıştırıp geri gelir"

submit rfitemgl with SELECTION-TABLE lt_seltab and RETURN. 

submit rfitemgl via SELECTION-SCREEN and RETURN. "Çağırılan programdaki ilgili alanları doldurur
                                                 "çalıştırmaz kullanıcıdan giriş bekler

***************
SELECT-OPTIONS so_saknr FOR ska1-saknr.

LOOP AT so_saknr.
  CLEAR ls_seltab.
  ls_seltab-selname = 'SD_SAKNR'.
  ls_seltab-kind = 'S'. "select options olduğu için S oldu
  ls_seltab-low = so_saknr-low.
  ls_seltab-high = so_saknr-high.
  ls_seltab-option = so_saknr-option.
  ls_seltab-sign   = so_saknr-sign.
  APPEND ls_seltab TO lt_seltab.
ENDLOOP.

SUBMIT rfitemgl VIA SELECTION-SCREEN and RETURN