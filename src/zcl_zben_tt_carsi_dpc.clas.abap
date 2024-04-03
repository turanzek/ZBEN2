class ZCL_ZBEN_TT_CARSI_DPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_DATA
  abstract
  create public .

public section.

  interfaces /IWBEP/IF_SB_DPC_COMM_SERVICES .
  interfaces /IWBEP/IF_SB_GEN_DPC_INJECTION .

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~DELETE_ENTITY
    redefinition .
protected section.

  data mo_injection type ref to /IWBEP/IF_SB_GEN_DPC_INJECTION .

  methods PDFFILESET_UPDATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_PDFFILE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods PDFFILESET_GET_ENTITYSET
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      !IS_PAGING type /IWBEP/S_MGW_PAGING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      !IV_FILTER_STRING type STRING
      !IV_SEARCH_STRING type STRING
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      !ET_ENTITYSET type ZCL_ZBEN_TT_CARSI_MPC=>TT_PDFFILE
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods PDFFILESET_GET_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_PDFFILE
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods PDFFILESET_DELETE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods PDFFILESET_CREATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_PDFFILE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods DEFINEDBENEFITSS_UPDATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_DEFINEDBENEFITS
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods DEFINEDBENEFITSS_GET_ENTITYSET
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      !IS_PAGING type /IWBEP/S_MGW_PAGING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      !IV_FILTER_STRING type STRING
      !IV_SEARCH_STRING type STRING
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      !ET_ENTITYSET type ZCL_ZBEN_TT_CARSI_MPC=>TT_DEFINEDBENEFITS
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods DEFINEDBENEFITSS_GET_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_DEFINEDBENEFITS
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods DEFINEDBENEFITSS_DELETE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods DEFINEDBENEFITSS_CREATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_DEFINEDBENEFITS
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CATALOGSSET_UPDATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_CATALOGS
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CATALOGSSET_GET_ENTITYSET
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      !IS_PAGING type /IWBEP/S_MGW_PAGING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      !IV_FILTER_STRING type STRING
      !IV_SEARCH_STRING type STRING
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      !ET_ENTITYSET type ZCL_ZBEN_TT_CARSI_MPC=>TT_CATALOGS
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CATALOGSSET_GET_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_CATALOGS
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CATALOGSSET_DELETE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CATALOGSSET_CREATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_CATALOGS
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CARTSET_UPDATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_CARTITEMS
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CARTSET_GET_ENTITYSET
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      !IS_PAGING type /IWBEP/S_MGW_PAGING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      !IV_FILTER_STRING type STRING
      !IV_SEARCH_STRING type STRING
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      !ET_ENTITYSET type ZCL_ZBEN_TT_CARSI_MPC=>TT_CARTITEMS
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CARTSET_GET_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_CARTITEMS
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CARTSET_DELETE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CARTSET_CREATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_CARTITEMS
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BENEFITSSET_UPDATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_BENEFITS
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BENEFITSSET_GET_ENTITYSET
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      !IS_PAGING type /IWBEP/S_MGW_PAGING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      !IV_FILTER_STRING type STRING
      !IV_SEARCH_STRING type STRING
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      !ET_ENTITYSET type ZCL_ZBEN_TT_CARSI_MPC=>TT_BENEFITS
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BENEFITSSET_GET_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_BENEFITS
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BENEFITSSET_DELETE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BENEFITSSET_CREATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_BENEFITS
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BENEFITFILESET_UPDATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_BENEFITFILE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BENEFITFILESET_GET_ENTITYSET
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      !IS_PAGING type /IWBEP/S_MGW_PAGING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      !IV_FILTER_STRING type STRING
      !IV_SEARCH_STRING type STRING
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      !ET_ENTITYSET type ZCL_ZBEN_TT_CARSI_MPC=>TT_BENEFITFILE
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BENEFITFILESET_GET_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_BENEFITFILE
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BENEFITFILESET_DELETE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BENEFITFILESET_CREATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_BENEFITFILE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods APPLICATIONSET_UPDATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_APPLICATION
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods APPLICATIONSET_GET_ENTITYSET
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      !IS_PAGING type /IWBEP/S_MGW_PAGING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      !IV_FILTER_STRING type STRING
      !IV_SEARCH_STRING type STRING
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      !ET_ENTITYSET type ZCL_ZBEN_TT_CARSI_MPC=>TT_APPLICATION
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods APPLICATIONSET_GET_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_APPLICATION
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods APPLICATIONSET_DELETE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods APPLICATIONSET_CREATE_ENTITY
    importing
      !IV_ENTITY_NAME type STRING
      !IV_ENTITY_SET_NAME type STRING
      !IV_SOURCE_NAME type STRING
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      !ER_ENTITY type ZCL_ZBEN_TT_CARSI_MPC=>TS_APPLICATION
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .

  methods CHECK_SUBSCRIPTION_AUTHORITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZBEN_TT_CARSI_DPC IMPLEMENTATION.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_ENTITY.
