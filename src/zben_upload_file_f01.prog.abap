*&---------------------------------------------------------------------*
*&  Include           ZBEN_UPLOAD_FILE_F01
*&---------------------------------------------------------------------*

FORM save_image .


  DATA: lv_xstring TYPE xstring,       "Xstring
        lv_len     TYPE i,                  "Length
        lt_content TYPE soli_tab,      "Content
        lv_string  TYPE string,        "Text
        lv_base64  TYPE string.        "Base64



* Dosya seçim diyaloğu
* tek dosya okuyacağımız için ilk satır lazım bize
  DATA: lv_filesize TYPE w3param-cont_len.
  DATA: lv_filetype TYPE w3param-cont_type.
  DATA: lt_bin_data TYPE w3mimetabtype.

*Convert string to xstring

  DATA: ls_ben TYPE zben_bnft_image.
  DATA: ls_file TYPE zben_s_files.
  DATA: ls_return     TYPE bapiret2.
  DATA: lv_filename TYPE string.
  DATA: lv_stripped TYPE string.


  lv_filename = p_file.

  cl_gui_frontend_services=>gui_upload( EXPORTING
                                            filename   = lv_filename "|{ lt_dosya[ 1 ]-filename }|
                                            filetype   = 'BIN'
                                          IMPORTING
                                            filelength = lv_filesize
                                          CHANGING
                                            data_tab   = lt_bin_data ).


*Convert string to xstring




  IF r_pdf EQ 'X'.
    ls_ben-benefit_id = 99999.
    ls_ben-mime_type  = 'application/pdf'.



    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = lv_filesize
*       FIRST_LINE   = 0
*       LAST_LINE    = 0
      IMPORTING
        buffer       = ls_ben-value
      TABLES
        binary_tab   = lt_bin_data
*   EXCEPTIONS
*       FAILED       = 1
*       OTHERS       = 2
      .

*    DATA: s1 TYPE string.
*
*    CALL FUNCTION 'SSFC_BASE64_ENCODE'
*      EXPORTING
*        bindata = ls_ben-value
*      IMPORTING
*        b64data = s1
*      EXCEPTIONS
*        OTHERS  = 1. " Over simplifying exception handling
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*    CALL FUNCTION 'TRINT_FILE_GET_EXTENSION'
*      EXPORTING
*        filename  = p_file
*      IMPORTING
*        extension = ls_ben-mime_type.

  ELSE.

    DATA(lv_bin_data) = cl_bcs_convert=>solix_to_xstring( it_solix = lt_bin_data ).
    ls_ben-benefit_id = p_bnft."17
    ls_ben-mime_type  = 'image/png'.
    ls_ben-value      = lv_bin_data.



  ENDIF.

*  ls_ben-file_name  = p_file."'BP_IMAGE'.
  CALL FUNCTION 'TRINT_SPLIT_FILE_AND_PATH'
    EXPORTING
      full_name     = p_file
    IMPORTING
      stripped_name = ls_ben-file_name
      file_path     = lv_stripped
    EXCEPTIONS
      x_error       = 1
      OTHERS        = 2.

  ls_ben-create_user = sy-uname.
  ls_ben-create_date = sy-datum.
  ls_ben-create_time = sy-uzeit.

  IF r_pdf EQ 'X'.
    ls_ben-catalog_id = 'PDF'.
  ELSE.
    SELECT SINGLE catalog_id
      FROM zben_benefits
      INTO ls_ben-catalog_id
      WHERE benefit_id EQ p_bnft.
  ENDIF.

  MOVE-CORRESPONDING ls_ben TO ls_file.
  MESSAGE 'Yükleme başarılı' TYPE 'S'." WITH p_file

  MODIFY zben_bnft_image FROM ls_ben.
  COMMIT WORK.


ENDFORM.

FORM download_file .


  DATA: lv_xstring TYPE xstring,       "Xstring
        lv_len     TYPE i,                  "Length
        lt_content TYPE soli_tab,      "Content
        lv_string  TYPE string,        "Text
        lv_base64  TYPE string.        "Base64



* Dosya seçim diyaloğu
* tek dosya okuyacağımız için ilk satır lazım bize
  DATA: lv_filesize TYPE w3param-cont_len.
  DATA: lv_filetype TYPE w3param-cont_type.
  DATA: lt_bin_data TYPE w3mimetabtype.

*Convert string to xstring

  DATA: ls_ben TYPE zben_bnft_image.
  DATA: ls_file TYPE zben_s_files.
  DATA: ls_return     TYPE bapiret2.
  DATA: lv_filename TYPE string.



  lv_filename = p_file.

  SELECT SINGLE *
    FROM zben_bnft_image
    INTO @DATA(ls_pdf)
    WHERE benefit_id EQ 99999.

  DATA(lt_solix) = cl_bcs_convert=>xstring_to_solix( iv_xstring =  ls_pdf-value ).

  DATA: data_tab   TYPE TABLE OF x255,
        lv_content TYPE xstring,
        len        TYPE i,
        filename   TYPE string.


  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer        = ls_pdf-value
