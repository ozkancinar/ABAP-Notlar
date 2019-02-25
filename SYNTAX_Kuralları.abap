------------- Doğru Kod Yazımları ---------------

'12.3' - Eğer bir nümerik ifade virgüllü ise tek tırnak içerisinde yazılır
'Hello' - Text ifadeleri tek tırnak içinde yazılır. Çift tırnak geçersizdir, kullanılamaz
'7E1' - Virgüllü sayılar tırnak içinde yazılır
'0A00' - Hexadecimal sayılar tek tırnak içerisine yazılır. Tüm karakterleri büyük harfli olmalıdır yoksa hata alınır

-------------------------------------------------


--------------- Değişken Tanımlama --------------

- Değişken tanımlandıktan sonra atanan değer 0''dır. C için boşluktur.
- Değişken tanımlamak için iki yöntem vardır data ve parameters

----- Data Kullanımı:

data <değişken Adı> [type t] [decimals d] [value 'xxx'].
veya
data <degisken Adı> like <başka değişken> [value 'xxx'].

data f1 (2) type c.
data f2 like f1.
data max_value type i value 100.
data cur_date type d value '19980211'.

data text_line type c length 40. " 40 karakterlik metin değişkeni oluşturur


----- Parameters kullanımı:

- Bir program çalıştırıldığında sistem ekranda input field,
  radiobutton gibi nesneler gösterecektir bunlara parameters denir.

parameters <parametreAdı>[(uzunluk)] [type t] [decimals d] ...

parameters p1 (2) type c.
parameters p2 like p1.
parameters max_value type i default 100.
parameters cur_date type d default '19980211' obligatory.


------ Constants kullanımı:

- Sabit değişken tanımlamak için kullanılır, başlangıç değeri girilmesi zorunludur
  program içerisinde değiştirilemez

constants <constname>[(uzunluk)] [type t] [decimals d] value 'xxx'.

constants c1 (2) type c value 'AA'.
constants c2 like c1 value 'BB'.
constants d-date like sy-datum value '19970305'.


--------------------------------------------------

-------- Clear Kullanımı --------
- Bir değişkenin değerini sıfırlar.

clear f1 with 'X',
		f2 with f1.
Çıktı:
	f1='XX' f2='XX'


---------------------------------

---------- Move ------------
-Bir değeri bir değişkenden diğerine taşır. Eşittir operatörüyle aynı işlemi yapar

move v1 to v2
veya
v2=v1

----------------------------

----------- move-corresponding ------------

- Data tipi veya boyutları uyuşmayan değişkenler arası taşıma yapar

move-corresponding v1 to v2.

----------------------------------------

------------ exit ---------------
- Sonraki işlemleri keser

report ztx1006.
write: / 'Hi'.
exit.
write: / 'There'.

--------- occurs -------------
- Occurs başlangıçta kaç satır olarak tanımlanacağını belirtir. Belirtilmezse dinamik olarak ayarlanır.
- Genelde değeri 0 olarak tanımlanır

data : itab type scarr occurs 0.

-------------------------------

	STRLEN()
- String uzunluğunu verir

length = STRLEN(cityform).

-------------------------
SKIP.
ULINE.

Bir paragraf ve çizgi ekler

--------------------------------
