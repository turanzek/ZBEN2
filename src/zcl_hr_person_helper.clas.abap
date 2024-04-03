class ZCL_HR_PERSON_HELPER definition
  public
  final
  create public .

public section.

  class-methods GET_PERNR_FROM_UNAME
    importing
      !IV_UNAME type UNAME optional
    returning
      value(EV_PERNR) type PERNR_D .
protected section.
private section.
ENDCLASS.



CLASS ZCL_HR_PERSON_HELPER IMPLEMENTATION.


  METHOD get_pernr_from_uname.

    DATA: lt_tab TYPE pernr_us_tab.

*    sy-uname = 'EODABAS'.
    CALL FUNCTION 'HR_GET_EMPLOYEES_FROM_USER'
      EXPORTING
        user   = sy-uname
*       BEGDA  = SY-DATUM
*       ENDDA  = SY-DATUM
*       IV_WITH_AUTHORITY       = 'X'
      TABLES
        ee_tab = lt_tab.


    TRY.
        Ev_pernr = lt_tab[ 1 ]-pernr.
      CATCH cx_sy_itab_line_not_found..

    ENDTRY.


  ENDMETHOD.
ENDCLASS.
