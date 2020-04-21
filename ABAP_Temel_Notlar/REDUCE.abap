* Bir tablo içerinde 'XYZ' kriterine sahip değerlerin sayısı
DATA(lv_lines) = REDUCE i( INIT x = 0 FOR wa IN gt_itab
                    WHERE( F1 = ‘XYZ’ ) NEXT x = x + 1 ).

* Değerlerin toplamı
DATA(lv_sum) = REDUCE i( INIT x = 0 FOR wa IN itab NEXT x = x + wa ).
