"internal tableları konsol veya ekran üzerinde göstermeni sağlar
"birden fazla internal tableı aynı anda göstermek istiyorsan aşağıdaki kullanım
DATA(out) = cl_demo_output=>new( ).
out->write( itab1 ).
out->write( itab2 ).
out->display( ).

"tek bir internal table göstermek için
cl_demo_output=>display(
  EXPORTING
    data = itab
*    name = 
).