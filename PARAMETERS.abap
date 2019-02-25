** Pushbutton
SELECTION-SCREEN PUSHBUTTON 50(20) text-003 USER-COMMAND grm1.
** Radiobutton
PARAMETERS add RADIOBUTTON GROUP grp1.
PARAMETERS substract RADIOBUTTON GROUP grp1.

** Checkbox
SELECTION-SCREEN COMMENT 3(20) text-001.
PARAMETERS p_ch2 as CHECKBOX default 'X'.

** Integer input
PARAMETERS opt1 TYPE i.
** Nesne tipinde 
PARAMETERS werks LIKE marc-werks DEFAULT '3110'.

PARAMETERS: p_city(100) LOWER CASE.  "küçük harf"

PARAMETERS pa_skodu TYPE text10 MEMORY ID skodu.
PARAMETERS pa_matnr TYPE matnr MEMORY ID MATN. "başka bir ekranda doldurulan matnr alanınına yazılan ifadenin
                                              "gelmesi sağlanır