* Bir tablo içerisinde başka bir tablonun 
* içerisindeki verilerle belli bir kritere göre filtreleme yapar ve başka bir tabloya kaydeder.
TYPES: BEGIN OF ty_filter,
         cityfrom TYPE spfli–cityfrom,
         cityto   TYPE spfli–cityto,
         f3       TYPE i,
       END OF ty_filter,
       ty_filter_tab TYPE HASHED TABLE OF ty_filter
                     WITH UNIQUE KEY cityfrom cityto.
DATA: lt_splfi TYPE STANDARD TABLE OF spfli.

SELECT * FROM spfli APPENDING TABLE lt_splfi.
DATA(lt_filter) = VALUE ty_filter_tab( f3 = 2
                          ( cityfrom = ‘NEW YORK’  cityto  = ‘SAN FRANCISCO’ )
                          ( cityfrom = ‘FRANKFURT’ cityto  = ‘NEW YORK’ )  ).

DATA(lt_myrecs) = FILTER #( lt_splfi IN lt_filter
                                  WHERE cityfrom = cityfrom 
                                    AND cityto = cityto ).
