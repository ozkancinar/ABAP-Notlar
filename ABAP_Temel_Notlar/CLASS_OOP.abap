CLASS cl_person DEFINITION.
  PUBLIC SECTION.
    TYPES ty_packed TYPE p LENGTH 4 DECIMALS 2.
    METHODS set_height IMPORTING im_height TYPE ty_packed.
    METHODS set_weight IMPORTING im_weight TYPE ty_packed.
    METHODS set_bmi.
    METHODS get_bmi RETURNING VALUE(r_bmi) TYPE ty_packed.
  PRIVATE SECTION.
    DATA: bmi TYPE i,
    height TYPE i,
    weight TYPE i.
ENDCLASS.

CLASS cl_person IMPLEMENTATION.
  METHOD set_height.
    height = im_height.
  ENDMETHOD.

  METHOD set_weight.
    weight = im_weight.
  ENDMETHOD.

  METHOD set_bmi.
    bmi = height / weight.
  ENDMETHOD.

  METHOD get_bmi.
    r_bmi = bmi.
  ENDMETHOD.

ENDCLASS.

DATA john TYPE REF TO cl_person.
DATA mark TYPE REF TO cl_person.

START-OF-SELECTION.
  CREATE OBJECT john.
  john->set_height( im_height = 165 ).
  john->set_weight( im_weight = 50 ).
  john->set_bmi( ).
  WRITE : / 'John’sBMIis', john->get_bmi( ).
  CREATE OBJECT mark.
  mark->set_height( im_height = 175 ).
  mark->set_weight( im_weight = 80 ).
  mark->set_bmi( ).
  WRITE : / 'Mark’sBMIis', mark->get_bmi( ).
  IF john->get_bmi( ) GT mark->get_bmi( ).
    WRITE :/'JohnisfatterthanMark'.
  ELSE.
    WRITE :/'MarkisfatterthanJohn'.
  ENDIF.

  DATA(ozkan) = NEW cl_person( ).
  ozkan->set_height( 180 ).
  ozkan->set_weight( 70 ).
  ozkan->set_bmi( ).

*****************Kalıtım**************************
CLASS printer DEFINITION.
  PUBLIC SECTION.
    METHODS print.
ENDCLASS.
CLASS printer IMPLEMENTATION.
  METHOD print.
    WRITE 'document printed'.
  ENDMETHOD.
ENDCLASS.

CLASS printer_with_counter DEFINITION INHERITING FROM printer.
  PUBLIC SECTION.
    DATA counter TYPE i.
    METHODS constructor IMPORTING count TYPE i.
    METHODS print REDEFINITION.
ENDCLASS.
CLASS printer_with_counter IMPLEMENTATION.
  METHOD constructor.
    CALL METHOD super->constructor. "the superclass constructor must be called first in the implementation of the constructor method even if there’s no constructor defined in the superclass.
    counter = count.
  ENDMETHOD.
  METHOD print.
    counter = counter + 1.
    CALL METHOD super->print.
  ENDMETHOD.
ENDCLASS.

CLASS multi_copy_printer DEFINITION INHERITING FROM printer_with_counter.
  PUBLIC SECTION.
    DATA copies TYPE i.
    METHODS set_copies IMPORTING copies TYPE i.
    METHODS print REDEFINITION.
ENDCLASS.
CLASS multi_copy_printer IMPLEMENTATION.
  METHOD set_copies.
    me->copies = copies.
  ENDMETHOD.
  METHOD print.
    DO copies TIMES.
      CALL METHOD super->print.
    ENDDO.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA oref TYPE REF TO multi_copy_printer.
  CREATE OBJECT oref EXPORTING count = 0.
  oref->set_copies( 5 ).
  oref->print( ).
*****************/Kalıtım*************************


*****************Static - Instance**************************

CLASS cl_person DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA height TYPE i. "Static attribute
    DATA weight TYPE i."Instance attribute
    METHODS get_bmi EXPORTING bmi TYPE i."Instance method
    METHODS constructor"Instance constructor
        IMPORTING name TYPE char20.
    CLASS-METHODS set_height"Static Method
        IMPORTING height TYPE i.
    CLASS-METHODS class_constructor. "Static Constructor
ENDCLASS.
CLASS cl_person IMPLEMENTATION.
  METHOD class_constructor.
  ENDMETHOD.
  METHOD constructor.
  ENDMETHOD.
  METHOD get_bmi.
  ENDMETHOD.
  METHOD set_height.
  ENDMETHOD.
