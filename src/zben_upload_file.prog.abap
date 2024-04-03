*&---------------------------------------------------------------------*
*& Report ZBEN_UPLOAD_FILE
*&---------------------------------------------------------------------*
* Project           : Betta Stok Transfer Onay
*----------------------------------------------------------------------*
* Program           : ZBEN_UPLOAD_FILE
* Development ID    :
* Jira ID           :
* Module            : HR
* Module Consultant : Kübra BILBEY / Rana KIRDAL
* ABAP Consultant   : Zekeriya Turan
* ———————————————————————–———–———–———–
* Title             : TT Çarşı Logo&PDF Yükleme
* Description       : TT Çarşı Logo&PDF Yükleme
*&---------------------------------------------------------------------*
REPORT zben_upload_file.


INCLUDE zben_upload_file_top.
INCLUDE zben_upload_file_f01.


INITIALIZATION.

*----------------------------------------------------------------------*
*AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  CASE sy-ucomm.

    WHEN 'ONLI'.
      IF  r_jpg EQ 'X'  AND p_bnft IS INITIAL.
        MESSAGE e002(zben).
      ENDIF.

      PERFORM auth_check.

  ENDCASE.

AT SELECTION-SCREEN OUTPUT.

  IF r_pdf EQ 'X'.
    LOOP AT SCREEN.
      IF screen-group1 EQ 'CHR'.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    p_file = 'C:\TEST.pdf'.
  ELSEIF r_jpg EQ 'X'.
    LOOP AT SCREEN.
      IF screen-group1 EQ 'CHR'.
        screen-active = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    p_file = 'C:\TEST.jpg'.
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  PERFORM open_dialog.

START-OF-SELECTION.
  IF  gv_rc NE 1.
    MESSAGE s003(zben) DISPLAY LIKE 'E'.
  ELSE.
*    CASE 'X'.
*      WHEN r_uplo.
        PERFORM save_image.
*      WHEN r_down.
*        PERFORM download_file.
*      WHEN OTHERS.
*    ENDCASE.
  ENDIF.

END-OF-SELECTION.



*SELECTION-SCREEN BEGIN OF BLOCK IN2 WITH FRAME TITLE TEXT-t02.
*PARAMETERS: p_encode RADIOBUTTON GROUP rb1 USER-COMMAND grb1 DEFAULT 'X',
*            p_decode RADIOBUTTON GROUP rb1.
*SELECTION-SCREEN END OF BLOCK IN2.
*
*CASE 'X'.
**  WHEN p_encode.

*DATA: lt_dosya TYPE filetable.
*DATA: lv_action TYPE i.
*DATA: lv_rc TYPE i.
** Dosya seçim diyaloğu
** tek dosya okuyacağımız için ilk satır lazım bize
*DATA: lv_filesize TYPE w3param-cont_len.
*DATA: lv_filetype TYPE w3param-cont_type.
*DATA: lt_bin_data TYPE w3mimetabtype.
*data:gv_filename type string,
*     gv_path     type string,
*     gv_fullpath type string.

* call method cl_gui_frontend_services=>file_save_dialog
*    exporting
*      window_title      = 'Select file'
*      default_extension = 'jpg'
*      file_filter       = '*.jpg\|*.jpg'
*    changing
*      filename          = gv_filename
*      path              = gv_path
*      fullpath          = gv_fullpath.


*cl_gui_frontend_services=>file_open_dialog( EXPORTING
*                                              file_filter = |png (*.jpeg)\|*.jpg\|*.png\|{ cl_gui_frontend_services=>filetype_all }|
*
*                                            CHANGING
*                                              file_table  = lt_dosya
*                                              rc          = lv_rc
*                                              user_action = lv_action ).


*copy_data_to_ref( EXPORTING is_data = ls_file CHANGING cr_data = er_entity ).


*     CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
*      EXPORTING
*        text   = lv_bin_data
*      IMPORTING
*        buffer = lv_xstring
*      EXCEPTIONS
*        failed = 1
*        OTHERS = 2.
*
**Find the number of bites of xstring
*
*      lv_len  = xstrlen( lv_xstring ).
*
*      CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
*        EXPORTING
*          input  = lv_xstring
*        IMPORTING
*          output = lv_base64.
*
*  WHEN p_decode.
*
**Convert Base64 string to XString.
*
*    CALL FUNCTION 'SCMS_BASE64_DECODE_STR'
*      EXPORTING
*        INPUT          = lv_bin_data
*     IMPORTING
*       OUTPUT         = lv_xstring
*     EXCEPTIONS
*       FAILED         = 1
*       OTHERS         = 2.
*
**Convert Text to Binary
*    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*      EXPORTING
*        buffer        = lv_xstring
*      IMPORTING
*        output_length = lv_len
*      TABLES
*        binary_tab    = lt_content[].
*
**Convert Binary to String
*    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
*      EXPORTING
*        input_length = lv_len
*      IMPORTING
*        text_buffer  = lv_string
*      TABLES
*        binary_tab   = lt_content[]
*      EXCEPTIONS
*        failed       = 1
*        OTHERS       = 2.
*ENDCASE.
*
**Write the converted string to Screen.
*CASE 'X'.
*  WHEN p_decode.
*    write lv_string.
*  WHEN p_encode.
*    write lv_base64.
*  WHEN OTHERS.
*ENDCASE.
*&---------------------------------------------------------------------*
*&      Form  SAVE_IMAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*cl_gui_frontend_services=>gui_upload( EXPORTING
*                                          filename   = p_file "|{ lt_dosya[ 1 ]-filename }|
*                                          filetype   = 'BIN'
*                                        IMPORTING
*                                          filelength = lv_filesize
*                                        CHANGING
*                                          data_tab   = lt_bin_data ).
*
*
*DATA(lv_bin_data) = cl_bcs_convert=>solix_to_xstring( it_solix = lt_bin_data ).
**Convert string to xstring
*
*DATA: ls_ben TYPE zben_bnft_image.
*DATA: ls_file TYPE zben_s_files.
*DATA: ls_return     TYPE bapiret2.
*
*ls_ben-catalog_id = 'AKR'.
*ls_ben-benefit_id = 17.
*ls_ben-file_name  = 'BP_IMAGE'.
*ls_ben-mime_type  = 'image/png'.
*ls_ben-value      = lv_bin_data.
*ls_ben-create_user = sy-uname.
*ls_ben-create_date = sy-datum.
*ls_ben-create_user = sy-uzeit.
**MODIFY zben_bnft_image FROM ls_ben.
*
*MOVE-CORRESPONDING ls_ben TO ls_file.
*
*zcl_ben_file_handler=>upload_file(
*   IMPORTING
*     es_return     = ls_return
*     CHANGING
*     cs_file       = ls_file ) .
*
*IF ls_return-type = 'E'.
*  DATA(lo_exception) = NEW /iwbep/cx_mgw_busi_exception( ).
*  lo_exception->get_msg_container( )->add_message_from_bapi( is_bapi_message = ls_return iv_message_target = CONV string( ls_return-field ) ).
*  RAISE EXCEPTION lo_exception.
*ENDIF.
*
*MOVE-CORRESPONDING ls_file to ls_ben.
*MODIFY ZBEN_BNFT_IMAGE from ls_ben.
