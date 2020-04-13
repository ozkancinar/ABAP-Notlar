CLASS demo DEFINITION.
  PUBLIC SECTION.
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
  WRITE size.
"output:
"S XL