ENDCLASS.
DATA oref TYPE REF TO cl_person. "Defining reference object
DATA v_bmi TYPE i.

START-OF-SELECTION.
*Accessing static attributes and methods using the selector "=>"
*with class reference
  cl_person=>height = 165.
  CALL METHOD cl_person=>set_height
    EXPORTING
      height = 165.
*Instantiating th ereference object and accessing the instance
*attributes andmethodsusing theselector"->"withobject
*reference.
  CREATE OBJECT oref
    EXPORTING
      name = 'JOHN'.
  oref->weight = 50.

  CALL METHOD oref->get_bmi
    IMPORTING
      bmi = v_bmi.

*****************/Static - Instance*************************

*****************Events**************************

CLASS cl_events_demo DEFINITION.
  PUBLIC SECTION.
    EVENTS double_click
           EXPORTING
                VALUE(column) TYPE i
                VALUE(row) TYPE i.
    CLASS-EVENTS right_click.
    METHODS trigger_event.
    METHODS on_double_click FOR EVENT double_click OF cl_events_demo
            IMPORTING
               column
               row
               sender.
    METHODS on_right_click FOR EVENT right_click OF cl_events_demo.
ENDCLASS.
CLASS cl_events_demo IMPLEMENTATION.
  METHOD trigger_event.
    RAISE EVENT double_click
        EXPORTING
        column = 4
        row = 5.
    RAISE EVENT right_click.
  ENDMETHOD.
  METHOD on_double_click.
    WRITE: /'Double click event triggered at column',column,
    'and row',row.
  ENDMETHOD.
  METHOD on_right_click.
    WRITE: / 'Right click event triggered'.
  ENDMETHOD.
ENDCLASS.
DATA oref TYPE REF TO cl_events_demo.

START-OF-SELECTION.
  CREATE OBJECT oref.
  SET HANDLER oref->on_double_click FOR oref."Instanceevent
  SET HANDLER oref->on_right_click. "Handler forStaticevent
  CALL METHOD oref->trigger_event( ).

*****************/Events*************************

*****************Public Protected Private**************************
CLASS cl_encapsulation_demo DEFINITION.
  PUBLIC SECTION.
    METHODS print.
    METHODS set_copies IMPORTING copies TYPE i.
    METHODS get_counter EXPORTING counter TYPE i.
  PROTECTED SECTION.
    METHODS reset_counter.
  PRIVATE SECTION.
    DATA copies TYPE i.
    DATA counter TYPE i.
    METHODS reset_copies.
ENDCLASS.
CLASS cl_encapsulation_demo IMPLEMENTATION.
  METHOD print.
    "Business logicgoeshere
  ENDMETHOD.
  METHOD set_copies.
    "Business logicgoeshere
    me->copies = copies.
  ENDMETHOD.
  METHOD get_counter.
    "Business logicgoeshere
    counter = me->counter.
  ENDMETHOD.
  METHOD reset_counter.
    "Business logicgoeshere
    CLEAR counter.
  ENDMETHOD.
  METHOD reset_copies.
    "Business logicgoeshere
    CLEAR copies.
  ENDMETHOD.
ENDCLASS.
CLASS cl_encapsulation_sub_demo DEFINITION INHERITING FROM cl_encapsulation_demo.
  PROTECTED SECTION.
    METHODS reset_counter redefinition.
ENDCLASS.
CLASS cl_encapsulation_sub_demo IMPLEMENTATION.
  METHOD reset_counter.
    super->reset_counter( ).
* super->reset_copies( ). "gives syntax error
  ENDMETHOD.
ENDCLASS.
*****************/Public Protected Private*************************

*****************Friends**************************
CLASS c1 DEFINITION DEFERRED.
CLASS c2 DEFINITION DEFERRED.
CLASS cl_encapsulation_demo DEFINITION FRIENDS c1 c2.
  PUBLIC SECTION.
    METHODS print.
    METHODS set_copies IMPORTING copies TYPE i.
    METHODS get_counter EXPORTING counter TYPE i.
  PROTECTED SECTION.
    METHODS reset_counter.
  PRIVATE SECTION.
    DATA copies TYPE i.
    DATA counter TYPE i.
    METHODS reset_copies.