*&----------------------------------------------------------------------------------------------*
*&  Include           /IWBEP/DPC_TEMP_CRT_ENTITY_BASE
*&* This class has been generated on 18.07.2023 11:06:58 in client 655
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC provider subclass - ZCL_ZBEN_TT_CARSI_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA benefitfileset_create_entity TYPE zcl_zben_tt_carsi_mpc=>ts_benefitfile.
 DATA applicationset_create_entity TYPE zcl_zben_tt_carsi_mpc=>ts_application.
 DATA cartset_create_entity TYPE zcl_zben_tt_carsi_mpc=>ts_cartitems.
 DATA definedbenefitss_create_entity TYPE zcl_zben_tt_carsi_mpc=>ts_definedbenefits.
 DATA pdffileset_create_entity TYPE zcl_zben_tt_carsi_mpc=>ts_pdffile.
 DATA benefitsset_create_entity TYPE zcl_zben_tt_carsi_mpc=>ts_benefits.
 DATA catalogsset_create_entity TYPE zcl_zben_tt_carsi_mpc=>ts_catalogs.
 DATA lv_entityset_name TYPE string.

lv_entityset_name = io_tech_request_context->get_entity_set_name( ).

CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  BenefitFileSet
*-------------------------------------------------------------------------*
     WHEN 'BenefitFileSet'.
*     Call the entity set generated method
    benefitfileset_create_entity(
         EXPORTING iv_entity_name     = iv_entity_name
                   iv_entity_set_name = iv_entity_set_name
                   iv_source_name     = iv_source_name
                   io_data_provider   = io_data_provider
                   it_key_tab         = it_key_tab
                   it_navigation_path = it_navigation_path
                   io_tech_request_context = io_tech_request_context
       	 IMPORTING er_entity          = benefitfileset_create_entity
    ).
*     Send specific entity data to the caller interfaces
    copy_data_to_ref(
      EXPORTING
        is_data = benefitfileset_create_entity
      CHANGING
        cr_data = er_entity
   ).

*-------------------------------------------------------------------------*
*             EntitySet -  ApplicationSet
*-------------------------------------------------------------------------*
     WHEN 'ApplicationSet'.
*     Call the entity set generated method
    applicationset_create_entity(
         EXPORTING iv_entity_name     = iv_entity_name
                   iv_entity_set_name = iv_entity_set_name
                   iv_source_name     = iv_source_name
                   io_data_provider   = io_data_provider
                   it_key_tab         = it_key_tab
                   it_navigation_path = it_navigation_path
                   io_tech_request_context = io_tech_request_context
       	 IMPORTING er_entity          = applicationset_create_entity
    ).
*     Send specific entity data to the caller interfaces
    copy_data_to_ref(
      EXPORTING
        is_data = applicationset_create_entity
      CHANGING
        cr_data = er_entity
   ).

*-------------------------------------------------------------------------*
*             EntitySet -  CartItemsSet
*-------------------------------------------------------------------------*
     WHEN 'CartItemsSet'.
*     Call the entity set generated method
    cartset_create_entity(
         EXPORTING iv_entity_name     = iv_entity_name
                   iv_entity_set_name = iv_entity_set_name
                   iv_source_name     = iv_source_name
                   io_data_provider   = io_data_provider
                   it_key_tab         = it_key_tab
                   it_navigation_path = it_navigation_path
                   io_tech_request_context = io_tech_request_context
       	 IMPORTING er_entity          = cartset_create_entity
    ).
*     Send specific entity data to the caller interfaces
    copy_data_to_ref(
      EXPORTING
        is_data = cartset_create_entity
      CHANGING
        cr_data = er_entity
   ).

*-------------------------------------------------------------------------*
*             EntitySet -  DefinedBenefitsSet
*-------------------------------------------------------------------------*
     WHEN 'DefinedBenefitsSet'.
*     Call the entity set generated method
    definedbenefitss_create_entity(
         EXPORTING iv_entity_name     = iv_entity_name
                   iv_entity_set_name = iv_entity_set_name
                   iv_source_name     = iv_source_name
                   io_data_provider   = io_data_provider
                   it_key_tab         = it_key_tab
                   it_navigation_path = it_navigation_path
                   io_tech_request_context = io_tech_request_context
       	 IMPORTING er_entity          = definedbenefitss_create_entity
    ).
*     Send specific entity data to the caller interfaces
    copy_data_to_ref(
      EXPORTING
        is_data = definedbenefitss_create_entity
      CHANGING
        cr_data = er_entity
   ).

*-------------------------------------------------------------------------*
*             EntitySet -  PdfFileSet
*-------------------------------------------------------------------------*
     WHEN 'PdfFileSet'.
*     Call the entity set generated method
    pdffileset_create_entity(
         EXPORTING iv_entity_name     = iv_entity_name
                   iv_entity_set_name = iv_entity_set_name
                   iv_source_name     = iv_source_name
                   io_data_provider   = io_data_provider
                   it_key_tab         = it_key_tab
                   it_navigation_path = it_navigation_path
                   io_tech_request_context = io_tech_request_context
       	 IMPORTING er_entity          = pdffileset_create_entity
    ).
*     Send specific entity data to the caller interfaces
    copy_data_to_ref(
      EXPORTING
        is_data = pdffileset_create_entity
      CHANGING
        cr_data = er_entity
   ).

*-------------------------------------------------------------------------*
*             EntitySet -  BenefitsSet
*-------------------------------------------------------------------------*
     WHEN 'BenefitsSet'.
