CLASS demo_corresponding DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS demo_corresponding IMPLEMENTATION.
  METHOD main.
    TYPES: BEGIN OF line1,
             name   TYPE c LENGTH 50,
             age    TYPE i,
             salary TYPE p LENGTH 10 DECIMALS 2,
           END OF line1,
           BEGIN OF line2,
             name TYPE c LENGTH 50,
             age  TYPE i,
           END OF line2,
           BEGIN OF line3,
             name   TYPE c LENGTH 50,
             salary TYPE p LENGTH 10 DECIMALS 2,
           END OF line3.
    DATA: itab1 TYPE TABLE OF line1 WITH EMPTY KEY,
          itab2 TYPE TABLE OF line2 WITH EMPTY KEY,
          itab3 TYPE TABLE OF line3 WITH EMPTY KEY.
    DATA(out) = cl_demo_output=>new( ).
    itab1 = VALUE #(
          ( name = 'John' age = 32 salary = '3500')
          ( name = 'Mary' age = 33 salary = '3534') ).
    out->write( itab1 ).

    cl_abap_corresponding=>create(
      source            = itab1
      destination       = itab2
      mapping           = VALUE cl_abap_corresponding=>mapping_table(  )
      )->execute( EXPORTING source      = itab1
                  CHANGING  destination = itab2 ).
    out->write( itab2 ).

    cl_abap_corresponding=>create(
      source            = itab1
      destination       = itab2
      mapping           = VALUE cl_abap_corresponding=>mapping_table(
       ( level = 0 kind = 1 srcname = 'name' dstname = 'name' )
       ( level = 0 kind = 1 srcname = 'age' dstname = 'age' ) )
      )->execute( EXPORTING source      = itab1
                  CHANGING  destination = itab2 ).
    out->write( itab2 ).

    cl_abap_corresponding=>create(
      source            = itab1
      destination       = itab3
      mapping           = VALUE cl_abap_corresponding=>mapping_table(  )
      )->execute( EXPORTING source      = itab1
                  CHANGING  destination = itab3 ).
    out->write( itab3 ).

    out->display( ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo_corresponding=>main( ).


NAME  AGE  SALARY  
John  32   3500.0  
Mary  33   3534.0  

NAME  AGE  
John  32   
Mary  33   

NAME  AGE  
John  32   
Mary  33   

NAME  SALARY  
John  3500.0  
Mary  3534.0  