ENDCLASS.
CLASS cl_encapsulation_demo IMPLEMENTATION.
  METHOD print.
    "Business logicgoeshere
  ENDMETHOD.
  METHOD set_copies.
    "Business logicgoeshere
    me->copies = copies.
  ENDMETHOD.
  METHOD get_counter.
    "Business logicgoeshere
    counter = me->counter.
  ENDMETHOD.
  METHOD reset_counter.
    "Business logicgoeshere
    CLEAR counter.
  ENDMETHOD.
  METHOD reset_copies.
    "Business logicgoeshere
    CLEAR copies.
  ENDMETHOD.
ENDCLASS.

CLASS c1 DEFINITION.
  PUBLIC SECTION.
    METHODS get_counter IMPORTING counter TYPE i.
  PROTECTED SECTION.
    DATA counter TYPE i.
ENDCLASS.

CLASS c1 IMPLEMENTATION.
  METHOD get_counter.
    DATA oref TYPE REF TO cl_encapsulation_demo.
    CREATE OBJECT oref.
    oref->reset_counter( ).
    oref->counter = counter.
  ENDMETHOD.
ENDCLASS.

CLASS c2 DEFINITION.
  PUBLIC SECTION.
    METHODS set_copies IMPORTING copies TYPE i.
  PRIVATE SECTION.
    DATA copiestypei.
ENDCLASS.

CLASS c2 IMPLEMENTATION.
  METHOD set_copies.
    DATA oref TYPE REF TO cl_encapsulation_demo.
    CREATE OBJECT oref.
    oref->reset_copies( ).
    oref->copies = copies.
  ENDMETHOD.
ENDCLASS.

CLASS cl_encapsulation_sub_demo DEFINITION INHERITING FROM cl_encapsulation_demo.
  PROTECTED SECTION.
    METHODS reset_counter REDEFINITION.
ENDCLASS.
CLASS cl_encapsulation_sub_demo IMPLEMENTATION.
  METHOD reset_counter.
    super->reset_counter( ).
*    super->reset_copies( ). "Gives syntaxerror
  ENDMETHOD.
ENDCLASS.
*****************/Friends*************************

*****************Hiding İmplementation**************************

CLASS cl_notification_api DEFINITION.
  PUBLIC SECTION.
    METHODS set_message IMPORTING im_message TYPE string.
    METHODS display_notification.
  PRIVATE SECTION.
    DATA message TYPE string.
    METHODS filter_message RETURNING VALUE(boolean) TYPE boolean.
    METHODS check_count RETURNING VALUE(boolean) TYPE boolean.
    METHODS check_status RETURNING VALUE(boolean) TYPE boolean.
ENDCLASS.
CLASS cl_notification_api IMPLEMENTATION.
  METHOD set_message.
    message = im_message.
  ENDMETHOD.

  METHOD display_notification.
    IF me->filter_message( ) EQ abap_true OR
    me->check_count( ) EQ abap_true OR
    me->check_status( ) EQ abap_true.
      WRITE message.
    ELSE.
      CLEAR message.
    ENDIF.
  ENDMETHOD.

  METHOD filter_message.
*Filtering logicgoeshereandthe parameter "Boolean"issetto
*abap_true orabap_falseaccordingly.
  ENDMETHOD.

  METHOD check_count.
*Logic tochecknumberofmessages goeshereandtheparameter
*"Boolean" issettoabap_true orabap_falseaccordingly.
  ENDMETHOD.

  METHOD check_status.
*Logic tocheckuserpersonal setting goeshereandtheparameter
*"Boolean" issettoabap_true orabap_falseaccordingly.
  ENDMETHOD.
ENDCLASS.
*Code inthecallingprogram.
START-OF-SELECTION.
  DATA notify TYPE REF TO cl_notification_api.
  CREATE OBJECT notify.
  notify->set_message( im_message = 'My App notification').
  notify->display_notification( ).

*****************/Hiding İmplementation*************************

*****************AbStract Class**************************

CLASS cl_student DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS tuition_fee ABSTRACT.
ENDCLASS.
CLASS cl_commerce_student DEFINITION INHERITING FROM cl_student.
  PUBLIC SECTION.
    METHODS tuition_fee REDEFINITION.
ENDCLASS.
CLASS cl_commerce_student IMPLEMENTATION.
  METHOD tuition_fee.
    "Logic to calculate tuition fee for commerce students goes here
  ENDMETHOD.