*     Call the entity set generated method
    benefitsset_create_entity(
         EXPORTING iv_entity_name     = iv_entity_name
                   iv_entity_set_name = iv_entity_set_name
                   iv_source_name     = iv_source_name
                   io_data_provider   = io_data_provider
                   it_key_tab         = it_key_tab
                   it_navigation_path = it_navigation_path
                   io_tech_request_context = io_tech_request_context
       	 IMPORTING er_entity          = benefitsset_create_entity
    ).
*     Send specific entity data to the caller interfaces
    copy_data_to_ref(
      EXPORTING
        is_data = benefitsset_create_entity
      CHANGING
        cr_data = er_entity
   ).

*-------------------------------------------------------------------------*
*             EntitySet -  CatalogsSet
*-------------------------------------------------------------------------*
     WHEN 'CatalogsSet'.
*     Call the entity set generated method
    catalogsset_create_entity(
         EXPORTING iv_entity_name     = iv_entity_name
                   iv_entity_set_name = iv_entity_set_name
                   iv_source_name     = iv_source_name
                   io_data_provider   = io_data_provider
                   it_key_tab         = it_key_tab
                   it_navigation_path = it_navigation_path
                   io_tech_request_context = io_tech_request_context
       	 IMPORTING er_entity          = catalogsset_create_entity
    ).
*     Send specific entity data to the caller interfaces
    copy_data_to_ref(
      EXPORTING
        is_data = catalogsset_create_entity
      CHANGING
        cr_data = er_entity
   ).

  when others.
    super->/iwbep/if_mgw_appl_srv_runtime~create_entity(
       EXPORTING
         iv_entity_name = iv_entity_name
         iv_entity_set_name = iv_entity_set_name
         iv_source_name = iv_source_name
         io_data_provider   = io_data_provider
         it_key_tab = it_key_tab
         it_navigation_path = it_navigation_path
      IMPORTING
        er_entity = er_entity
  ).
ENDCASE.
  endmethod.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~DELETE_ENTITY.
*&----------------------------------------------------------------------------------------------*
*&  Include           /IWBEP/DPC_TEMP_DEL_ENTITY_BASE
*&* This class has been generated on 18.07.2023 11:06:58 in client 655
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC provider subclass - ZCL_ZBEN_TT_CARSI_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA lv_entityset_name TYPE string.

lv_entityset_name = io_tech_request_context->get_entity_set_name( ).

CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  BenefitFileSet
*-------------------------------------------------------------------------*
      when 'BenefitFileSet'.
*     Call the entity set generated method
     benefitfileset_delete_entity(
          EXPORTING iv_entity_name     = iv_entity_name
                    iv_entity_set_name = iv_entity_set_name
                    iv_source_name     = iv_source_name
                    it_key_tab         = it_key_tab
                    it_navigation_path = it_navigation_path
                    io_tech_request_context = io_tech_request_context
     ).

*-------------------------------------------------------------------------*
*             EntitySet -  CartItemsSet
*-------------------------------------------------------------------------*
      when 'CartItemsSet'.
*     Call the entity set generated method
     cartset_delete_entity(
          EXPORTING iv_entity_name     = iv_entity_name
                    iv_entity_set_name = iv_entity_set_name
                    iv_source_name     = iv_source_name
                    it_key_tab         = it_key_tab
                    it_navigation_path = it_navigation_path
                    io_tech_request_context = io_tech_request_context
     ).

*-------------------------------------------------------------------------*
*             EntitySet -  DefinedBenefitsSet
*-------------------------------------------------------------------------*
      when 'DefinedBenefitsSet'.
*     Call the entity set generated method
     definedbenefitss_delete_entity(
          EXPORTING iv_entity_name     = iv_entity_name
                    iv_entity_set_name = iv_entity_set_name
                    iv_source_name     = iv_source_name
                    it_key_tab         = it_key_tab
                    it_navigation_path = it_navigation_path
                    io_tech_request_context = io_tech_request_context
     ).

*-------------------------------------------------------------------------*
*             EntitySet -  CatalogsSet
*-------------------------------------------------------------------------*
      when 'CatalogsSet'.
*     Call the entity set generated method
     catalogsset_delete_entity(
          EXPORTING iv_entity_name     = iv_entity_name
                    iv_entity_set_name = iv_entity_set_name
                    iv_source_name     = iv_source_name
                    it_key_tab         = it_key_tab
                    it_navigation_path = it_navigation_path
                    io_tech_request_context = io_tech_request_context
     ).

*-------------------------------------------------------------------------*
*             EntitySet -  BenefitsSet
*-------------------------------------------------------------------------*
      when 'BenefitsSet'.
*     Call the entity set generated method
     benefitsset_delete_entity(
          EXPORTING iv_entity_name     = iv_entity_name
                    iv_entity_set_name = iv_entity_set_name
                    iv_source_name     = iv_source_name
                    it_key_tab         = it_key_tab
                    it_navigation_path = it_navigation_path
                    io_tech_request_context = io_tech_request_context
     ).

*-------------------------------------------------------------------------*
*             EntitySet -  ApplicationSet
*-------------------------------------------------------------------------*
      when 'ApplicationSet'.
