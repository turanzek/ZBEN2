class ZCL_BEN_DATA_PROVIDER definition
  public
  final
  create public .

public section.

  class-data IO_PROVIDER type ref to ZCL_BEN_DATA_PROVIDER .
  data GT_CATALOGS type ZBEN_TT_CATALOG .
  data GT_BENEFITS type ZBEN_TT_BENEFITS .
  data GS_PERSON_INFO type ZBEN_TT_BENEFITS .

  methods GET_CATALOGS
    importing
      value(IV_GUID) type SYSUUID_C32 optional
    returning
      value(RT_CATALOGS) type ZBEN_TT_CATALOG .
  methods GET_CATALOG_BENEFITS
    importing
      !IV_GUID type SYSUUID_C32
      !IV_CATALOG_ID type ZBEN_S_CATALOG-CATALOG_ID
    exporting
      !ES_MODEL type ZBEN_S_APP_MODEL .
  methods CONSTRUCTOR .
  class-methods GET_INSTANCE
    returning
      value(RT_PROVIDER) type ref to ZCL_BEN_DATA_PROVIDER .
  methods SET_STATIC_DATAS
    changing
      !CT_MODEL type ZBEN_TT_APP_MODEL optional .
  methods GET_BENEFIT
    importing
      !IV_CATALOG_ID type ZBEN_S_BENEFITS-CATALOG_ID
      !IV_BENEFIT_ID type ZBEN_S_BENEFITS-BENEFIT_ID
    exporting
      !ES_MODEL type ZBEN_S_APP_MODEL
      !ET_BENEFITS type ZBEN_TT_BENEFITS .
  methods GET_DEFINED_BENEFITS
    importing
      value(IV_GUID) type SYSUUID_C32 optional
    returning
      value(RT_DEFINED_BENEFITS) type ZBEN_TT_DEFINED_BEN .
  methods GET_ROOT_INFO
    importing
      !IV_GUID type SYSUUID_C32
    exporting
      value(ES_RETURN) type ZBEN_S_ROOT_INFO .
  methods GET_APPLICATION_MODEL
    returning
      value(RS_APP_MODEL) type ZBEN_S_APP_MODEL .
  methods GET_PERIOD
    exporting
      !ES_PERIOD type ZBEN_PERIOD .
  methods GET_TEXT
    importing
      !IV_GUID type SYSUUID_C32
    exporting
      value(ES_RETURN) type ZBEN_S_TEXT .
protected section.

  class-data MS_MODEL type ZBEN_S_APP_MODEL .
private section.
ENDCLASS.



CLASS ZCL_BEN_DATA_PROVIDER IMPLEMENTATION.


  METHOD constructor.


*    ZBEN_BENEFITS

*    ZBEN_CATALOG
    CALL METHOD me->get_catalogs
      RECEIVING
        rt_catalogs = gt_catalogs.


  ENDMETHOD.


  method GET_APPLICATION_MODEL.


    rs_app_model = ms_model.

  endmethod.


  METHOD get_benefit.

    SELECT * FROM zben_benefits
      INNER JOIN zben_catalog ON zben_catalog~catalog_id EQ zben_benefits~catalog_id
      INTO CORRESPONDING FIELDS OF TABLE et_benefits
      WHERE zben_benefits~catalog_id = iv_catalog_id
        AND zben_benefits~benefit_id = iv_benefit_id
        AND zben_benefits~benefit_group = zif_ben_constants=>mc_benefit_group_eyh."'EYH'.

    LOOP AT et_benefits ASSIGNING FIELD-SYMBOL(<ls_benefit>).
      <ls_benefit>-waers = '₺'.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_catalogs.
