*&---------------------------------------------------------------------*
*&  Include           ZBEN_RESET_PERSONS_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT * FROM zben_tran_pers
    INTO CORRESPONDING FIELDS OF TABLE gt_pers
    WHERE pernr IN s_pernr
      AND zyear EQ p_year.


ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  LIST_DATA
*&---------------------------------------------------------------------*
FORM list_data .
  CALL SCREEN 0100.
ENDFORM.                    " LIST_DATA
" INIT
*&---------------------------------------------------------------------*
*&      Form  PREPARE_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_alv .
  DATA:  lv_fcat TYPE  slis_tabname .
  UNASSIGN <fs_data>.

  lv_fcat = 'GS_PERS'.
  ASSIGN ('GT_PERS[]') TO <fs_data>.


  IF gcl_con IS INITIAL.
    PERFORM create_container.
    PERFORM create_fcat USING lv_fcat.
    PERFORM set_fcat .
    PERFORM set_layout.
*    PERFORM set_dropdown.
    PERFORM display_alv.
    PERFORM set_handler_events.
  ELSE.
    PERFORM refresh_alv.
  ENDIF.
ENDFORM.                    " PREPARE_ALV
*&---------------------------------------------------------------------*
*&      Form  CREATE_CONTAINER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_container.

  CREATE OBJECT gcl_con
    EXPORTING
      container_name              = 'CON'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CREATE OBJECT gcl_grid
    EXPORTING
      i_parent          = gcl_con
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  "bu method edite acık gelmesı ıcın gereklı
  CALL METHOD gcl_grid->set_ready_for_input
    EXPORTING
      i_ready_for_input = 1.

ENDFORM.                    " CREATE_CONTAINER
*&---------------------------------------------------------------------*
*&      Form  CREATE_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_fcat USING p_fcat TYPE  slis_tabname .
  CLEAR: gt_fcat,gt_fcat[],it_fieldcat[].
  REFRESH: gt_fcat[].  FREE: gt_fcat[].


  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = p_fcat
      i_inclname             = 'ZBEN_RESET_PERSONS_TOP'
    CHANGING
      ct_fieldcat            = it_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      it_fieldcat_alv = it_fieldcat
    IMPORTING
      et_fieldcat_lvc = gt_fcat
    TABLES
      it_data         = gt_pers[]
    EXCEPTIONS
      it_data_missing = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.




ENDFORM.                    " CREATE_FCAT
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv .
  gs_vari-report = sy-repid.
  gs_vari-variant = ''.
*  gs_layo-cwidth_opt = 'X'.
  gs_layo-zebra = 'X'.
*  gs_layo-stylefname = 'STYLE'.

  CALL METHOD gcl_grid->set_table_for_first_display
    EXPORTING
      is_variant                    = gs_vari
      i_save                        = 'A'
      is_layout                     = gs_layo
    CHANGING
      it_outtab                     = <fs_data>
      it_fieldcatalog               = gt_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  gcl_grid->set_ready_for_input(
         i_ready_for_input = 1
     ).
ENDFORM.                    " DISPLAY_ALV
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fcat.
  FIELD-SYMBOLS : <fcat> TYPE lvc_s_fcat.
*  IF gv_okcode EQ 'SIMULATE' OR gv_okcode EQ 'SAVE'.

*  LOOP AT gt_fcat ASSIGNING <fcat>.
*
*      CASE <fcat>-fieldname.
*        WHEN 'ERNAM'.
***        <fcat>-scrtext_l =
*          <fcat>-edit = 'X'.
*        WHEN OTHERS.
*      ENDCASE.
*
*  ENDLOOP.

ENDFORM.                    " BUILD_FCAT
*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
FORM set_layout.
  gs_layo-stylefname = 'STYLE'.
  gs_layo-cwidth_opt = 'X'.

  gs_layo-no_rowins = 'X'.
  gs_layo-no_rowmove = 'X'.

ENDFORM.                    " SET_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  SET_EVENTS
*&---------------------------------------------------------------------*
FORM set_handler_events .
  CREATE OBJECT gcl_evt_rec.
  SET HANDLER gcl_evt_rec->handle_data_changed
          FOR gcl_grid.
  SET HANDLER gcl_evt_rec->handle_user_command
          FOR gcl_grid.
  SET HANDLER gcl_evt_rec->handle_toolbar
          FOR gcl_grid.
  SET HANDLER gcl_evt_rec->handle_data_changed_finished
          FOR gcl_grid.
  CALL METHOD gcl_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter.
  CALL METHOD gcl_grid->set_toolbar_interactive.
ENDFORM.                    " SET_EVENTS
*&---------------------------------------------------------------------*
*&      Form  REFRESH_ALV
*&---------------------------------------------------------------------*
FORM refresh_alv .
  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stbl
      i_soft_refresh = gs_soft_ref
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    " REFRESH_ALV
*&---------------------------------------------------------------------*
*&      Form  FREE
*&---------------------------------------------------------------------*
FORM free .
  IF gcl_grid IS NOT INITIAL.
    CALL METHOD gcl_grid->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      FREE gcl_grid.
    ENDIF.
  ENDIF.
  IF gcl_con IS NOT INITIAL.
    CALL METHOD gcl_con->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      FREE gcl_con.
    ENDIF.
  ENDIF.