ENDCLASS.
CLASS cl_science_student DEFINITION INHERITING FROM cl_student.
  PUBLIC SECTION.
    METHODS tuition_fee redefinition. "Abstract sınıfı kalıtım olarak aldığı için bu metodu override(redefinition) yapmak zorunda
ENDCLASS.
CLASS cl_science_student IMPLEMENTATION.
  METHOD tuition_fee.
    "Logic tocalculatetuitionfeefor sciencestudentsgoeshere
  ENDMETHOD.
ENDCLASS.

*****************/AbStract Class*************************

*****************Static - Dynamic Types**************************
CLASS cl_parent DEFINITION.
  PUBLIC SECTION.
    METHODS meth1.
    METHODS meth2.
ENDCLASS.
CLASS cl_parent IMPLEMENTATION.
  METHOD meth1.
    WRITE 'In method 1 of parent'.
  ENDMETHOD.
  METHOD meth2.
    WRITE 'In method2 of parent'.
  ENDMETHOD.
ENDCLASS.
CLASS cl_child DEFINITION INHERITING FROM cl_parent.
  PUBLIC SECTION.
    METHODS meth2 REDEFINITION.
    METHODS meth3.
ENDCLASS.
CLASS cl_child IMPLEMENTATION.
  METHOD meth2.
    WRITE 'In method 2 of child'.
  ENDMETHOD.
  METHOD meth3.
    WRITE 'In method 3 of child'.
  ENDMETHOD.
ENDCLASS.
DATA parent TYPE REF TO cl_parent.
DATA child TYPE REF TO cl_child.

START-OF-SELECTION.
  CREATE OBJECT parent.
  CREATE OBJECT child.
  parent->meth2( ).
  parent = child. "Artık parent nesnesi yok. Paren nesnesinin pointerı da child ile aynı. Bellekte aynı yeri gösteriyor. Parent bellekten silindi
  parent->meth2( ). "Artık child
Çıktı: In method 2 of parent In method 2 of child
*****************/Static - Dynamic Types*************************

*****************Wide Casting**************************
CLASS cl_parent DEFINITION.
  PUBLIC SECTION.
    METHODS meth1.
    METHODS meth2.
ENDCLASS.
CLASS cl_parent IMPLEMENTATION.
  METHOD meth1.
    WRITE 'In method1 of parent'.
  ENDMETHOD.
  METHOD meth2.
    WRITE 'In method2 of parent'.
  ENDMETHOD.
ENDCLASS.
CLASS cl_child DEFINITION INHERITING FROM cl_parent.
  PUBLIC SECTION.
    METHODS meth2 REDEFINITION.
    METHODS meth3.
ENDCLASS.
CLASS cl_child IMPLEMENTATION.
  METHOD meth2.
    WRITE 'In method2 of child'.
  ENDMETHOD.
  METHOD meth3.
    WRITE 'In method3 of child'.
  ENDMETHOD.
ENDCLASS.
DATA parent TYPE REF TO cl_parent.
DATA child TYPE REF TO cl_child.

START-OF-SELECTION.
  CREATE OBJECT parent.
  CREATE OBJECT child.
  child ?= parent."Results in run time error dump
  child->meth2( ).

*---------------------------------------------------------------------*
CLASS cl_parent DEFINITION.
  PUBLIC SECTION.
    METHODS meth1.
    METHODS meth2.
ENDCLASS.
CLASS cl_parent IMPLEMENTATION.
  METHOD meth1.
    WRITE 'In method1 of parent'.
  ENDMETHOD.
  METHOD meth2.
    WRITE 'In method2 of parent'.
  ENDMETHOD.
ENDCLASS.
CLASS cl_child1 DEFINITION INHERITING FROM cl_parent.
  PUBLIC SECTION.
    METHODS meth2 REDEFINITION.
    METHODS meth3.
ENDCLASS.
CLASS cl_child1 IMPLEMENTATION.
  METHOD meth2.
    WRITE 'In method2 of child1'.
  ENDMETHOD.
  METHOD meth3.
    WRITE 'In method3 of child1'.
  ENDMETHOD.
ENDCLASS.
CLASS cl_child2 DEFINITION INHERITING FROM cl_child1.
  PUBLIC SECTION.
    METHODS meth2 REDEFINITION.
    METHODS meth3 REDEFINITION.
    METHODS meth4.
