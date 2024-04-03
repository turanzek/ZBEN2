*&---------------------------------------------------------------------*
*& Report ZBEN_RESET_PERSONS
*&---------------------------------------------------------------------*
* Project           : Reset Personel
*----------------------------------------------------------------------*
* Program           : ZBEN_RESET_PERSONS
* Development ID    :
* Jira ID           :
* Module            :
* Module Consultant :
* ABAP Consultant   : Anıl Çetin
* ———————————————————————–———–———–———–
*&---------------------------------------------------------------------*
REPORT ZBEN_RESET_PERSONS_ALV.

INCLUDE ZBEN_RESET_PERSONS_ALV_TOP.
*INCLUDE ZBEN_RESET_PERSONS_TOP.
INCLUDE ZBEN_RESET_PERSONS_ALV_CLS.
*INCLUDE ZBEN_RESET_PERSONS_CLS.
INCLUDE ZBEN_RESET_PERSONS_ALV_F01.
*INCLUDE ZBEN_RESET_PERSONS_F01.
INCLUDE ZBEN_RESET_PERSONS_ALV_PBO.
*INCLUDE ZBEN_RESET_PERSONS_PBO.
INCLUDE ZBEN_RESET_PERSONS_ALV_PAI.
*INCLUDE ZBEN_RESET_PERSONS_PAI.

*----------------------------------------------------------------------*
*INITIALIZATION.
*----------------------------------------------------------------------*
INITIALIZATION.
  CREATE OBJECT gcl_alv TYPE lcl_alv.

*----------------------------------------------------------------------*
*START-OF-SELECTION.
*----------------------------------------------------------------------*
START-OF-SELECTION.

  CALL METHOD gcl_alv->get_data( ).

*----------------------------------------------------------------------*
*END-OF-SELECTION.
*----------------------------------------------------------------------*
END-OF-SELECTION.
  CALL METHOD gcl_alv->list_data( ).