*     Call the entity set generated method
     applicationset_delete_entity(
          EXPORTING iv_entity_name     = iv_entity_name
                    iv_entity_set_name = iv_entity_set_name
                    iv_source_name     = iv_source_name
                    it_key_tab         = it_key_tab
                    it_navigation_path = it_navigation_path
                    io_tech_request_context = io_tech_request_context
     ).

*-------------------------------------------------------------------------*
*             EntitySet -  PdfFileSet
*-------------------------------------------------------------------------*
      when 'PdfFileSet'.
*     Call the entity set generated method
     pdffileset_delete_entity(
          EXPORTING iv_entity_name     = iv_entity_name
                    iv_entity_set_name = iv_entity_set_name
                    iv_source_name     = iv_source_name
                    it_key_tab         = it_key_tab
                    it_navigation_path = it_navigation_path
                    io_tech_request_context = io_tech_request_context
     ).

   when others.
     super->/iwbep/if_mgw_appl_srv_runtime~delete_entity(
        EXPORTING
          iv_entity_name = iv_entity_name
          iv_entity_set_name = iv_entity_set_name
          iv_source_name = iv_source_name
          it_key_tab = it_key_tab
          it_navigation_path = it_navigation_path
 ).
 ENDCASE.
  endmethod.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITY.
*&-----------------------------------------------------------------------------------------------*
*&  Include           /IWBEP/DPC_TEMP_GETENTITY_BASE
*&* This class has been generated  on 18.07.2023 11:06:58 in client 655
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC provider subclass - ZCL_ZBEN_TT_CARSI_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA catalogsset_get_entity TYPE zcl_zben_tt_carsi_mpc=>ts_catalogs.
 DATA definedbenefitss_get_entity TYPE zcl_zben_tt_carsi_mpc=>ts_definedbenefits.
 DATA pdffileset_get_entity TYPE zcl_zben_tt_carsi_mpc=>ts_pdffile.
 DATA benefitsset_get_entity TYPE zcl_zben_tt_carsi_mpc=>ts_benefits.
 DATA cartset_get_entity TYPE zcl_zben_tt_carsi_mpc=>ts_cartitems.
 DATA benefitfileset_get_entity TYPE zcl_zben_tt_carsi_mpc=>ts_benefitfile.
 DATA applicationset_get_entity TYPE zcl_zben_tt_carsi_mpc=>ts_application.
 DATA lv_entityset_name TYPE string.
 DATA lr_entity TYPE REF TO data.       "#EC NEEDED

lv_entityset_name = io_tech_request_context->get_entity_set_name( ).

CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  CatalogsSet
*-------------------------------------------------------------------------*
      WHEN 'CatalogsSet'.
*     Call the entity set generated method
          catalogsset_get_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = catalogsset_get_entity
                         es_response_context = es_response_context
          ).

        IF catalogsset_get_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = catalogsset_get_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  DefinedBenefitsSet
*-------------------------------------------------------------------------*
      WHEN 'DefinedBenefitsSet'.
*     Call the entity set generated method
          definedbenefitss_get_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = definedbenefitss_get_entity
                         es_response_context = es_response_context
          ).

        IF definedbenefitss_get_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = definedbenefitss_get_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  PdfFileSet
*-------------------------------------------------------------------------*
      WHEN 'PdfFileSet'.
*     Call the entity set generated method
          pdffileset_get_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = pdffileset_get_entity
                         es_response_context = es_response_context
          ).

        IF pdffileset_get_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = pdffileset_get_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  BenefitsSet
*-------------------------------------------------------------------------*
      WHEN 'BenefitsSet'.
*     Call the entity set generated method
          benefitsset_get_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = benefitsset_get_entity
                         es_response_context = es_response_context
          ).

        IF benefitsset_get_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = benefitsset_get_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  CartItemsSet
*-------------------------------------------------------------------------*
      WHEN 'CartItemsSet'.
*     Call the entity set generated method
          cartset_get_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = cartset_get_entity
                         es_response_context = es_response_context
          ).

        IF cartset_get_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = cartset_get_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  BenefitFileSet
*-------------------------------------------------------------------------*
      WHEN 'BenefitFileSet'.
*     Call the entity set generated method
          benefitfileset_get_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = benefitfileset_get_entity
                         es_response_context = es_response_context
          ).

        IF benefitfileset_get_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = benefitfileset_get_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  ApplicationSet
*-------------------------------------------------------------------------*
      WHEN 'ApplicationSet'.
*     Call the entity set generated method
          applicationset_get_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = applicationset_get_entity
                         es_response_context = es_response_context
          ).

        IF applicationset_get_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = applicationset_get_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.

      WHEN OTHERS.
        super->/iwbep/if_mgw_appl_srv_runtime~get_entity(
           EXPORTING
             iv_entity_name = iv_entity_name
             iv_entity_set_name = iv_entity_set_name
             iv_source_name = iv_source_name
             it_key_tab = it_key_tab
             it_navigation_path = it_navigation_path
          IMPORTING
            er_entity = er_entity
    ).
 ENDCASE.
  endmethod.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITYSET.
