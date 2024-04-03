*&---------------------------------------------------------------------*
*&  Include           ZBEN_RESET_ALL_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT * FROM zben_tran_pers
    INTO CORRESPONDING FIELDS OF TABLE gt_pers
    WHERE zyear EQ p_year.

  PERFORM reset.

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
  DATA: lv_flag.

  IF gt_pers IS INITIAL .
    MESSAGE 'Personel bulunamadı!' TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

  LOOP AT gt_pers INTO gs_pers.
    IF gs_pers-delete_ind = 'X'.
      UPDATE zben_tran_ben SET delete_ind = 'X' WHERE pernr = gs_pers-pernr
                                            AND zyear = gs_pers-zyear
*                                                 AND benefit_id = 60
                                            AND catalog_ıd = 'YMK'.
      lv_flag = '1'.
      EXIT.
    ELSE.
      UPDATE zben_tran_pers SET delete_ind = 'X' user_accepted = ' ' WHERE pernr = gs_pers-pernr
                                                         AND zyear = gs_pers-zyear.
*
*      UPDATE zben_tran_pers SET user_accepted = ' ' WHERE pernr = gs_pers-pernr
*                                                    AND zyear = gs_pers-zyear.

      UPDATE zben_tran_ben SET delete_ind = 'X' WHERE pernr = gs_pers-pernr
                                                 AND zyear = gs_pers-zyear.
    ENDIF.
  ENDLOOP.

  IF lv_flag EQ '1'.
    MESSAGE 'Bu kayıt daha önce sıfırlanmıştır!' TYPE 'I' DISPLAY LIKE 'E'.
  ELSE.
    MESSAGE 'İşlem başarıyla tamamlandı!' TYPE 'I' DISPLAY LIKE 'S'.
  ENDIF.
ENDFORM.