*     APPEND_TO_TABLE = ' '
    IMPORTING
      output_length = len
    TABLES
      binary_tab    = data_tab.


  cl_gui_frontend_services=>gui_download(
    EXPORTING
*      bin_filesize              =                      " File length for binary files
      filename                  =    'test.pdf'                  " Name of file
      filetype                  = 'BIN'                " File type (ASCII, binary ...)
*      append                    = space                " Character Field of Length 1
*      write_field_separator     = space                " Separate Columns by Tabs in Case of ASCII Download
*      header                    = '00'                 " Byte Chain Written to Beginning of File in Binary Mode
*      trunc_trailing_blanks     = space                " Do not Write Blank at the End of Char Fields
*      write_lf                  = 'X'                  " Insert CR/LF at End of Line in Case of Char Download
*      col_select                = space                " Copy Only Selected Columns of the Table
*      col_select_mask           = space                " Vector Containing an 'X' for the Column To Be Copied
*      dat_mode                  = space                " Numeric and date fields are in DAT format in WS_DOWNLOAD
*      confirm_overwrite         = space                " Overwrite File Only After Confirmation
*      no_auth_check             = space                " Switch off Check for Access Rights
*      codepage                  =                      " Character Representation for Output
*      ignore_cerr               = abap_true            " Ignore character set conversion errors?
*      replacement               = '#'                  " Replacement Character for Non-Convertible Characters
*      write_bom                 = space                " If set, writes a Unicode byte order mark
*      trunc_trailing_blanks_eol = 'X'                  " Remove Trailing Blanks in Last Column
*      wk1_n_format              = space
*      wk1_n_size                = space
*      wk1_t_format              = space
*      wk1_t_size                = space
*      show_transfer_status      = 'X'                  " Enables suppression of transfer status message
*      fieldnames                =                      " Table Field Names
*      write_lf_after_last_line  = 'X'                  " Writes a CR/LF after final data record
*      virus_scan_profile        = '/SCET/GUI_DOWNLOAD' " Virus Scan Profile
*    IMPORTING
*      filelength                =                      " Number of bytes transferred
    CHANGING
      data_tab                  =    data_tab                  " Transfer table
*    EXCEPTIONS
*      file_write_error          = 1                    " Cannot write to file
*      no_batch                  = 2                    " Cannot execute front-end function in background
*      gui_refuse_filetransfer   = 3                    " Incorrect Front End
*      invalid_type              = 4                    " Invalid value for parameter FILETYPE
*      no_authority              = 5                    " No Download Authorization
*      unknown_error             = 6                    " Unknown error
*      header_not_allowed        = 7                    " Invalid header
*      separator_not_allowed     = 8                    " Invalid separator
*      filesize_not_allowed      = 9                    " Invalid file size
*      header_too_long           = 10                   " Header information currently restricted to 1023 bytes
*      dp_error_create           = 11                   " Cannot create DataProvider
*      dp_error_send             = 12                   " Error Sending Data with DataProvider
*      dp_error_write            = 13                   " Error Writing Data with DataProvider
*      unknown_dp_error          = 14                   " Error when calling data provider
*      access_denied             = 15                   " Access to File Denied
*      dp_out_of_memory          = 16                   " Not enough memory in data provider
*      disk_full                 = 17                   " Storage medium is full.
*      dp_timeout                = 18                   " Data provider timeout
*      file_not_found            = 19                   " Could not find file
*      dataprovider_exception    = 20                   " General Exception Error in DataProvider
*      control_flush_error       = 21                   " Error in Control Framework
*      not_supported_by_gui      = 22                   " GUI does not support this
*      error_no_gui              = 23                   " GUI not available
*      others                    = 24
  ).
  IF sy-subrc <> 0.
*   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
*Convert string to xstring



*  zcl_ben_file_handler=>upload_file(
*     IMPORTING
*       es_return     = ls_return
*       CHANGING
*       cs_file       = ls_file ) .
*
*  IF ls_return-type = 'E'.
*    DATA(lo_exception) = NEW /iwbep/cx_mgw_busi_exception( ).
*    lo_exception->get_msg_container( )->add_message_from_bapi( is_bapi_message = ls_return iv_message_target = CONV string( ls_return-field ) ).
*    RAISE EXCEPTION lo_exception.
*  ENDIF.

*  MOVE-CORRESPONDING ls_file TO ls_ben.
  MODIFY zben_bnft_image FROM ls_ben.
  COMMIT WORK.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  OPEN_DIALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM open_dialog .

  DATA: lt_dosya TYPE filetable.
  DATA: lv_action TYPE i.

  DATA: lv_filter(30).

  DATA: lv_text1(30),
        lv_text2(30),
        lv_text3(30),
        lv_text4(30).

  lv_text1 = '(*.jpeg)|*.jpeg|'.
  lv_text2 = '(*.jpg)|*.jpg|'.
  lv_text3 = '(*.png)|*.png|'.
  lv_text4 = '(*.pdf)|*.pdf|'.



  IF r_pdf EQ 'X'.
    lv_filter = lv_text4.
  ELSE.
    lv_filter = |{ lv_text1 } { lv_text2 } { lv_text3 } |.
  ENDIF.


  cl_gui_frontend_services=>file_open_dialog( EXPORTING
*                                                  file_filter = |{ lv_filter }{ cl_gui_frontend_services=>filetype_all }|
*                                                  file_filter = |*.jpeg\|*.jpg\|*.png\|*.pdf\|{ cl_gui_frontend_services=>filetype_all }|
                                                  file_filter = | { lv_filter } { cl_gui_frontend_services=>filetype_all }|

*                                                  '(*.txt)|*.txt|'
                                                CHANGING
                                                  file_table  = lt_dosya
                                                  rc          = gv_rc
                                                  user_action = lv_action ).
  IF lt_dosya IS NOT INITIAL.
    p_file = lt_dosya[ 1 ]-filename.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTH_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM auth_check.

*  AUTHORITY-CHECK OBJECT 'M_MSEG_LGO'
*    ID 'LGORT' FIELD s_lgorta-low
*    ID 'ACTVT'  FIELD '01'.
*
*  IF sy-subrc <> 0.
*    MESSAGE e022(zmm_betta).
**    MESSAGE 'No authorization' TYPE 'E'.
*    RETURN.
*  ENDIF.


ENDFORM.