ENDFORM.                    " FREE

*&---------------------------------------------------------------------*
*&      Form  HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM handle_user_command USING e_ucomm TYPE sy-ucomm
                               e_sender TYPE REF TO cl_gui_alv_grid.
  DATA: lv_ucomm LIKE sy-ucomm,
        lv_subrc LIKE sy-subrc.
  DATA: lt_row_no TYPE lvc_t_roid,
        ls_row_no TYPE lvc_s_roid.
  DATA: lv_index TYPE i.
  CALL METHOD gcl_grid->get_selected_rows
    IMPORTING
      et_row_no = lt_row_no.
  CLEAR: gt_row_no[].
  gt_row_no = lt_row_no.


  IF lines( lt_row_no ) < 1.
    MESSAGE s008(zben) DISPLAY LIKE 'E'.
    RETURN.
*  ELSEIF lines( lt_row_no ) > 1.
*    MESSAGE s009(zben) DISPLAY LIKE 'E'..
*    RETURN.
  ENDIF.
  DATA: lv_flag.
  "bu alv nın ustundekı ekledıgımız butonların dustugu method
  CASE e_ucomm.

    WHEN 'RESET'.

      LOOP AT lt_row_no INTO ls_row_no.
        READ TABLE gt_pers ASSIGNING FIELD-SYMBOL(<fs_tmp>) INDEX ls_row_no-row_id.


        IF sy-subrc EQ 0.
          IF <fs_tmp>-delete_ind = 'X'.
            lv_flag = '1'.
            EXIT.

          ELSE.
            UPDATE zben_tran_pers SET delete_ind = 'X' WHERE pernr = <fs_tmp>-pernr
                                                         AND zyear = <fs_tmp>-zyear.

            UPDATE zben_tran_ben SET delete_ind = 'X' WHERE pernr = <fs_tmp>-pernr
                                                      AND zyear = <fs_tmp>-zyear.

            <fs_tmp>-delete_ind = 'X'.
          ENDIF.

        ENDIF.
      ENDLOOP.

      IF lv_flag EQ '1'.
        MESSAGE 'Bu kayıt daha önce sıfırlanmıştır!' TYPE 'I' DISPLAY LIKE 'I'.
      ELSE.
        MESSAGE 'İşlem başarıyla tamamlandı!' TYPE 'I' DISPLAY LIKE 'S'.
      ENDIF.

  ENDCASE.
  PERFORM refresh_alv.
ENDFORM.                    " HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*&      Form  HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
*       text  LAYOUTUN ÜSTÜNDEKİ TOOLBARLARI DEĞİŞTİREBİLMEMİZİ SAĞLAR.
*----------------------------------------------------------------------*
FORM handle_toolbar  USING e_object TYPE REF TO cl_alv_event_toolbar_set
                           e_sender TYPE REF TO cl_gui_alv_grid.

  DATA  : lt_toolbar TYPE ttb_button.
  DATA  : ls_toolbar TYPE stb_button.
  CASE e_sender.
    WHEN gcl_grid.

      ls_toolbar-function  = 'RESET'."'Yazdırma öngörünümü'.
      ls_toolbar-quickinfo = 'Personeli Sıfırla'."Yazdırma öngörünümü'.
      ls_toolbar-butn_type = '0'.
      ls_toolbar-text      = 'Sıfırla'."Yazdırma öngörünümü'.
      ls_toolbar-icon      = icon_modification_reset."icon_start_viewer.
      INSERT ls_toolbar INTO TABLE lt_toolbar .



  ENDCASE.

  INSERT LINES OF lt_toolbar INTO TABLE  e_object->mt_toolbar[].
*  e_object->mt_toolbar[] = lt_toolbar[].
ENDFORM.                    " HANDLE_TOOLBAR

*----------------------------------------------------------------------*
FORM handle_data_changed  USING er_data_changed TYPE REF TO cl_alv_changed_data_protocol
                                e_onf4          TYPE char01
                                e_onf4_before   TYPE char01
                                e_onf4_after    TYPE char01
                                e_ucomm         TYPE sy-ucomm
                                e_sender        TYPE REF TO cl_gui_alv_grid.
  "DEGISEN VERIYI ALGILAMAK ICIN GEREKLI
  "EDITLI ALAN VAR ISE VEYA CHECKBOX O DURUMDA KULLANILIR

ENDFORM.                    " HANDLE_DATA_CHANGED
**&---------------------------------------------------------------------*
**&      Form  HANDLE_DATA_CHANGED_FINISHED
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
FORM handle_data_changed_finished  USING e_modified
                                         et_good_cells TYPE lvc_t_modi
                                         e_sender TYPE REF TO cl_gui_alv_grid.

ENDFORM.                    " HANDLE_DATA_CHANGED_FINISHED
