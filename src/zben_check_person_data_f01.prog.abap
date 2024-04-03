*&---------------------------------------------------------------------*
*&  Include           ZBEN_SEND_INFO_MAIL_TOP
*&---------------------------------------------------------------------*

FORM get_data.

  DATA: lv_date TYPE datum.
  lv_date = sy-datum - 1.
  DATA: ls_tran_pers_tmp TYPE zben_tran_pers.
  DATA: lt_tran_pers_tmp TYPE TABLE OF zben_tran_pers.


  SELECT COUNT(*) FROM zben_period WHERE end_date NE lv_date
                                         AND active EQ 'X'.
  CHECK sy-subrc EQ 0.

  SELECT * FROM zben_defin_pers INTO TABLE @DATA(lt_define_pers).

  SELECT * FROM zben_tran_pers
    FOR ALL ENTRIES IN @lt_define_pers
    WHERE pernr EQ @lt_define_pers-pernr
      AND zyear EQ @lt_define_pers-zyear
      AND delete_ind NE 'X'
    INTO TABLE @DATA(lt_tran_pers).


  LOOP AT lt_define_pers INTO DATA(ls_define_pers).
    READ TABLE lt_tran_pers WITH KEY pernr = ls_define_pers-pernr
                                     zyear = ls_define_pers-zyear
                            INTO DATA(ls_tran_pers).

    IF sy-subrc NE 0.
      CLEAR: ls_tran_pers_tmp.
      MOVE-CORRESPONDING ls_define_pers TO ls_tran_pers_tmp.
      ls_tran_pers_tmp-remain_total   = ls_tran_pers_tmp-fixed_budget.
      ls_tran_pers_tmp-actual_budget  = ls_tran_pers_tmp-fixed_budget.
      ls_tran_pers_tmp-cart_total     = ls_tran_pers_tmp-flexible_budget.
      ls_tran_pers_tmp-create_uname   = sy-uname.
      ls_tran_pers_tmp-create_time    = |{ sy-datum }{ sy-uzeit }|.
      ls_tran_pers_tmp-status          = 'SA'.
      APPEND ls_tran_pers_tmp TO lt_tran_pers_tmp.
    ENDIF.
  ENDLOOP.

  IF lt_tran_pers_tmp IS NOT INITIAL.
    MODIFY zben_tran_pers FROM TABLE lt_tran_pers_tmp.
  ENDIF.



ENDFORM.