*&----------------------------------------------------------------------------------------------*
*&  Include           /IWBEP/DPC_TMP_ENTITYSET_BASE
*&* This class has been generated on 18.07.2023 11:06:58 in client 655
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC provider subclass - ZCL_ZBEN_TT_CARSI_DPC_EXT
*&-----------------------------------------------------------------------------------------------*
 DATA catalogsset_get_entityset TYPE zcl_zben_tt_carsi_mpc=>tt_catalogs.
 DATA definedbenefitss_get_entityset TYPE zcl_zben_tt_carsi_mpc=>tt_definedbenefits.
 DATA benefitsset_get_entityset TYPE zcl_zben_tt_carsi_mpc=>tt_benefits.
 DATA cartset_get_entityset TYPE zcl_zben_tt_carsi_mpc=>tt_cartitems.
 DATA pdffileset_get_entityset TYPE zcl_zben_tt_carsi_mpc=>tt_pdffile.
 DATA benefitfileset_get_entityset TYPE zcl_zben_tt_carsi_mpc=>tt_benefitfile.
 DATA applicationset_get_entityset TYPE zcl_zben_tt_carsi_mpc=>tt_application.
 DATA lv_entityset_name TYPE string.

lv_entityset_name = io_tech_request_context->get_entity_set_name( ).

CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  CatalogsSet
*-------------------------------------------------------------------------*
   WHEN 'CatalogsSet'.
*     Call the entity set generated method
      catalogsset_get_entityset(
        EXPORTING
         iv_entity_name = iv_entity_name
         iv_entity_set_name = iv_entity_set_name
         iv_source_name = iv_source_name
         it_filter_select_options = it_filter_select_options
         it_order = it_order
         is_paging = is_paging
         it_navigation_path = it_navigation_path
         it_key_tab = it_key_tab
         iv_filter_string = iv_filter_string
         iv_search_string = iv_search_string
         io_tech_request_context = io_tech_request_context
       IMPORTING
         et_entityset = catalogsset_get_entityset
         es_response_context = es_response_context
       ).
*     Send specific entity data to the caller interface
      copy_data_to_ref(
        EXPORTING
          is_data = catalogsset_get_entityset
        CHANGING
          cr_data = er_entityset
      ).

*-------------------------------------------------------------------------*
*             EntitySet -  DefinedBenefitsSet
*-------------------------------------------------------------------------*
   WHEN 'DefinedBenefitsSet'.
*     Call the entity set generated method
      definedbenefitss_get_entityset(
        EXPORTING
         iv_entity_name = iv_entity_name
         iv_entity_set_name = iv_entity_set_name
         iv_source_name = iv_source_name
         it_filter_select_options = it_filter_select_options
         it_order = it_order
         is_paging = is_paging
         it_navigation_path = it_navigation_path
         it_key_tab = it_key_tab
         iv_filter_string = iv_filter_string
         iv_search_string = iv_search_string
         io_tech_request_context = io_tech_request_context
       IMPORTING
         et_entityset = definedbenefitss_get_entityset
         es_response_context = es_response_context
       ).
*     Send specific entity data to the caller interface
      copy_data_to_ref(
        EXPORTING
          is_data = definedbenefitss_get_entityset
        CHANGING
          cr_data = er_entityset
      ).

*-------------------------------------------------------------------------*
*             EntitySet -  BenefitsSet
*-------------------------------------------------------------------------*
   WHEN 'BenefitsSet'.
*     Call the entity set generated method
      benefitsset_get_entityset(
        EXPORTING
         iv_entity_name = iv_entity_name
         iv_entity_set_name = iv_entity_set_name
         iv_source_name = iv_source_name
         it_filter_select_options = it_filter_select_options
         it_order = it_order
         is_paging = is_paging
         it_navigation_path = it_navigation_path
         it_key_tab = it_key_tab
         iv_filter_string = iv_filter_string
         iv_search_string = iv_search_string
         io_tech_request_context = io_tech_request_context
       IMPORTING
         et_entityset = benefitsset_get_entityset
         es_response_context = es_response_context
       ).
*     Send specific entity data to the caller interface
      copy_data_to_ref(
        EXPORTING
          is_data = benefitsset_get_entityset
        CHANGING
          cr_data = er_entityset
      ).

*-------------------------------------------------------------------------*
*             EntitySet -  CartItemsSet
*-------------------------------------------------------------------------*
   WHEN 'CartItemsSet'.
*     Call the entity set generated method
      cartset_get_entityset(
        EXPORTING
         iv_entity_name = iv_entity_name
         iv_entity_set_name = iv_entity_set_name
         iv_source_name = iv_source_name
         it_filter_select_options = it_filter_select_options
         it_order = it_order
         is_paging = is_paging
         it_navigation_path = it_navigation_path
         it_key_tab = it_key_tab
         iv_filter_string = iv_filter_string
         iv_search_string = iv_search_string
         io_tech_request_context = io_tech_request_context
       IMPORTING
         et_entityset = cartset_get_entityset
         es_response_context = es_response_context
       ).
*     Send specific entity data to the caller interface
      copy_data_to_ref(
        EXPORTING
          is_data = cartset_get_entityset
        CHANGING
          cr_data = er_entityset
      ).

*-------------------------------------------------------------------------*
*             EntitySet -  PdfFileSet
*-------------------------------------------------------------------------*
   WHEN 'PdfFileSet'.
