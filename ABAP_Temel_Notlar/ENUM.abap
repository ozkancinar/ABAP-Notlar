CLASS demo DEFINITION.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ENUM esize,
        size_s,
        size_m,
        size_l,
        size_xl,
      END OF ENUM esize.  

    TYPES:
      BEGIN OF ENUM size STRUCTURE s_size,
        s, m, l, xl, xxl,
      END OF ENUM size STRUCTURE s_size.
    
      CLASS-METHODS main
      IMPORTING size TYPE size.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    CASE size.
      WHEN s_size-s.
        WRITE 'S'.
      WHEN s_size-m.
      WHEN s_size-l.
        WRITE 'L'.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( demo=>s_size-s ).
  data size TYPE demo=>size.
  size = conv #( conv i( demo=>s_size-l ) + 1 ).
  try.
        size = conv #( 7 ).
    catch CX_SY_CONVERSION_NO_ENUM_VALUE .
        "enum nesnesi bulamazsa buraya düşer
    endtry.
  WRITE size.
"output:
"S XL

"enum tipleri hep int değerdir. Eğer özel bir tip tanımlamak istiyorsan base type kullanılır
TYPES:
    basetype TYPE c LENGTH 2,
    BEGIN OF ENUM tsize BASE TYPE basetype,
    size_i  VALUE IS INITIAL,
    size_s  VALUE 'S',
    size_m  VALUE 'M',
    size_l  VALUE 'L',
    size_xl VALUE 'XL',
    END OF ENUM tsize.


"enum tip detaylarını oku
DATA(size1) = VALUE demo=>tsize( ).

DATA(enum_descr) = CAST cl_abap_enumdescr(
cl_abap_typedescr=>describe_by_data( size1 ) ).

cl_demo_output=>new(
)->write_data( enum_descr->kind            "E, for elementary
)->write_data( enum_descr->type_kind       "k, new for enumerated type
)->write_data( enum_descr->base_type_kind  "I, the base type
)->write_data( enum_descr->members         "Table of constants and values
)->display( ).
"output
"NAME     VALUE  
"SIZE_I          
"SIZE_L   L      
"SIZE_M   M      
"SIZE_S   S      
"SIZE_XL  XL   