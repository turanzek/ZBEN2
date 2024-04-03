*&---------------------------------------------------------------------*
*& Report ZBEN_CARSI_KALAN_BAK
*&---------------------------------------------------------------------*
* Project           : İşten ayrılan personelin bakiye hesaplanması
*----------------------------------------------------------------------*
* Program           : ZBEN_CARSI_KALAN_BAK
* Development ID    :
* Jira ID           :
* Module            :
* Module Consultant :
* ABAP Consultant   : Anıl Çetin
* ———————————————————————–———–———–———–
*&---------------------------------------------------------------------*
REPORT ZBEN_CARSI_KALAN_BAK.

INCLUDE ZBEN_CARSI_KALAN_BAK_TOP.
INCLUDE ZBEN_CARSI_KALAN_BAK_CLS.
INCLUDE ZBEN_CARSI_KALAN_BAK_F01.
INCLUDE ZBEN_CARSI_KALAN_BAK_PBO.
INCLUDE ZBEN_CARSI_KALAN_BAK_PAI.

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