*     Call the entity set generated method
      pdffileset_get_entityset(
        EXPORTING
         iv_entity_name = iv_entity_name
         iv_entity_set_name = iv_entity_set_name
         iv_source_name = iv_source_name
         it_filter_select_options = it_filter_select_options
         it_order = it_order
         is_paging = is_paging
         it_navigation_path = it_navigation_path
         it_key_tab = it_key_tab
         iv_filter_string = iv_filter_string
         iv_search_string = iv_search_string
         io_tech_request_context = io_tech_request_context
       IMPORTING
         et_entityset = pdffileset_get_entityset
         es_response_context = es_response_context
       ).
*     Send specific entity data to the caller interface
      copy_data_to_ref(
        EXPORTING
          is_data = pdffileset_get_entityset
        CHANGING
          cr_data = er_entityset
      ).

*-------------------------------------------------------------------------*
*             EntitySet -  BenefitFileSet
*-------------------------------------------------------------------------*
   WHEN 'BenefitFileSet'.
*     Call the entity set generated method
      benefitfileset_get_entityset(
        EXPORTING
         iv_entity_name = iv_entity_name
         iv_entity_set_name = iv_entity_set_name
         iv_source_name = iv_source_name
         it_filter_select_options = it_filter_select_options
         it_order = it_order
         is_paging = is_paging
         it_navigation_path = it_navigation_path
         it_key_tab = it_key_tab
         iv_filter_string = iv_filter_string
         iv_search_string = iv_search_string
         io_tech_request_context = io_tech_request_context
       IMPORTING
         et_entityset = benefitfileset_get_entityset
         es_response_context = es_response_context
       ).
*     Send specific entity data to the caller interface
      copy_data_to_ref(
        EXPORTING
          is_data = benefitfileset_get_entityset
        CHANGING
          cr_data = er_entityset
      ).

*-------------------------------------------------------------------------*
*             EntitySet -  ApplicationSet
*-------------------------------------------------------------------------*
   WHEN 'ApplicationSet'.
*     Call the entity set generated method
      applicationset_get_entityset(
        EXPORTING
         iv_entity_name = iv_entity_name
         iv_entity_set_name = iv_entity_set_name
         iv_source_name = iv_source_name
         it_filter_select_options = it_filter_select_options
         it_order = it_order
         is_paging = is_paging
         it_navigation_path = it_navigation_path
         it_key_tab = it_key_tab
         iv_filter_string = iv_filter_string
         iv_search_string = iv_search_string
         io_tech_request_context = io_tech_request_context
       IMPORTING
         et_entityset = applicationset_get_entityset
         es_response_context = es_response_context
       ).
*     Send specific entity data to the caller interface
      copy_data_to_ref(
        EXPORTING
          is_data = applicationset_get_entityset
        CHANGING
          cr_data = er_entityset
      ).

    WHEN OTHERS.
      super->/iwbep/if_mgw_appl_srv_runtime~get_entityset(
        EXPORTING
          iv_entity_name = iv_entity_name
          iv_entity_set_name = iv_entity_set_name
          iv_source_name = iv_source_name
          it_filter_select_options = it_filter_select_options
          it_order = it_order
          is_paging = is_paging
          it_navigation_path = it_navigation_path
          it_key_tab = it_key_tab
          iv_filter_string = iv_filter_string
          iv_search_string = iv_search_string
          io_tech_request_context = io_tech_request_context
       IMPORTING
         er_entityset = er_entityset ).
 ENDCASE.
  endmethod.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_ENTITY.
*&----------------------------------------------------------------------------------------------*
*&  Include           /IWBEP/DPC_TEMP_UPD_ENTITY_BASE
*&* This class has been generated on 18.07.2023 11:06:58 in client 655
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC provider subclass - ZCL_ZBEN_TT_CARSI_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA pdffileset_update_entity TYPE zcl_zben_tt_carsi_mpc=>ts_pdffile.
 DATA benefitfileset_update_entity TYPE zcl_zben_tt_carsi_mpc=>ts_benefitfile.
 DATA cartset_update_entity TYPE zcl_zben_tt_carsi_mpc=>ts_cartitems.
 DATA definedbenefitss_update_entity TYPE zcl_zben_tt_carsi_mpc=>ts_definedbenefits.
 DATA catalogsset_update_entity TYPE zcl_zben_tt_carsi_mpc=>ts_catalogs.
 DATA benefitsset_update_entity TYPE zcl_zben_tt_carsi_mpc=>ts_benefits.
 DATA applicationset_update_entity TYPE zcl_zben_tt_carsi_mpc=>ts_application.
 DATA lv_entityset_name TYPE string.
 DATA lr_entity TYPE REF TO data. "#EC NEEDED

lv_entityset_name = io_tech_request_context->get_entity_set_name( ).

CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  PdfFileSet
*-------------------------------------------------------------------------*
      WHEN 'PdfFileSet'.
*     Call the entity set generated method
          pdffileset_update_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         io_data_provider   = io_data_provider
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = pdffileset_update_entity
          ).
       IF pdffileset_update_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = pdffileset_update_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  BenefitFileSet
*-------------------------------------------------------------------------*
      WHEN 'BenefitFileSet'.
*     Call the entity set generated method
          benefitfileset_update_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         io_data_provider   = io_data_provider
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = benefitfileset_update_entity
          ).
       IF benefitfileset_update_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = benefitfileset_update_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  CartItemsSet