*    This is called by CatalogsSet when application start
**    zcl_ben_tt_carsi_dpc_ext->catalogsset

    DATA: lt_benefits TYPE zben_tt_benefits.

    SELECT * FROM zben_catalog
      INTO CORRESPONDING FIELDS OF TABLE rt_catalogs
      WHERE catalog_id NE 'YMK'.

    IF rt_catalogs[] IS NOT INITIAL.
      SELECT * FROM zben_benefits
            INTO CORRESPONDING FIELDS OF TABLE lt_benefits
        FOR ALL ENTRIES IN rt_catalogs
            WHERE catalog_id = rt_catalogs-catalog_id
              AND benefit_group = zif_ben_constants=>mc_benefit_group_eyh"'EYH'.
              AND benefit_id NE 59.
    ENDIF.



    LOOP AT rt_catalogs INTO DATA(ls_catalog).
      CLEAR: ls_catalog-count.
      LOOP AT lt_benefits INTO DATA(ls_benefits)
                          WHERE catalog_id = ls_catalog-catalog_id.

        ls_benefits-plate_related = ls_catalog-plate_related.
* ls_benefits-files = zcl_ben_file_handler=>get_service_entry_files( iv_guid = iv_guid iv_catalog_id = ls_benefits-catalog_id iv_benefit_id = ls_benefits-benefit_id ).
        ls_benefits-file = zcl_ben_file_handler=>get_benefits_image(
                              iv_catalog_id = ls_benefits-catalog_id
                              iv_benefit_id = ls_benefits-benefit_id
                            ).
        ls_benefits-waers = 'TRY'.
        APPEND ls_benefits TO ls_catalog-benefits.

        ls_catalog-count = ls_catalog-count + 1.
      ENDLOOP.

      ls_catalog-guid = iv_guid.
      MODIFY rt_catalogs FROM ls_catalog.
      CLEAR:ls_catalog,ls_benefits.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_catalog_benefits.
    DATA: ls_catalog  TYPE zben_s_catalog,
          lt_catalog  TYPE zben_tt_catalog,
          ls_benefits TYPE zben_s_benefits,
          lt_benefits TYPE zben_tt_benefits.


    SELECT * FROM zben_catalog
      INTO CORRESPONDING FIELDS OF TABLE lt_catalog
      WHERE catalog_id = iv_catalog_id.


    SELECT * FROM zben_benefits
      INTO CORRESPONDING FIELDS OF TABLE lt_benefits
      WHERE catalog_id = iv_catalog_id
        AND benefit_group = zif_ben_constants=>mc_benefit_group_eyh"'EYH'.
        AND benefit_id NE 59."'EYH'.


    LOOP AT lt_catalog INTO ls_catalog.
      ls_catalog-guid = 'GUID_DEFAULT'.
      CLEAR: ls_catalog-count.
      LOOP AT lt_benefits INTO ls_benefits
                          WHERE catalog_id = ls_catalog-catalog_id.
        ls_benefits-guid  = 'GUID_DEFAULT'.
        ls_benefits-file = zcl_ben_file_handler=>get_benefits_image(
                                iv_catalog_id = ls_benefits-catalog_id
                                iv_benefit_id = ls_benefits-benefit_id
                              ).
        ls_benefits-waers = '₺'.
        ls_benefits-plate_related = ls_catalog-plate_related.
        APPEND ls_benefits TO ls_catalog-benefits.

        ls_catalog-count = ls_catalog-count + 1.
      ENDLOOP.


      MODIFY lt_catalog FROM ls_catalog.
      CLEAR:ls_catalog,ls_benefits.
    ENDLOOP.
    es_model-catalogs[] = lt_catalog[].

  ENDMETHOD.


  METHOD get_defined_benefits.

    DATA: lt_tab TYPE pernr_us_tab.
    DATA: lv_pernr TYPE pernr_us-pernr.

    CALL FUNCTION 'HR_GET_EMPLOYEES_FROM_USER'
      EXPORTING
        user   = sy-uname
