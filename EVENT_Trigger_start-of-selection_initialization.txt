Temel Eventlar:

initialization : programda en önce çalışan kısım
start-of-selection : ikinci çalışan kısım. parametreler varsa onları ekrana döken, açılışta yapılacak işlemleri yapan kısım
end-of-selection : en son çalışan kısım

at selection-screen : kullanıcı aktif ekranda bir eylem gerçekleştirdiğinde çalıştırılır. Örneğin kullanıcı bir butona tıkladığında veya bir fonksiyon çalıştırdığında tetiklenir. 
at user-command : Pushbuttonlar gibi kullanıcı etkileşimlerinde kullanmakta çok etkili ve faydalıdır.

report ztx1702.
data f1 type i value 1.

end-of-selection.
	write: / '3. f1 = ', f1.

start-of-selection.
	write: / '2. f1 = ', f1.
	f1 = 99.

initialization.
	write: / '1. f1 = ', f1.
	add 1 to f1.

Çıktı:
1. f1 = 1
2. f1 = 2
3. f1 = 99

EVENT'dan Çıkma Komutları

check : O an bulunduğu eventtan çıkar ve sonraki eventa devam eder
exit : check ile aynı özelliğe sahiptir
stop : Bulunduğu eventtan çıkar ve end-of-selection'a gider. at-selection-screen output, top-of-page ve end-of-page'de kullanma.

------------------------------------------------------
AT SELECTION-SCREEN & SELECTION-SCREEN

SELECTION-SCREEN BEGIN OF BLOCK block1 WITH frame title text-100.
  SELECTION-SCREEN PUSHBUTTON 10(20) text-002 USER-COMMAND eng1.
  SELECTION-SCREEN PUSHBUTTON 50(20) text-003 USER-COMMAND grm1.
SELECTION-SCREEN END OF BLOCK block1.

AT SELECTION-SCREEN.
    CASE sy-ucomm.
      WHEN 'ENG1'.
        MESSAGE 'İngilizce Seçildi' TYPE 'S'.
      WHEN 'GRM1'.
        MESSAGE 'Almanca Seçildi' TYPE 'S'.
      WHEN OTHERS.
    ENDCASE.

-----------------------------------------------------
SELECTION SCREEN SECENEKLERI

selection-screen comment /1(50) comm1 - This will place a comment on the selection screen.
selection-screen uline-This will place an underline on the screen at a specified location for a specified length.

selection-screen position-This is a very useful tool that specifies a comment for the next field parameter on the screen. This comes in
handy for selection-options as well as parameters.

selection-screen begin-of-line and selection-screen end-of-line-All input fields defined between these two statements
are placed next to each other on the same line.

selection-screen skip n-This statement creates a blank line for as many lines for n lines on the selection screen.