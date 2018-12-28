
* types ile veri tiplerini belirleriz. Aşağıdaki örnekte mara-matnr tablo alanı tipinde matnr tipi oluşturuluyor
* Bu tipler ile değişken oluşturmak için data kullanılır
* Sonra bu data program içerisinde her yerde kullanılabilir

types: begin of ty_veri,
	matnr type mara-matnr,
	mtart type marc-mtart,
	maktx type makt-maktx,
       end of ty_veri.

data: gs_veri type ty_veri, " Structure
      gt-veri type table of ty_veri with header line. " Table

* --------------------------------------------------------
* Data'da oluşturulan değişkene atılan verileri silmek
* -------------------------------------------------------

refresh gt_veri. " Data'da oluşturulan table'ın verilerini siler
veya
clear gt_veri[]. " Data'da oluşturulan table'ın verilerini siler
clear gs_matnr. " Data'da oluşturulan structure'ın verilerini siler