*-------------------------------------------------------------------------*
      WHEN 'CartItemsSet'.
*     Call the entity set generated method
          cartset_update_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         io_data_provider   = io_data_provider
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = cartset_update_entity
          ).
       IF cartset_update_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = cartset_update_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  DefinedBenefitsSet
*-------------------------------------------------------------------------*
      WHEN 'DefinedBenefitsSet'.
*     Call the entity set generated method
          definedbenefitss_update_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         io_data_provider   = io_data_provider
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = definedbenefitss_update_entity
          ).
       IF definedbenefitss_update_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = definedbenefitss_update_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  CatalogsSet
*-------------------------------------------------------------------------*
      WHEN 'CatalogsSet'.
*     Call the entity set generated method
          catalogsset_update_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         io_data_provider   = io_data_provider
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = catalogsset_update_entity
          ).
       IF catalogsset_update_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = catalogsset_update_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  BenefitsSet
*-------------------------------------------------------------------------*
      WHEN 'BenefitsSet'.
*     Call the entity set generated method
          benefitsset_update_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         io_data_provider   = io_data_provider
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = benefitsset_update_entity
          ).
       IF benefitsset_update_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = benefitsset_update_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
*-------------------------------------------------------------------------*
*             EntitySet -  ApplicationSet
*-------------------------------------------------------------------------*
      WHEN 'ApplicationSet'.
*     Call the entity set generated method
          applicationset_update_entity(
               EXPORTING iv_entity_name     = iv_entity_name
                         iv_entity_set_name = iv_entity_set_name
                         iv_source_name     = iv_source_name
                         io_data_provider   = io_data_provider
                         it_key_tab         = it_key_tab
                         it_navigation_path = it_navigation_path
                         io_tech_request_context = io_tech_request_context
             	 IMPORTING er_entity          = applicationset_update_entity
          ).
       IF applicationset_update_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = applicationset_update_entity
            CHANGING
              cr_data = er_entity
          ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
      WHEN OTHERS.
        super->/iwbep/if_mgw_appl_srv_runtime~update_entity(
           EXPORTING
             iv_entity_name = iv_entity_name
             iv_entity_set_name = iv_entity_set_name
             iv_source_name = iv_source_name
             io_data_provider   = io_data_provider
             it_key_tab = it_key_tab
             it_navigation_path = it_navigation_path
          IMPORTING
            er_entity = er_entity
    ).
 ENDCASE.
  endmethod.


  method /IWBEP/IF_SB_DPC_COMM_SERVICES~COMMIT_WORK.
* Call RFC commit work functionality
DATA lt_message      TYPE bapiret2. "#EC NEEDED
DATA lv_message_text TYPE BAPI_MSG.
DATA lo_logger       TYPE REF TO /iwbep/cl_cos_logger.
DATA lv_subrc        TYPE syst-subrc.

lo_logger = /iwbep/if_mgw_conv_srv_runtime~get_logger( ).

  IF iv_rfc_dest IS INITIAL OR iv_rfc_dest EQ 'NONE'.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
      wait   = abap_true
    IMPORTING
      return = lt_message.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      DESTINATION iv_rfc_dest
    EXPORTING
      wait                  = abap_true
    IMPORTING
      return                = lt_message
    EXCEPTIONS
      communication_failure = 1000 MESSAGE lv_message_text
      system_failure        = 1001 MESSAGE lv_message_text
      OTHERS                = 1002.

  IF sy-subrc <> 0.
    lv_subrc = sy-subrc.
    /iwbep/cl_sb_gen_dpc_rt_util=>rfc_exception_handling(
        EXPORTING
          iv_subrc            = lv_subrc
          iv_exp_message_text = lv_message_text
          io_logger           = lo_logger ).
  ENDIF.
  ENDIF.
  endmethod.


  method /IWBEP/IF_SB_DPC_COMM_SERVICES~GET_GENERATION_STRATEGY.
* Get generation strategy
  rv_generation_strategy = '1'.
  endmethod.


  method /IWBEP/IF_SB_DPC_COMM_SERVICES~LOG_MESSAGE.
* Log message in the application log
DATA lo_logger TYPE REF TO /iwbep/cl_cos_logger.
DATA lv_text TYPE /iwbep/sup_msg_longtext.

  MESSAGE ID iv_msg_id TYPE iv_msg_type NUMBER iv_msg_number
    WITH iv_msg_v1 iv_msg_v2 iv_msg_v3 iv_msg_v4 INTO lv_text.

  lo_logger = mo_context->get_logger( ).
  lo_logger->log_message(
    EXPORTING
     iv_msg_type   = iv_msg_type
     iv_msg_id     = iv_msg_id
     iv_msg_number = iv_msg_number
     iv_msg_text   = lv_text
     iv_msg_v1     = iv_msg_v1
     iv_msg_v2     = iv_msg_v2
     iv_msg_v3     = iv_msg_v3
     iv_msg_v4     = iv_msg_v4
     iv_agent      = 'DPC' ).
  endmethod.


  method /IWBEP/IF_SB_DPC_COMM_SERVICES~RFC_EXCEPTION_HANDLING.
