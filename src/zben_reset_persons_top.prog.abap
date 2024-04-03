
*&---------------------------------------------------------------------*
*&  Include           ZBEN_RESET_PERSONS_TOP
*&---------------------------------------------------------------------*
TABLES: PA0002,ZBEN_TRAN_PERS.

*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK blk1.

  SELECT-OPTIONS: s_pernr FOR PA0002-pernr OBLIGATORY.
*                  s_year  FOR ZBEN_TRAN_PERS-zyear.
SELECTION-SCREEN END OF BLOCK blk1.

PARAMETERS: p_year LIKE ZBEN_TRAN_PERS-zyear OBLIGATORY.

*--------------------------------------------------------------------*
FIELD-SYMBOLS: <fs_data> TYPE ANY TABLE.
DATA:gs_pers TYPE ZBEN_TRAN_PERS.
DATA:gt_pers LIKE TABLE OF gs_pers.
