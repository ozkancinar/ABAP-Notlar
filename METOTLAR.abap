*Json to data
cl_fdt_json=>json_to_data( EXPORTING  iv_json = w_result
                              CHANGING   ca_data = result_tab ).
*-----------------------------------------
"Abap veri tipleri ile ilgili işlemler
cl_abap_typedescr

"seçilen dosya gerçekten var mı kontrolü
cl_gui_frontend_services=>file_exist()
