case ok_code100.
    when 'BACK' or 'EXIT' or 'CANCEL'.
      perform exit_program.

FORM exit_program .
  LEAVE PROGRAM. " or leave to screen 0. bir geri demek

ENDFORM.     