ENDCLASS.
CLASS cl_child2 IMPLEMENTATION.
  METHOD meth2.
    WRITE 'In method2 of child2'.
  ENDMETHOD.
  METHOD meth3.
    WRITE 'In method3 of child2'.
  ENDMETHOD.
  METHOD meth4.
    WRITE 'In method4 of child2'.
  ENDMETHOD.
ENDCLASS.
DATA parent TYPE REF TO cl_parent.
DATA child1 TYPE REF TO cl_child1.
DATA child2 TYPE REF TO cl_child2.

START-OF-SELECTION.
  CREATE OBJECT parent.
  CREATE OBJECT child1.
  CREATE OBJECT child2.
  parent = child2.
  child1 ?= parent.
  child1->meth2( ). "Çıktı: In method2 of child2
*****************/Wide Casting*************************

*****************Dynamic Call Method Bining**************************
CLASS cl_student DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS tuition_fee ABSTRACT.
    METHODS get_fee ABSTRACT RETURNING VALUE(fee_paid) TYPE boolean.
  PROTECTED SECTION.
    DATA fee_paid TYPE boolean.
ENDCLASS.

CLASS cl_commerce_student DEFINITION INHERITING FROM cl_student.
  PUBLIC SECTION.
    METHODS tuition_fee REDEFINITION.
    METHODS get_fee REDEFINITION.
ENDCLASS.

CLASS cl_commerce_student IMPLEMENTATION.
  METHOD tuition_fee.
    "logic tocalculatetuitionfeefor commerce studentsgoeshere
    "IF feepaid.
    fee_paid = abap_true.
  ENDMETHOD.
  METHOD get_fee.
    fee_paid = me->fee_paid.
  ENDMETHOD.
ENDCLASS.

CLASS cl_science_student DEFINITION INHERITING FROM cl_student.
  PUBLIC SECTION.
    METHODS tuition_fee REDEFINITION.
    METHODS get_fee REDEFINITION.
ENDCLASS.
CLASS cl_science_student IMPLEMENTATION.
  METHOD tuition_fee.
    "logic tocalculatetuitionfeefor science studentsgoeshere
    "IF feepaid.
    fee_paid = abap_true.
  ENDMETHOD.
  METHOD get_fee.
    fee_paid = me->fee_paid.
  ENDMETHOD.
ENDCLASS.

CLASS cl_admission DEFINITION.
  PUBLIC SECTION.
    METHODS set_student IMPORTING im_student TYPE REF TO cl_student.
    METHODS enroll.
  PRIVATE SECTION.
    DATA admit TYPE boolean.
ENDCLASS.

CLASS cl_admission IMPLEMENTATION.
  METHOD set_student.
    IF im_student->get_fee( ) EQ abap_true.
      admit = abap_true.
    ENDIF.
  ENDMETHOD.
  METHOD enroll.
    IF admit EQ abap_true.
*Perform thestepstoenroll
    ENDIF.
  ENDMETHOD.
ENDCLASS.

DATA: commerce_student TYPE REF TO cl_commerce_student,
      science_student TYPE REF TO cl_science_student,
      admission TYPE REF TO cl_admission.

START-OF-SELECTION.
  CREATE OBJECT: commerce_student,
                 science_student,
                 admission.
  CALL METHOD commerce_student->tuition_fee.
  CALL METHOD admission->set_student( EXPORTING im_student = commerce_student ) .
  CALL METHOD admission->enroll.
  CALL METHOD science_student->tuition_fee.
  CALL METHOD admission->set_student( EXPORTING im_student = science_student ).
  CALL METHOD admission->enroll.
*****************/Dynamic Call Method Bining*************************

*****************Interface**************************
INTERFACE if_student.
  DATA course TYPE char10.
  METHODS meth1.
  EVENTS enrolled.
ENDINTERFACE.
CLASS cl_science DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_student.
    METHODS student_event for EVENT if_student~enrolled OF cl_science.
ENDCLASS.
CLASS cl_science IMPLEMENTATION.
  METHOD if_student~meth1.
  ENDMETHOD.
  METHOD student_event.

  ENDMETHOD.
ENDCLASS.
*****************/Interface*************************
*****************Interface Alias**************************
 Bazen arayüzlerin metotlarının isimleri çok uzun olabilir. Bu durumda alias kullanabiliriz
