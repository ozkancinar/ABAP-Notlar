
* types ile veri tiplerini belirleriz. Aşağıdaki örnekte mara-matnr tablo alanı tipinde matnr tipi oluşturuluyor
* Bu tipler ile değişken oluşturmak için data kullanılır
* Sonra bu data program içerisinde her yerde kullanılabilir

types: begin of ty_veri,
	matnr type mara-matnr,
	mtart type marc-mtart,
	maktx type makt-maktx,
       end of ty_veri.

data: gs_veri type ty_veri, " Structure
      gt_veri type table of ty_veri. " Table


"renaming suffix
TYPES: BEGIN OF sub_struc,
          col1 TYPE c LENGTH 10,
          col2 TYPE c LENGTH 10,
       END OF sub_struc.
DATA BEGIN OF struc.
INCLUDE TYPE: sub_struc AS comp1 RENAMING WITH SUFFIX _1,
              sub_struc AS comp2 RENAMING WITH SUFFIX _2,
              sub_struc AS comp3 RENAMING WITH SUFFIX _3,
              sub_struc AS comp4 RENAMING WITH SUFFIX _4,
              sub_struc AS comp5 RENAMING WITH SUFFIX _5.
DATA END OF struc.
"structure fields
"COL1_1  COL2_1  COL1_2  COL2_2  COL1_3  COL2_3  COL1_4  COL2_4  COL1_5  COL2_5  
"col1_1  col2_1  col1_2  col2_2  col1_3  col2_3  col1_4  col2_4  col1_5  col2_5  
