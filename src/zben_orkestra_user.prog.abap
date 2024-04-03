*&---------------------------------------------------------------------*
*& Report ZBEN_ORKESTRA_USER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBEN_ORKESTRA_USER.

TABLES : usr01 , pa0001 , pa0105.

PARAMETERS : p_usr LIKE usr01-bname OBLIGATORY DEFAULT sy-uname
                                    MATCHCODE OBJECT user_comp.
PARAMETERS : p_pernr LIKE pa0001-pernr OBLIGATORY MATCHCODE OBJECT prem.
PARAMETERS : p_bagla RADIOBUTTON GROUP a1,
             p_ekle  RADIOBUTTON GROUP a1 DEFAULT 'X'.

DATA : ls_105 LIKE pa0105.

START-OF-SELECTION.
  IF p_bagla EQ 'X'.
    CLEAR ls_105.
    DELETE FROM pa0105 WHERE  usrid = p_usr AND subty = '0001'.
    DELETE FROM pa0105 WHERE  pernr = p_pernr AND subty = '0001'.

    ls_105-pernr = p_pernr.
    ls_105-subty = ls_105-usrty = '0001'.
    ls_105-begda = '18000101'.
    ls_105-endda = '99991231'.
    ls_105-aedtm = sy-datum.
    ls_105-uname = sy-uname.
    ls_105-usrid = p_usr.

    MODIFY pa0105 FROM ls_105.

    WRITE : 'Başarılı'.

  ELSEIF p_ekle EQ 'X'.
    DELETE FROM pa0105 WHERE  usrid = p_usr AND subty = '0001'.
    CLEAR ls_105.
    SELECT SINGLE * FROM pa0105 INTO ls_105 WHERE
                  pernr = p_pernr AND subty = '0001'.
    IF sy-subrc EQ 0.

      ls_105-pernr = p_pernr.
      ls_105-subty = ls_105-usrty = '0001'.
      ls_105-begda = ls_105-begda + 1.
      ls_105-endda = '99991231'.
      ls_105-aedtm = sy-datum.
      ls_105-uname = sy-uname.
      ls_105-usrid = p_usr.

      SELECT SINGLE * from pa0105 where pernr = p_pernr
                                   and subty = '0001'
                                   and endda =  ls_105-endda
                                   and begda =  ls_105-begda
                                   and SEQNR =  ls_105-SEQNR.
      if sy-subrc eq 0.
        ls_105-begda = ls_105-begda + 1.
      endif.
      MODIFY pa0105 FROM ls_105.

      WRITE : 'Başarılı'.
    ELSE.
      WRITE : 'Kayıt Bulunamdı'.
    ENDIF.
  ENDIF.
