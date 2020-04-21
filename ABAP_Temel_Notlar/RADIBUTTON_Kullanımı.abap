----- HESAP MAKİNESİ ---

report ZHESAPMAKINESI.

DATA result type i.

PARAMETERS opt1 TYPE i.
PARAMETERS opt2 TYPE i.

PARAMETERS pa_yarat RADIOBUTTON GROUP grp1 USER-COMMAND abc. "radio butonun tek clickte tetiklemesi için

PARAMETERS add RADIOBUTTON GROUP grp1.
PARAMETERS substract RADIOBUTTON GROUP grp1.
PARAMETERS multiply RADIOBUTTON GROUP grp1.
PARAMETERS divide RADIOBUTTON GROUP grp1.

IF add = 'X'. " Radiobuttonun seçili olup olmadığını 'X' ile kontrol ediyoruz
	add opt2 to opt1.
ENDIF.

IF substract = 'X'.
	SUBSTRACT opt2 from opt1.
ENDIF.

IF multiply = 'X'.
	MULTIPLY opt1 by opt2.
ENDIF.

IF divide = 'X'.
	DIVIDE opt1 by opt2.
ENDIF.

WRITE: 'result: ' , opt1.