*&---------------------------------------------------------------------*
*&  Include           ZBEN_RESET_PERSON_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .

*  SELECT * FROM zben_tran_pers
*    INTO CORRESPONDING FIELDS OF TABLE gt_pers
*    WHERE pernr IN s_pernr
*      AND zyear EQ p_year.
*
*  PERFORM reset.

ENDFORM.                    " GET_DATA

*&---------------------------------------------------------------------*
*&      Form  RESET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM reset .
*  DATA: lv_flag.
*
*  IF gt_pers IS INITIAL .
*    MESSAGE 'Personel bulunamadı!' TYPE 'I' DISPLAY LIKE 'E'.
*  ENDIF.
*
*  LOOP AT gt_pers INTO gs_pers.
*    IF gs_pers-delete_ind = 'X'.
*      UPDATE zben_tran_ben SET delete_ind = 'X' WHERE pernr = gs_pers-pernr
*                                            AND zyear = gs_pers-zyear
**                                                 AND benefit_id = 60
*                                            AND catalog_ıd = 'YMK'.
*      lv_flag = '1'.
*      EXIT.
*    ELSE.
*      UPDATE zben_tran_pers SET delete_ind = 'X' WHERE pernr = gs_pers-pernr
*                                                         AND zyear = gs_pers-zyear.
*
*      UPDATE zben_tran_pers SET user_accepted = ' ' WHERE pernr = gs_pers-pernr
*                                                    AND zyear = gs_pers-zyear.
*
*      UPDATE zben_tran_ben SET delete_ind = 'X' WHERE pernr = gs_pers-pernr
*                                                 AND zyear = gs_pers-zyear.
*    ENDIF.
*  ENDLOOP.
*
*  IF lv_flag EQ '1'.
*    MESSAGE 'Bu kayıt daha önce sıfırlanmıştır!' TYPE 'I' DISPLAY LIKE 'E'.
*  ELSE.
*    MESSAGE 'İşlem başarıyla tamamlandı!' TYPE 'I' DISPLAY LIKE 'S'.
*  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*FORM handle_user_command USING e_ucomm TYPE sy-ucomm
*                               e_sender TYPE REF TO cl_gui_alv_grid.
*  DATA: lv_ucomm LIKE sy-ucomm,
*        lv_subrc LIKE sy-subrc.
*  DATA: lt_row_no TYPE lvc_t_roid,
*        ls_row_no TYPE lvc_s_roid.
*  DATA: lv_index TYPE i.
*  CALL METHOD gcl_grid->get_selected_rows
*    IMPORTING
*      et_row_no = lt_row_no.
*  CLEAR: gt_row_no[].
*  gt_row_no = lt_row_no.
*
*
*  IF lines( lt_row_no ) < 1.
*    MESSAGE s008(zben) DISPLAY LIKE 'E'.
*    RETURN.
**  ELSEIF lines( lt_row_no ) > 1.
**    MESSAGE s009(zben) DISPLAY LIKE 'E'..
**    RETURN.
*  ENDIF.
*  DATA: lv_flag.
*  "bu alv nın ustundekı ekledıgımız butonların dustugu method
*  CASE e_ucomm.
*
*    WHEN 'RESET'.
*
*      LOOP AT lt_row_no INTO ls_row_no.
*        READ TABLE gt_pers ASSIGNING FIELD-SYMBOL(<fs_tmp>) INDEX ls_row_no-row_id.
*
*
*        IF sy-subrc EQ 0.
*          IF <fs_tmp>-delete_ind = 'X'.
*            lv_flag = '1'.
*            EXIT.
*
*          ELSE.
*            UPDATE zben_tran_pers SET delete_ind = 'X' WHERE pernr = <fs_tmp>-pernr
*                                                         AND zyear = <fs_tmp>-zyear.
*
*            UPDATE zben_tran_ben SET delete_ind = 'X' WHERE pernr = <fs_tmp>-pernr
*                                                      AND zyear = <fs_tmp>-zyear.
*
*            <fs_tmp>-delete_ind = 'X'.
*          ENDIF.
*
*        ENDIF.
*      ENDLOOP.
*
*      IF lv_flag EQ '1'.
*        MESSAGE 'Bu kayıt daha önce sıfırlanmıştır!' TYPE 'I' DISPLAY LIKE 'I'.
*      ELSE.
*        MESSAGE 'İşlem başarıyla tamamlandı!' TYPE 'I' DISPLAY LIKE 'S'.
*      ENDIF.
*
*  ENDCASE.
*ENDFORM.
