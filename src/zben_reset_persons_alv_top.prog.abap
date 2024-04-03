*&---------------------------------------------------------------------*
*&  Include           ZBEN_RESET_PERSONS_TOP
*&---------------------------------------------------------------------*
TABLES: PA0002,ZBEN_TRAN_PERS.


TYPE-POOLS: slis, icon.
DATA: gv_okcode TYPE sy-ucomm.
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK blk1.

  SELECT-OPTIONS: s_pernr FOR PA0002-pernr.
*                  s_year  FOR ZBEN_TRAN_PERS-zyear.
SELECTION-SCREEN END OF BLOCK blk1.

PARAMETERS: p_year LIKE ZBEN_TRAN_PERS-zyear.

*--------------------------------------------------------------------*
FIELD-SYMBOLS: <fs_data> TYPE ANY TABLE.
DATA:gs_pers TYPE ZBEN_TRAN_PERS.
DATA:gt_pers LIKE TABLE OF gs_pers.


DATA:gs_row_no TYPE lvc_s_roid,
     gt_row_no TYPE lvc_t_roid.


*--------------------------------------------------------------------*

*>*ALV Tanımlamaları
CLASS : lcl_alv     DEFINITION DEFERRED.
DATA  : gcl_evt_rec TYPE REF TO lcl_alv.
DATA  : gcl_alv     TYPE REF TO lcl_alv,
        gcl_grid    TYPE REF TO cl_gui_alv_grid,
        gcl_con     TYPE REF TO cl_gui_custom_container.
DATA  : it_fieldcat TYPE slis_t_fieldcat_alv.
DATA  : gt_fcat     TYPE lvc_t_fcat.
DATA  : gs_fcat     TYPE lvc_t_fcat.
DATA  : gs_layo     TYPE lvc_s_layo.
DATA  : gs_vari     TYPE disvariant.
DATA  : gs_stbl     TYPE lvc_s_stbl.
DATA  : gs_soft_ref TYPE char1 VALUE 'X'.