*       BEGDA  = SY-DATUM
*       ENDDA  = SY-DATUM
*       IV_WITH_AUTHORITY       = 'X'
      TABLES
        ee_tab = lt_tab.


    TRY.
        lv_pernr = lt_tab[ 1 ]-pernr.
      CATCH cx_sy_itab_line_not_found..

    ENDTRY..

    SELECT * FROM zben_defin_ben
      INTO CORRESPONDING FIELDS OF TABLE rt_defined_benefits
      WHERE pernr = lv_pernr
        AND zyear = sy-datum(4)
        AND benefit_group = 'TYH'.

    SELECT *
      FROM zben_benefits
      INTO TABLE @DATA(lt_benefitsx)
      FOR ALL  ENTRIES IN @rt_defined_benefits
      WHERE benefit_id EQ @rt_defined_benefits-benefit_id.

    LOOP AT rt_defined_benefits ASSIGNING FIELD-SYMBOL(<ls_defined>).
      TRY.
          <ls_defined>-benefit_info1 = lt_benefitsx[ benefit_id = <ls_defined>-benefit_id ]-benefit_info1.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    ENDLOOP.


  ENDMETHOD.


  METHOD get_instance.

    IF io_provider IS BOUND.
      rt_provider = io_provider.
    ELSE.
      rt_provider =  NEW zcl_ben_data_provider( ) .
    ENDIF.

  ENDMETHOD.


  method GET_PERIOD.

        SELECT SINGLE * FROM zben_period
          INTO CORRESPONDING FIELDS OF es_period
          WHERE begin_date LE sy-datum
            AND end_date GE sy-datum
            AND active EQ 'X'.

  endmethod.


  METHOD get_root_info.
    DATA: ls_defined_pers TYPE zben_defin_pers.
    DATA: ls_tran_pers TYPE zben_tran_pers.
    DATA: lt_tab TYPE pernr_us_tab.
    DATA: lv_pernr TYPE pernr_us-pernr.
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
        lv_pernr = lt_tab[ 1 ]-pernr.
      CATCH cx_sy_itab_line_not_found..

    ENDTRY.

    SELECT SINGLE * FROM
      zben_defin_pers
      INTO ls_defined_pers
      WHERE pernr = lv_pernr
        AND zyear = sy-datum+0(4).

    SELECT SINGLE * FROM
     zben_tran_pers
     INTO ls_tran_pers
     WHERE pernr = lv_pernr
       AND zyear = sy-datum+0(4)
       AND delete_ind NE 'X'.
*14 000 11800 2200
    MOVE-CORRESPONDING ls_tran_pers TO es_return .

    es_return-defined_fixed_budget    = ls_defined_pers-fixed_budget.
    es_return-majority_budget         = ls_defined_pers-flexible_budget - ls_tran_pers-flexible_budget ."ls_tran_pers-fixed_budget - ls_tran_pers-defined_fixed_budget .
*    es_return-majority_budget         = "ls_tran_pers-fixed_budget - ls_tran_pers-defined_fixed_budget .

    CHECK ls_tran_pers IS INITIAL.

*    SELECT SINGLE * FROM
*      zben_def_per_log
*      INTO ls_defined_pers
*      WHERE pernr = lv_pernr
*        AND zyear = sy-datum+0(4).
*
*    IF ls_defined_pers IS INITIAL .



*    ENDIF.

    MOVE-CORRESPONDING ls_defined_pers TO es_return.
    es_return-actual_budget = es_return-fixed_budget + es_return-flexible_budget.
    es_return-cart_total    = es_return-flexible_budget.
    es_return-remain_total  = es_return-fixed_budget.
    es_return-waers         = 'TRY'.

    es_return-defined_fixed_budget    = ls_defined_pers-fixed_budget.
    es_return-majority_budget         = 0.
  ENDMETHOD.


  METHOD get_text.


    DATA: lv_no            TYPE i,
          lv_no_c(2)       TYPE c,
          lv_fieldname(12) TYPE c.

    FIELD-SYMBOLS : <lv_val> TYPE zben_de_txt_desc.

    SELECT *
      FROM zben_texts
      INTO TABLE @DATA(lt_texts).


    LOOP AT lt_texts INTO DATA(ls_text).
      lv_no = ls_text-text_id+1(2).
      lv_no_c = lv_no.

      lv_fieldname = |ZTEXT{ lv_no_c }|.
      ASSIGN COMPONENT lv_fieldname OF STRUCTURE es_return TO <lv_val>.
      IF <lv_val> IS ASSIGNED.
        <lv_val> = ls_text-text_value.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.


  method SET_STATIC_DATAS.



" gt_catalogs = get_catalogs.
" get_catalog_benefits ->
" get_person_infos  iv_pernr

" get_active_period

  endmethod.
ENDCLASS.
