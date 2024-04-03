*&---------------------------------------------------------------------*
*&  Include           ZBEN_SEND_INFO_MAIL_TOP
*&---------------------------------------------------------------------*

FORM get_data.

*  SELECT SINGLE COUNT(*) FROM zben_period WHERE begin_date LE sy-datum
*                                            AND end_date GE sy-datum
*                                            AND active EQ 'X'.
*  IF sy-subrc EQ 0.
*    PERFORM send_mail.
*  ENDIF.

  SELECT SINGLE begin_date
    FROM zben_period
    INTO gv_begin_date WHERE begin_date LE sy-datum
                   AND end_date GE sy-datum
                   AND active EQ 'X'.

  IF sy-subrc EQ 0.
    PERFORM send_mail2.
  ENDIF.


ENDFORM.

FORM send_mail.

  DATA: send_request  TYPE REF TO cl_bcs,
        mailsubject   TYPE so_obj_des,
        mailtext      TYPE bcsy_text,
        document      TYPE REF TO cl_document_bcs,
        sender        TYPE REF TO cl_cam_address_bcs,
        recipient_to  TYPE REF TO cl_cam_address_bcs,
        recipient_cc  TYPE REF TO cl_cam_address_bcs,
        recipient_bcc TYPE REF TO cl_cam_address_bcs,
        bcs_exception TYPE REF TO cx_bcs.

  DATA: lv_begin_date(10).

  WRITE gv_begin_date TO lv_begin_date DD/MM/YYYY.

  TRY.

      send_request = cl_bcs=>create_persistent( ).

      mailsubject = 'Çarşı uygulaması açılmıştır.'.
      APPEND 'Sevgili Innovalılar!,' TO mailtext.
      APPEND 'Çarşı uygulaması '&&  lv_begin_date  && ' tarihinden itaberen kullanıma açılmıştır.' TO mailtext.

      document = cl_document_bcs=>create_document(
       i_type = 'RAW'
       i_text = mailtext
       i_subject = mailsubject ).
      send_request->set_document( document ).

      sender = cl_cam_address_bcs=>create_internet_address( 'sender@kodyaz.com' ).
      send_request->set_sender( sender ).

      recipient_to = cl_cam_address_bcs=>create_internet_address( 'recipient@yahoo.com' ).
      send_request->add_recipient( i_recipient = recipient_to ).

*      recipient_cc = cl_cam_address_bcs=>create_internet_address( 'cc@hotmail.com' ).
*      send_request->add_recipient( i_recipient = recipient_cc
*      i_copy = 'X' ).
*
*      recipient_bcc = cl_cam_address_bcs=>create_internet_address( 'bcc@gmail.com' ).
*      send_request->add_recipient( i_recipient = recipient_bcc
*       i_blind_copy = 'X' ).

      DATA(lv_sent_to_all) = send_request->send( ).
      IF lv_sent_to_all = 'X'.
        WRITE 'Email tüm alıcılara gönderildi.'.
      ELSE.
        WRITE 'Email tüm alıcılara gönderilemedi!'.
      ENDIF.

      COMMIT WORK.

    CATCH cx_bcs INTO bcs_exception.

      WRITE: 'Mail gönderilirken hatayla karşılaşıldı: Error Type', bcs_exception->error_type.

  ENDTRY.


ENDFORM.


FORM send_mail2.

*>>>>> added by ACETIN 11.10.2022 12:23:55

  DATA: lv_begin_date(10).

  WRITE gv_begin_date TO lv_begin_date DD/MM/YYYY.


  gs_alicibilgileri-receiver = 'cetinnanill@gmail.com'.
  gs_alicibilgileri-rec_type = 'U'.
  APPEND gs_alicibilgileri TO gt_alicibilgileri.

  gs_mailozellikleri-obj_langu = 'T'.
  gs_mailozellikleri-obj_name = 'Mesaj'.
  gs_mailozellikleri-obj_descr = 'Çarşı uygulaması açılmıştır.'.

  gs_mailicerik-line = '<P>'.
  APPEND gs_mailicerik TO gt_mailicerik.
  gs_mailicerik-line = 'Sevgili Innovalılar!,'.
  APPEND gs_mailicerik TO gt_mailicerik.
  gs_mailicerik-line = '</P>'.
  APPEND gs_mailicerik TO gt_mailicerik.

  gs_mailicerik-line = '<br>Çarşı uygulaması '&&  lv_begin_date  && ' tarihinden itaberen kullanıma açılmıştır.'.
  APPEND gs_mailicerik TO gt_mailicerik.


  gs_icerikbilgiler-transf_bin = space.
  gs_icerikbilgiler-head_start = 1.
  gs_icerikbilgiler-head_num = 0.
  gs_icerikbilgiler-body_start = 0.
  DESCRIBE TABLE gt_mailicerik LINES gs_icerikbilgiler-body_num.
  gs_icerikbilgiler-doc_type = 'HTM'.
  APPEND gs_icerikbilgiler TO gt_icerikbilgiler.

  DATA: lt_mailrecipients TYPE STANDARD TABLE OF somlrec90 WITH HEADER LINE,
        lt_mailtxt        TYPE STANDARD TABLE OF soli      WITH HEADER LINE,
        lt_attachment     TYPE STANDARD TABLE OF solisti1  WITH HEADER LINE,
        lt_mailsubject    TYPE sodocchgi1,
        lt_packing_list   TYPE STANDARD TABLE OF sopcklsti1 WITH HEADER LINE,
        gv_cnt            TYPE i.


*  <<<<< ended by ACETIN 11.10.2022 12:23:55

****Put in the Mail Contents
***
***  lt_mailtxt = 'Hi How are you'.      APPEND lt_mailtxt. CLEAR lt_mailtxt.
***  lt_mailtxt = 'Here is a test mail'. APPEND lt_mailtxt. CLEAR lt_mailtxt.
***  lt_mailtxt = 'Thanks'.              APPEND lt_mailtxt. CLEAR lt_mailtxt.

***
***  lt_mailsubject-obj_name     = 'MAILATTCH'.
***  lt_mailsubject-obj_langu    = sy-langu.
***  lt_mailsubject-obj_descr    = 'You have got mail'.
***  lt_mailsubject-sensitivty   = 'F'.
***  gv_cnt = lines( lt_attachment ).
***  lt_mailsubject-doc_size     = ( gv_cnt - 1 ) * 255 + strlen(
***  lt_attachment ).


  gt_icerikbilgiler-transf_bin  = space.
  gt_icerikbilgiler-head_start  = 1.
  gt_icerikbilgiler-head_num    = 0.
  gt_icerikbilgiler-body_start  = 1.
  gt_icerikbilgiler-body_num    = lines( lt_mailtxt ).
  gt_icerikbilgiler-doc_type    = 'RAW'.
  APPEND gt_icerikbilgiler. CLEAR gt_icerikbilgiler.

*Finally, send the mail out.
*That’s it. You are all done. Just call the function module to send the mail out.

  CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
    EXPORTING
      document_data              = gs_mailozellikleri
    TABLES
      packing_list               = gt_icerikbilgiler
      contents_bin               = lt_attachment
      contents_txt               = gt_mailicerik
      receivers                  = gt_alicibilgileri
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.
  IF sy-subrc EQ 0.
    COMMIT WORK.
    SUBMIT rsconn01 WITH mode = 'INT' AND RETURN.
  ENDIF.



ENDFORM.
