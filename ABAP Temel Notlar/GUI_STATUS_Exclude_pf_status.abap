data: gt_extab type slis_t_extab.

module status_2001 output.

  call function 'AUTHORITY_CHECK'
    exporting
*      new_buffering       = 3    " Auth. object in user master maintenance
      user                = SY-UNAME    " Name of the user to be checked
      object              = 'ZSLV'    " Name of the object to be checked
      field1              = 'ZSLV_PY'    " An authorization field to the obje
      field2              = 'ZSLV_MUH'
    exceptions
      user_dont_exist     = 1
      user_is_authorized  = 2
      user_not_authorized = 3
      user_is_locked      = 4
      others              = 5
    .
  if sy-subrc <> 0.
*   message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    clear: gt_extab[].
    append 'ISIMSIZ_TR' to gt_extab.
    append 'ISIMSIZ_EN' to gt_extab.

  endif.

  set pf-status 'PF2001' excluding gt_extab.
  set titlebar  'TTL2001'.

endmodule.                 " STATUS_1001  OUTPUT
