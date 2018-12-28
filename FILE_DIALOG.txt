selection-screen begin of block b1 with frame title
  text-t01.

parameters p_file type char30.

selection-screen end of block b1.

at selection-screen on value-request for p_file.
  data: lv_ret type i.
  data: lr_mime_rep type ref to if_mr_api.

  data: lv_filename type string.
  data: lv_path     type string.
  data: lv_fullpath type string.
  data: lv_content  type xstring.
  data: lv_length   type  i.
  data: lv_rc type sy-subrc.
  data: lt_data type standard table of x255.

  data: lt_file type filetable,
        ls_file like line of lt_file.

  call method cl_gui_frontend_services=>file_open_dialog
    exporting
      window_title = 'select file'
      default_filename = '*.txt'
      default_extension = '*.txt'
    changing
      file_table              = lt_file
      rc                      = lv_ret
*      user_action             =
*      file_encoding           =
    exceptions
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      others                  = 5
    .

  read table lt_file into ls_file index 1.
  if sy-subrc eq 0.
     lv_filename = ls_file-filename.
  endif.

  cl_gui_frontend_services=>gui_upload(
    exporting
      filename                = lv_filename    " name of file
      filetype                = 'bin'
    importing
      filelength              =  lv_length   " file length
    changing
      data_tab                = lt_data    " transfer table for file contents
    exceptions
      others                  = 19 ).


  call function 'scms_binary_to_xstring'
    exporting
      input_length = lv_length
*    first_line   = 0
*    last_line    = 0
    importing
      buffer       = lv_content
    tables
      binary_tab   = lt_data
    exceptions
      failed       = 1
      others       = 2.


*********** SAVE DIALOG -------------------
"file_save_dialog open_dialog_save"

  data: lt_file type         filetable,
        ls_file like line of lt_file.
  data: ld_filename type string,
        ld_path     type string,
        ld_fullpath type string,
        ld_result   type i,
        gd_file     type c.

  data(lv_name) = gv_user && |_CV|.

  call method cl_gui_frontend_services=>file_save_dialog
    exporting
      window_title      = 'Dosya Kaydet'
*     default_extension = 'pdf'
      default_file_name = lv_name
      initial_directory = 'C:\'
    changing
      filename          = p_filename "o.pdf
      path              = p_path "yol
      fullpath          = ld_fullpath "yol+dosya
      user_action       = ld_result.

  if sy-subrc ne 0.
    exit.
  endif.