DATA: t1 TYPE c LENGTH 10 VALUE 'We', 
      t2 TYPE c LENGTH 10 VALUE 'have', 
      t3 TYPE c LENGTH 10 VALUE 'all', 
      t4 TYPE c LENGTH 10 VALUE 'the', 
      t5 TYPE c LENGTH 10 VALUE 'time', 
      t6 TYPE c LENGTH 10 VALUE 'in', 
      t7 TYPE c LENGTH 10 VALUE 'the', 
      t8 TYPE c LENGTH 10 VALUE 'world', 
      result TYPE string. 

CONCATENATE t1 t2 t3 t4 t5 t6 t7 t8 
            INTO result. 
... 
CONCATENATE t1 t2 t3 t4 t5 t6 t7 t8 
            INTO result SEPARATED BY space. 

*>7.40 ---------------
data(lv_result) = |{ p_yil }-{ gt_data-versiyon+5(2) }|.
gv_versiyon = |{ lv_result }{ lv_vers }|.