INTERFACE if_student.
  DATA course TYPE char10.
  METHODS meth1.
  EVENTS enrolled.
ENDINTERFACE.
CLASS cl_science DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_student.
    ALIASES m1 FOR if_student~meth1.
ENDCLASS.
CLASS cl_science IMPLEMENTATION.
  METHOD m1.
  ENDMETHOD.
ENDCLASS.
DATA science TYPE REF TO cl_science.

START-OF-SELECTION.
  CREATE OBJECT science.
  science->m1( ). "Alias
*****************/Interface Alias*************************

*****************Interface Ignore*************************
"Eğer bir interface içindeki metodun override olması durumunu zorunluluktan çıkarmak istiyorsak default ignore kullanılır
INTERFACE scary_behavior.
METHODS:  scare_small_children,
          sells_mortgages DEFAULT FAIL,
          hide_under_bed DEFAULT IGNORE,
          is_fire_breather DEFAULT IGNORE
                RETURNING rf_yes_it_is TYPE abap_bool.
ENDINTERFACE. "Scary Behavior
*****************/Interface Ignore*************************

*****************Exception Handling**************************

CLASS lcl_material_data DEFINITION .
  PUBLIC SECTION.
    CLASS-METHODS get_description
                      IMPORTING
                          im_matnr TYPE matnr
                          im_spras TYPE spras
                      EXPORTING
                        ex_maktx TYPE maktx
                      EXCEPTIONS
                        invalid_material. "Raised when material is invalid
ENDCLASS.
*****************/Exception Handling*************************

*****************Local Exception Class*************************
CLASS cx_wrong_size DEFINITION INHERITING FROM cx_static_check.
 ENDCLASS.

class lcl_main definition.
"... methods raising cx_wrong_size
endclass
*****************/Local Exception Class*************************

****************** Type Of Exception *************************
DATA number TYPE string.
  out = cl_demo_output=>new( ).
  cl_demo_input=>request( CHANGING field = number ).
  TRY.
      my_sqrt( number ).
    CATCH cx_root INTO DATA(exc).
      CASE TYPE OF exc.
        WHEN TYPE cx_sy_arithmetic_error.
          out->display( 'Arithmetic error' ).
        WHEN TYPE cx_sy_conversion_error.
          out->display( 'Conversion error' ).
        WHEN OTHERS.
          out->display( 'Other error' ).
      ENDCASE.
  ENDTRY.
**************** /Type Of Exception ***************************

*****************Local Exception Class**************************
CLASS lcx_no_material DEFINITION INHERITING FROM cx_static_check.
ENDCLASS.
CLASS lcx_no_material IMPLEMENTATION.
ENDCLASS.
*****************/Local Exception Class*************************

****************Read Only Variable***********************************
CLASS /clean/message_severity DEFINITION PUBLIC CREATE PRIVATE FINAL.
  PUBLIC SECTION.
    CLASS-DATA:
      warning TYPE REF TO /clean/message_severity READ-ONLY,
      error   TYPE REF TO /clean/message_severity READ-ONLY.
  " ...
ENDCLASS.

"An immutable is an object that never changes after its construction.
"For this kind of object consider using public read-only attributes instead of getter methods.
"use
CLASS /clean/some_data_container DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        a TYPE i
        b TYPE c
        c TYPE d.
    DATA a TYPE i READ-ONLY.
    DATA b TYPE c READ-ONLY.
    DATA c TYPE d READ-ONLY.
ENDCLASS.

"instead of
CLASS /dirty/some_data_container DEFINITION.
  PUBLIC SECTION.
    METHODS get_a ...
    METHODS get_b ...
    METHODS get_c ...
  PRIVATE SECTION.
    DATA a TYPE i.
    DATA b TYPE c.
    DATA c TYPE d.
ENDCLASS.
*******************/Read Only Variable********************************

*******************/Raise Raising********************************
METHODS exclude_materials changing materials          TYPE tt_materials
                          RAISING cx_axt_data_not_found.

METHOD exclude_materials.
  if materials is INITIAL.
      RAISE EXCEPTION TYPE cx_axt_data_not_found.
  endif.
ENDMETHOD.

"duplicate object - copy object without reference
SYSTEM-CALL OBJMGR CLONE scope_with_ref TO new_object.
"interface
if_os_clone