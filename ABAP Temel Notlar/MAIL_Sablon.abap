CONSTANTS:
  gc_raw TYPE char03 VALUE 'RAW'.

DATA:
      gc_mlrec TYPE so_obj_nam,
      "Dokümanın, klasörün ya da dağıtım listesinin adı
      gv_sent_to_all TYPE os_boolean, "boolean
      gv_email TYPE adr6-smtp_addr,"e-posta adresi
      gv_subject TYPE so_obj_des, "kısa içerik tanımı
      lt_body  TYPE srm_t_solisti1, "body table
      ls_body  TYPE solisti1, "body line
      gc_subject TYPE so_obj_des VALUE 'Mail From ABAP',
      lv_length      TYPE so_obj_len,
      lv_count TYPE i,
      gr_send_request TYPE REF TO cl_bcs,
      gr_recipient TYPE REF TO if_recipient_bcs,
      gr_sender TYPE REF TO cl_sapuser_bcs,
      gr_bcs_exception TYPE REF TO cx_bcs,
      gr_document TYPE REF TO cl_document_bcs
      .

selection-screen begin of block blck with frame title text-001.

  PARAMETERS p_alici TYPE adr6-smtp_addr.
  PARAMETERS p_header type so_obj_des.

selection-screen end of block blck.

START-OF-SELECTION.
  PERFORM send_mail.
end-of-SELECTION.

FORM SEND_MAIL .
  TRY .
      PERFORM set_recipent.
      PERFORM create_mail.
      PERFORM mail_send.

      "Exception handling
    CATCH cx_bcs into gr_bcs_exception.
      WRITE: / 'Error',
      / gr_bcs_exception->error_type.
  ENDTRY.
ENDFORM.                    " SEND_MAIL

FORM SET_RECIPENT .
  "create send request
  "kalıcı gönderim talebi oluştur
  gr_send_request = cl_bcs=>create_persistent( ).

  "email FROM..
  gr_sender = cl_sapuser_bcs=>create( sy-uname ).
  "add sender to send request
  CALL METHOD gr_send_request->set_sender
    EXPORTING
      i_sender = gr_sender.

  "EMAIL TO
  gv_email = p_alici.
  gr_recipient = cl_cam_address_bcs=>create_internet_address( gv_email ).
  "Add recipient to send request
  CALL METHOD gr_send_request->add_recipient
    EXPORTING
      i_recipient = gr_recipient
      i_express   = 'X'.
ENDFORM.                    " SET_RECIPENT

FORM CREATE_MAIL .
  data lv_line TYPE String.

  DEFINE add_line.
    clear: lv_line, ls_body-line.
    lv_line = &1.
    condense lv_line.

    concatenate lv_line &2 into lv_line separated by space.

    condense lv_line.
    ls_body-line = lv_line.
    append ls_body to lt_body.
  END-OF-DEFINITION.

  "Email Header
  gc_subject = p_header.

  "EMAIL BODY
  add_line '<html>' ''.
  add_line '<head>' ''.
  add_line '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>' ''.
  add_line '</head>' ''.
  add_line '<body align="center">' ''.
  add_line '<h3>Merhaba' p_alici.
  add_line ',</h3>' ''.
  add_line '<div>' ''.
  add_line '<p>İyi Günler.<p><hr/>' ''.
  add_line '<em>Bu mesaj' sy-uname.
  add_line 'tarafından' p_alici.
  add_line '&apos;a gönderilmiştir <br></em>' ''.
  add_line '<em>Bu mail size ait değilse lütfen' ''.
  add_line '<a href="http://www.cozumevi.com">cozumevi.com</a> adresini ziyaret ediniz</em>' ''.
  add_line '<p style="font-size: 10px; text-decoration: underline;">Gönderim saati:' ''.
  add_line sy-datum sy-uzeit.
  add_line '</p>' ''.
  add_line '</div>' ''.
  add_line '</body>' ''.
  add_line '</html>' ''.
ENDFORM.                    " CREATE_MAIL

FORM MAIL_SEND .

  DESCRIBE TABLE lt_body LINES lv_length.
  lv_length = lv_length  * 255 .

  gr_document = cl_document_bcs=>create_document(
    i_type = 'HTM'
    i_text = lt_body
    i_length = lv_length
    I_LANGUAGE   = SY-LANGU
    i_subject = gc_subject ).

  "Add document to send request
  CALL METHOD gr_send_request->set_document( gr_document ).

  "Send email
  CALL METHOD gr_send_request->send(
    EXPORTING
      i_with_error_screen = 'X'
    RECEIVING
      result              = gv_sent_to_all ).

  IF gv_sent_to_all = 'X'.
    WRITE 'Email başarıyla gönderildi'.
  ENDIF.

  "Commit to send email
  COMMIT WORK.

ENDFORM.                    " MAIL_SEND
