Create:

DATA lo_astverf_obj TYPE REF TO zcl_asset_verf_doc_header.
DATA lv_physinv TYPE zastverfh–physinv VALUE ‘1000000000’.
DATA lv_gjahr TYPE zastverfh–gjahr VALUE ‘2010’.

TRY .

lo_astverf_obj = zca_asset_verf_doc_header=>agent->create_persistent(
                            i_physinv = lv_physinv
                            i_gjahr = lv_gjahr ).

CALL METHOD lo_astverf_obj->set_crtdate( sy–datum ).
CALL METHOD lo_astverf_obj->set_crttime( sy–uzeit ).
CALL METHOD lo_astverf_obj->set_crtuname( sy–uname ).
CALL METHOD lo_astverf_obj->set_hstatus( ‘I’ ).

COMMIT WORK.

CATCH cx_os_object_existing.

ENDTRY.

"Update:

For updation everything remains the same only you need to replace the CREATE_PERSISTENT method with the GET_PERSISTENT  method and the exception will change from cx_os_object_existing to cx_os_object_not_found.

TRY.

lo_astverf_obj = zca_asset_verf_doc_header=>agent->get_persistent(

                           i_physinv = lv_physinv

                          i_gjahr = lv_gjahr ).

CALL METHOD lo_astverf_obj->set_crtdate( sy–datum ).
CALL METHOD lo_astverf_obj->set_crttime( sy–uzeit ).
CALL METHOD lo_astverf_obj->set_crtuname( sy–uname ).
CALL METHOD lo_astverf_obj->set_hstatus( ‘I’ ).

COMMIT WORK.

CATCH cx_os_object_not_found.

ENDTRY.

Read:

Code for Read is same as update, the only change is we will use GETTER methods instead of SETTER methods.

TRY .
lo_astverf_obj = zca_asset_verf_doc_header=>agent->get_persistent(

                           i_physinv = lv_physinv
                          i_gjahr = lv_gjahr ).

zastverfh–crtdate = lo_astverf_obj->get_crtdate( ).
zastverfh–crttime = lo_astverf_obj->get_crttime( ).
zastverfh–crtuname = lo_astverf_obj->get_crtuname( ).
zastverfh–hstatus = lo_astverf_obj->get_hstatus( ).

CATCH cx_os_object_not_found.

ENDTRY.
Delete:

For deletion use method DELETE_PERSISTENT and exception CX_OS_OBJECT_NOT_EXISTING.



TRY .
zca_asset_verf_doc_header=>agent->delete_persistent(

     i_physinv = lv_physinv
    i_gjahr = lv_gjahr ).

COMMIT WORK.

CATCH cx_os_object_not_existing.

ENDTRY.

Read Multiple Records:

Here instead of using the GET_PERSISTENT method we use the GET_PERSISTENT_BY_QUERY method, which will return us the list of objects. Each
record in the database will correspond to an object in the internal table.



DATA lt_obj TYPE osreftab.
DATA ls_obj TYPE osref.


TRY .
    lt_obj = zca_asset_verf_doc_header=>agent->if_os_ca_persistency~get_persistent_by_query(
                  i_par1 = ‘5%’
                  i_query = cl_os_system=>get_query_manager( )->create_query(
                                    i_filter = ‘PHYSINV LIKE PAR1’ ) ).


    IF lines( lt_obj ) <> 0.

      LOOP AT lt_obj INTO ls_obj.

        lo_astverf_obj ?= ls_obj.


        zastverfh–physinv = lo_astverf_obj->get_physinv( ).
        zastverfh–gjahr = lo_astverf_obj->get_gjahr( ).
        zastverfh–crtdate = lo_astverf_obj->get_crtdate( ).
        zastverfh–crttime = lo_astverf_obj->get_crttime( ).
        zastverfh–crtuname = lo_astverf_obj->get_crtuname( ).
        zastverfh–hstatus = lo_astverf_obj->get_hstatus( ).

        WRITE: / zastverfh–physinv,
        zastverfh–gjahr,
        zastverfh–crtdate,
        zastverfh–crttime,
        zastverfh–crtuname,
        zastverfh–hstatus.

      ENDLOOP.

    ENDIF.

  CATCH cx_os_object_not_found.

ENDTRY.