* RFC call exception handling
DATA lo_logger  TYPE REF TO /iwbep/cl_cos_logger.

lo_logger = /iwbep/if_mgw_conv_srv_runtime~get_logger( ).

/iwbep/cl_sb_gen_dpc_rt_util=>rfc_exception_handling(
  EXPORTING
    iv_subrc            = iv_subrc
    iv_exp_message_text = iv_exp_message_text
    io_logger           = lo_logger ).
  endmethod.


  method /IWBEP/IF_SB_DPC_COMM_SERVICES~RFC_SAVE_LOG.
  DATA lo_logger  TYPE REF TO /iwbep/cl_cos_logger.
  DATA lo_message_container TYPE REF TO /iwbep/if_message_container.

  lo_logger = /iwbep/if_mgw_conv_srv_runtime~get_logger( ).
  lo_message_container = /iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

  " Save the RFC call log in the application log
  /iwbep/cl_sb_gen_dpc_rt_util=>rfc_save_log(
    EXPORTING
      is_return            = is_return
      iv_entity_type       = iv_entity_type
      it_return            = it_return
      it_key_tab           = it_key_tab
      io_logger            = lo_logger
      io_message_container = lo_message_container ).
  endmethod.


  method /IWBEP/IF_SB_DPC_COMM_SERVICES~SET_INJECTION.
* Unit test injection
  IF io_unit IS BOUND.
    mo_injection = io_unit.
  ELSE.
    mo_injection = me.
  ENDIF.
  endmethod.


  method APPLICATIONSET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'APPLICATIONSET_CREATE_ENTITY'.
  endmethod.


  method APPLICATIONSET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'APPLICATIONSET_DELETE_ENTITY'.
  endmethod.


  method APPLICATIONSET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'APPLICATIONSET_GET_ENTITY'.
  endmethod.


  method APPLICATIONSET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'APPLICATIONSET_GET_ENTITYSET'.
  endmethod.


  method APPLICATIONSET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'APPLICATIONSET_UPDATE_ENTITY'.
  endmethod.


  method BENEFITFILESET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BENEFITFILESET_CREATE_ENTITY'.
  endmethod.


  method BENEFITFILESET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BENEFITFILESET_DELETE_ENTITY'.
  endmethod.


  method BENEFITFILESET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BENEFITFILESET_GET_ENTITY'.
  endmethod.


  method BENEFITFILESET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BENEFITFILESET_GET_ENTITYSET'.
  endmethod.


  method BENEFITFILESET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BENEFITFILESET_UPDATE_ENTITY'.
  endmethod.


  method BENEFITSSET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BENEFITSSET_CREATE_ENTITY'.
  endmethod.


  method BENEFITSSET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BENEFITSSET_DELETE_ENTITY'.
  endmethod.


  method BENEFITSSET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BENEFITSSET_GET_ENTITY'.
  endmethod.


  method BENEFITSSET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BENEFITSSET_GET_ENTITYSET'.
  endmethod.


  method BENEFITSSET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BENEFITSSET_UPDATE_ENTITY'.
  endmethod.


  method CARTSET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CARTSET_CREATE_ENTITY'.
  endmethod.


  method CARTSET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CARTSET_DELETE_ENTITY'.
  endmethod.


  method CARTSET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CARTSET_GET_ENTITY'.
  endmethod.


  method CARTSET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CARTSET_GET_ENTITYSET'.
  endmethod.


  method CARTSET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CARTSET_UPDATE_ENTITY'.
  endmethod.


  method CATALOGSSET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CATALOGSSET_CREATE_ENTITY'.
  endmethod.


  method CATALOGSSET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CATALOGSSET_DELETE_ENTITY'.
  endmethod.


  method CATALOGSSET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CATALOGSSET_GET_ENTITY'.
  endmethod.


  method CATALOGSSET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CATALOGSSET_GET_ENTITYSET'.
  endmethod.


  method CATALOGSSET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CATALOGSSET_UPDATE_ENTITY'.
  endmethod.


  method CHECK_SUBSCRIPTION_AUTHORITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'CHECK_SUBSCRIPTION_AUTHORITY'.
  endmethod.


  method DEFINEDBENEFITSS_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'DEFINEDBENEFITSS_CREATE_ENTITY'.
  endmethod.


  method DEFINEDBENEFITSS_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'DEFINEDBENEFITSS_DELETE_ENTITY'.
  endmethod.


  method DEFINEDBENEFITSS_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'DEFINEDBENEFITSS_GET_ENTITY'.
  endmethod.


  method DEFINEDBENEFITSS_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'DEFINEDBENEFITSS_GET_ENTITYSET'.
  endmethod.


  method DEFINEDBENEFITSS_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'DEFINEDBENEFITSS_UPDATE_ENTITY'.
  endmethod.


  method PDFFILESET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'PDFFILESET_CREATE_ENTITY'.
  endmethod.


  method PDFFILESET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'PDFFILESET_DELETE_ENTITY'.
  endmethod.


  method PDFFILESET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'PDFFILESET_GET_ENTITY'.
  endmethod.


  method PDFFILESET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'PDFFILESET_GET_ENTITYSET'.
  endmethod.


  method PDFFILESET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'PDFFILESET_UPDATE_ENTITY'.
  endmethod.
ENDCLASS.
