*&---------------------------------------------------------------------*
*&  Include           ZBEN_CARSI_KALAN_BAK_TOP
*&---------------------------------------------------------------------*
TABLES: pa0001,mseg.


TYPE-POOLS: slis, icon.
DATA: gv_okcode TYPE sy-ucomm.
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK blk1.

SELECT-OPTIONS: s_pernr FOR pa0001-pernr,
                s_bukrs  FOR pa0001-bukrs,
                s_plans  FOR pa0001-plans,
                s_orgeh  FOR pa0001-orgeh.
SELECTION-SCREEN END OF BLOCK blk1.

PARAMETERS: p_year LIKE mseg-mjahr DEFAULT '2023'.

*--------------------------------------------------------------------*

FIELD-SYMBOLS: <fs_data> TYPE ANY TABLE.
DATA:gs_pers TYPE zben_s_personel_bakiye.
DATA:gt_pers LIKE TABLE OF gs_pers.


DATA: BEGIN OF gs_value,
        yst     TYPE zben_t_params-paramvalue, "dec15
        ygs     TYPE zben_t_params-paramvalue, "dec15
        yau     TYPE zben_t_params-paramvalue, "dec15
        tempkes TYPE zben_t_params-paramvalue, "dec15
        ssks    TYPE zben_t_params-paramvalue, "dec15
        ssko    TYPE zben_t_params-paramvalue, "dec15
        sskn    TYPE zben_t_params-paramvalue, "dec15
        sske    TYPE zben_t_params-paramvalue, "dec15
        sska    TYPE zben_t_params-paramvalue, "dec15
        ssk     TYPE zben_t_params-paramvalue, "dec15
        rec     TYPE zben_t_params-paramvalue, "dec15
        mul     TYPE zben_t_params-paramvalue, "dec15
        gym     TYPE zben_t_params-paramvalue, "dec15
        ekebb   TYPE zben_t_params-paramvalue, "dec15
        dvo     TYPE zben_t_params-paramvalue, "dec15
      END OF gs_value.

*--------------------------------------------------------------------*


DATA:gs_row_no TYPE lvc_s_roid,
     gt_row_no TYPE lvc_t_roid.


*--------------------------------------------------------------------*

*>*ALV Tanımlamaları
CLASS : lcl_alv     DEFINITION DEFERRED.
DATA  : gcl_evt_rec TYPE REF TO lcl_alv.
DATA  : gcl_alv  TYPE REF TO lcl_alv,
        gcl_grid TYPE REF TO cl_gui_alv_grid,
        gcl_con  TYPE REF TO cl_gui_custom_container.
DATA  : it_fieldcat TYPE slis_t_fieldcat_alv.
DATA  : gt_fcat     TYPE lvc_t_fcat.
DATA  : gs_fcat     TYPE lvc_t_fcat.
DATA  : gs_layo     TYPE lvc_s_layo.
DATA  : gs_vari     TYPE disvariant.
DATA  : gs_stbl     TYPE lvc_s_stbl.
DATA  : gs_soft_ref TYPE char1 VALUE 'X'.
