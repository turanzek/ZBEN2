class ZCL_ZBEN_TT_CARSI_DPC_EXT definition
  public
  inheriting from ZCL_ZBEN_TT_CARSI_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.

  methods APPLICATIONSET_CREATE_ENTITY
    redefinition .
  methods APPLICATIONSET_GET_ENTITY
    redefinition .
  methods APPLICATIONSET_GET_ENTITYSET
    redefinition .
  methods BENEFITSSET_GET_ENTITY
    redefinition .
  methods BENEFITSSET_GET_ENTITYSET
    redefinition .
  methods CARTSET_CREATE_ENTITY
    redefinition .
  methods CARTSET_DELETE_ENTITY
    redefinition .
  methods CARTSET_GET_ENTITY
    redefinition .
  methods CARTSET_GET_ENTITYSET
    redefinition .
  methods CATALOGSSET_CREATE_ENTITY
    redefinition .
  methods CATALOGSSET_GET_ENTITY
    redefinition .
  methods CATALOGSSET_GET_ENTITYSET
    redefinition .
  methods DEFINEDBENEFITSS_GET_ENTITY
    redefinition .
  methods DEFINEDBENEFITSS_GET_ENTITYSET
    redefinition .
  methods PDFFILESET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZBEN_TT_CARSI_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
    DATA: ls_model  TYPE zben_s_app_model.
    DATA: lo_exception TYPE REF TO /iwbep/cx_mgw_tech_exception.

    DATA lv_text TYPE bapi_msg.


    CASE iv_entity_name.
      WHEN 'Application'.
      WHEN OTHERS.
        RETURN.
    ENDCASE.


    io_data_provider->read_entry_data( IMPORTING es_data = ls_model ).
    IF ls_model-action_type = 'ADD_TO_BOX'.
      zcl_ben_odata_adapter=>add_to_box( CHANGING  cs_model = ls_model ) .
    ELSEIF ls_model-action_type = 'SAVE_BOX'.
      zcl_ben_odata_adapter=>process_approve_selection( CHANGING  cs_model = ls_model ) .
    ELSEIF ls_model-action_type = 'RESET'.
        zcl_ben_odata_adapter=>process_reset_selection( CHANGING  cs_model = ls_model ) .

    ENDIF.



    DATA(lt_return) = zcl_ben_odata_adapter=>get_return( ) .

*
*    ls_model-last_time = sy-uzeit.
*    ls_model-last_date = sy-datum.
*    ls_model-last_user = sy-uname.


    LOOP AT lt_return INTO DATA(ls_return) WHERE type CA 'EAX'.
    ENDLOOP.
    IF sy-subrc IS INITIAL.
      CREATE OBJECT lo_exception.
      lo_exception->get_msg_container( )->add_messages_from_bapi( it_bapi_messages = lt_return ).


      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number WITH ls_return-message_v1
                                                                               ls_return-message_v2
                                                                               ls_return-message_v3
                                                                               ls_return-message_v4 INTO lv_text.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message           = lv_text
          message_container = lo_exception->get_msg_container( ).
    ENDIF.

*>>>>> added by ZTURAN 08.07.2023 21:57:24
    DATA: lv_guid      TYPE sysuuid_c32,
          ls_root_info TYPE zben_s_root_info.
    DATA: lo_provider TYPE REF TO zcl_ben_data_provider.
    CREATE OBJECT lo_provider.
    lo_provider->get_root_info(
     EXPORTING
        iv_guid         = lv_guid
    IMPORTING
        es_return = ls_root_info ) .
    ls_model-guid = lv_guid = 'GUID_DEFAULT'.
    MOVE-CORRESPONDING ls_root_info TO ls_model-root_info.


    TRY.
        lo_provider->get_period(
          IMPORTING
             es_period = DATA(ls_period) ).

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    SELECT *
      FROM zben_tran_ben
      INTO CORRESPONDING FIELDS OF TABLE ls_model-cart_items
      WHERE pernr EQ ls_root_info-pernr AND
            zyear EQ ls_period-begin_date(4)
        AND delete_ind NE 'X'. .


    LOOP AT ls_model-cart_items ASSIGNING FIELD-SYMBOL(<ls_items>).

      <ls_items>-file  =  zcl_ben_file_handler=>get_benefits_image(
                              iv_catalog_id = <ls_items>-catalog_id
                              iv_benefit_id = <ls_items>-benefit_id
                            ).

    ENDLOOP.
*>>>>> ended by ZTURAN 08.07.2023 21:57:24

    copy_data_to_ref( EXPORTING  is_data = ls_model
                       CHANGING  cr_data = er_deep_entity ).

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entity.
**TRY.
    DATA: lv_guid       TYPE sysuuid_c32,
          lv_catalog_id TYPE zben_s_catalog-catalog_id,
          lt_benefits   TYPE zben_tt_benefits,
          ls_period     TYPE zben_period.

    DATA: ls_model TYPE zben_s_app_model,
          lt_model TYPE TABLE OF zben_s_app_model.

    DATA: lo_data_provider TYPE REF TO zcl_ben_data_provider.
    CREATE OBJECT lo_data_provider.

    TRY.
        lo_data_provider->get_period(
          IMPORTING
             es_period = ls_period ).

      CATCH cx_sy_itab_line_not_found.

    ENDTRY.

    CHECK ls_period IS NOT INITIAL.



    CASE iv_entity_name.
      WHEN 'Catalogs'.

        DATA(lv_guidx) =  VALUE #( it_key_tab[ name = 'Guid' ]-value OPTIONAL ).
        lv_guid = lv_guidx.

        DATA(ls_catalog_id) = VALUE #( it_key_tab[ name = 'CatalogId' ]-value OPTIONAL ).
        lv_catalog_id = ls_catalog_id.

        CHECK lv_guid IS NOT INITIAL AND lv_catalog_id IS NOT INITIAL.

        CALL METHOD lo_data_provider->get_catalog_benefits
          EXPORTING
            iv_guid       = lv_guid
            iv_catalog_id = lv_catalog_id
          IMPORTING
*           et_benefits   = lt_benefits
            es_model      = ls_model.


        TRY.
            ls_model-catalogs[ 1 ]-guid = lv_guid.
          CATCH cx_sy_itab_line_not_found.

        ENDTRY.


        TRY.
            copy_data_to_ref( EXPORTING  is_data = ls_model-catalogs[ 1 ]
                                  CHANGING  cr_data = er_entity ).
          CATCH cx_sy_itab_line_not_found..

        ENDTRY.




      WHEN OTHERS.
        RETURN.
    ENDCASE.



  ENDMETHOD.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
**  EXPORTING
**    iv_entity_name           =
**    iv_entity_set_name       =
**    iv_source_name           =
**    it_filter_select_options =
**    it_order                 =
**    is_paging                =
**    it_navigation_path       =
**    it_key_tab               =
**    iv_filter_string         =
**    iv_search_string         =
**    io_expand                =
**    io_tech_request_context  =
**  IMPORTING
**    er_entityset             =
**    et_expanded_clauses      =
**    et_expanded_tech_clauses =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA ls_stream  TYPE ty_s_media_resource.
    DATA(lv_entity_set_name) = io_tech_request_context->get_entity_set_name( ).
    DATA(lt_keys) = io_tech_request_context->get_keys( ).
    DATA: ls_file     TYPE zben_s_files.
    DATA: ls_return TYPE  bapiret2.
    DATA: lv_filename TYPE char255.
    DATA: len TYPE i.
    DATA: ls_files  TYPE zben_s_images.

    DATA  : lv_string TYPE string.
    DATA: lv_decodedx     TYPE xstring,
          lt_data         TYPE solix_tab,
          lv_bin_filesize TYPE i.
    DATA: xstring            TYPE xstring.
    DATA: lo_cached_response TYPE REF TO if_http_response.
*    CASE lv_entity_set_name.
*      WHEN 'FilesSet'.
    DATA ls_lheader TYPE ihttpnvp.



*TYPES: BEGIN OF ts_header,
*    name TYPE ihttpnvp-name,
*    value TYPE ihttpnvp-value,
*    mime_type TYPE string,
*END OF ts_header.
*
*data:ls_lheader type ts_header.

    ls_file-catalog_id = VALUE #( lt_keys[ name = 'CATALOG_ID' ]-value OPTIONAL ).
    ls_file-benefit_id      = VALUE #( lt_keys[ name = 'BENEFIT_ID' ]-value OPTIONAL ).

    SELECT SINGLE * FROM zben_bnft_image
     INTO CORRESPONDING FIELDS OF  ls_file
      WHERE catalog_id = ls_file-catalog_id
         AND benefit_id = ls_file-benefit_id.
    ls_stream-value       = ls_file-value.

    ls_stream-mime_type   =  ls_stream-mime_type." = 'application/pdf'.
    lv_filename = escape( val = ls_file-file_name format = cl_abap_format=>e_url ).
    ls_lheader-name = 'Content-Disposition'.
    ls_lheader-value = |inline;  filename="{ lv_filename }"|.

    set_header( is_header = ls_lheader ).

    copy_data_to_ref( EXPORTING is_data = ls_stream
                  CHANGING  cr_data = er_stream ).
*
*TYPES: BEGIN OF is_header_ref,
*    ref_header TYPE ts_header,
*END OF is_header_ref.
*
*dATA: ls_header LIKE is_header.
*DATA: ls_header_ref TYPE is_header_ref.
*ls_header_ref-ref_header = ls_header.
*
*set_header( is_header = ls_header_ref ).

*ls_header_ref-ref_header = ls_lheader.

****    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
****      EXPORTING
****        buffer        = ls_stream-value
*****       APPEND_TO_TABLE       = ' '
****      IMPORTING
****        output_length = lv_bin_filesize
****      TABLES
****        binary_tab    = lt_data.
****
****
****
****    ls_lheader-name = 'Content-Disposition'.
****    ls_lheader-value = 'inline; filename="PDF.pdf";'.
*****    ls_lheader-mime_type = 'application/pdf'.
****    set_header( is_header = ls_lheader ).
****
****    copy_data_to_ref(
****      EXPORTING
****          is_data = lt_data
****      CHANGING
****          cr_data = er_stream ).



*
* CALL METHOD lo_document->download
*              RECEIVING
*                rs_document_content = ls_document_content.
*
*            FIELD-SYMBOLS <ls_stream> TYPE /iwbep/cl_mgw_abs_data=>ty_s_media_resource.
*            CREATE DATA er_stream TYPE /iwbep/cl_mgw_abs_data=>ty_s_media_resource.
*            ASSIGN er_stream->* TO <ls_stream>.
*
*            <ls_stream>-mime_type = ls_stream-mime_type.
*            <ls_stream>-value = ls_file-value.
*
*            DATA(lv_encoded_filename) = escape( val = ls_file-file_name format = cl_abap_format=>e_url ).
*            data(lv_utf8_encoded_filename) = lv_encoded_filename.
*            REPLACE ALL OCCURRENCES OF ',' IN lv_utf8_encoded_filename WITH '%2C'. "#EC NOTEXT
*            REPLACE ALL OCCURRENCES OF ';' IN lv_utf8_encoded_filename WITH '%3B'. "#EC NOTEXT
*            "This is the important part here.
*            ls_lheader-name  =  'Content-Disposition'.           "#EC NOTEXT
*            ls_lheader-value = 'inline; filename=' && lv_encoded_filename && ';'.
*
*            set_header( ls_lheader ).
  ENDMETHOD.


  METHOD applicationset_create_entity.
**TRY.
*CALL METHOD SUPER->APPLICATIONSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.


    DATA: ls_model  TYPE zben_s_app_model.
    DATA: lo_exception TYPE REF TO /iwbep/cx_mgw_tech_exception.

    DATA lv_text TYPE bapi_msg.
*
*
*    CASE iv_entity_name.
*      WHEN 'Application'.
*      WHEN OTHERS.
*        RETURN.
*    ENDCASE.


    io_data_provider->read_entry_data( IMPORTING es_data = ls_model ).
    IF ls_model-action_type = 'SELL'.
      zcl_ben_odata_adapter=>sell_amount( CHANGING  cs_model = ls_model ) ..
    ELSEIF ls_model-action_type = 'INITIAL'.
      IF ls_model-root_info-change_selected EQ 'X'.
        zcl_ben_odata_adapter=>PROCESS_CHANGE_SELECTION( CHANGING  cs_model = ls_model ) .
      ELSEIF ls_model-root_info-default_selected EQ 'X'.
        zcl_ben_odata_adapter=>process_default_selection( CHANGING  cs_model = ls_model ) ..
      ENDIF.

      UPDATE zben_tran_pers SET user_accepted  = ls_model-root_info-user_accepted
      WHERE pernr EQ ls_model-root_info-pernr AND
            zyear EQ ls_model-root_info-zyear.
      IF sy-subrc IS INITIAL .
        COMMIT WORK AND WAIT .
      ELSE.
        ROLLBACK WORK.
      ENDIF.

    ENDIF.



    DATA(lt_return) = zcl_ben_odata_adapter=>get_return( ) .

*
*    ls_model-last_time = sy-uzeit.
*    ls_model-last_date = sy-datum.
*    ls_model-last_user = sy-uname.


    LOOP AT lt_return INTO DATA(ls_return) WHERE type CA 'EAX'.
    ENDLOOP.
    IF sy-subrc IS INITIAL.
      CREATE OBJECT lo_exception.
      lo_exception->get_msg_container( )->add_messages_from_bapi( it_bapi_messages = lt_return ).


      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number WITH ls_return-message_v1
                                                                               ls_return-message_v2
                                                                               ls_return-message_v3
                                                                               ls_return-message_v4 INTO lv_text.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message           = lv_text
          message_container = lo_exception->get_msg_container( ).
    ENDIF.
*
    er_entity-root_info = ls_model-root_info.
*    copy_data_to_ref( EXPORTING  is_data = ls_model
*                       CHANGING  cr_data = er_entity ).

  ENDMETHOD.


  METHOD applicationset_get_entity.
**TRY.
*CALL METHOD SUPER->APPLICATIONSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.


*    DATA: lv_guid TYPE sysuuid_c32.
**          lv_app  TYPE zmm_app_id.
*    DATA: ls_defined_pers TYPE zben_s_person_info.
*
*    DATA: lo_provider TYPE REF TO zcl_ben_data_provider.
*    CREATE OBJECT lo_provider.
*
*    DATA(ls_guid) =  IT_KEY_TAB[ NAME = 'Guid' ].
*    lv_guid = ls_guid-value.
*
*    CHECK lv_guid IS NOT INITIAL ."AND lv_app IS NOT INITIAL.
*
*    lo_provider->get_defined_pers(
*     EXPORTING
*        iv_guid         = lv_guid
*     IMPORTING
*    es_defined_pers = ls_defined_pers ) .
*
**
**    lo_provider->get_texts(
**     EXPORTING
**        iv_guid         = lv_guid
**     IMPORTING
**    es_defined_pers = ls_text ) .
**    es_response_context-count = lines( zcl_hay_model=>get_application_model( )-data_model ).
*
*
*    DATA: ls_model TYPE ZCL_ZBEN_TT_CARSI_MPC=>TS_APPLICATION."zben_s_app_model.
*    ls_model-guid = lv_guid.
*    MOVE-CORRESPONDING ls_defined_pers TO ls_model-personel_info.
**    APPEND ls_model TO et_entityset.
*
*    copy_data_to_ref( EXPORTING  is_data = ls_model
*                       CHANGING  cr_data = er_entity ).


    DATA: ls_model TYPE zcl_zben_tt_carsi_mpc=>ts_application,
          lt_model TYPE zcl_zben_tt_carsi_mpc=>tt_application.
    DATA: lv_guid      TYPE sysuuid_c32,
          ls_root_info TYPE zben_s_root_info,
          ls_period    TYPE zben_period,
          ls_text    TYPE zben_s_text.

    DATA: lo_provider TYPE REF TO zcl_ben_data_provider.
    CREATE OBJECT lo_provider.


    TRY.
        lo_provider->get_period(
          IMPORTING
             es_period = ls_period ).

      CATCH cx_sy_itab_line_not_found.

    ENDTRY.

    CHECK ls_period IS NOT INITIAL.
*root info sepet tutar bilgileri
    lo_provider->get_root_info(
     EXPORTING
        iv_guid         = lv_guid
     IMPORTING
    es_return = ls_root_info ) .

    MOVE-CORRESPONDING ls_root_info TO er_entity-root_info.
    er_entity-guid = lv_guid = 'GUID_DEFAULT'.

*sabit metinler
    lo_provider->get_text(
     EXPORTING
        iv_guid         = lv_guid
     IMPORTING
    es_return = ls_text ) .

    MOVE-CORRESPONDING ls_text TO er_entity-text.
  ENDMETHOD.


  METHOD applicationset_get_entityset.
**TRY.
*CALL METHOD SUPER->APPLICATIONSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.


    DATA: ls_model TYPE zcl_zben_tt_carsi_mpc=>ts_application,
          lt_model TYPE zcl_zben_tt_carsi_mpc=>tt_application.
    DATA: lv_guid      TYPE sysuuid_c32,
          ls_root_info TYPE zben_s_root_info,
          ls_period    TYPE zben_period,
          ls_text      TYPE zben_s_text.

    DATA: lo_provider TYPE REF TO zcl_ben_data_provider.
    CREATE OBJECT lo_provider.


    TRY.
        lo_provider->get_period(
          IMPORTING
             es_period = ls_period ).

      CATCH cx_sy_itab_line_not_found.

    ENDTRY.

    IF ls_period IS NOT INITIAL.

      lo_provider->get_root_info(
       EXPORTING
          iv_guid         = lv_guid
       IMPORTING
      es_return = ls_root_info ) .

*
*    lo_provider->get_texts(
*     EXPORTING
*        iv_guid         = lv_guid
*     IMPORTING
*    es_defined_pers = ls_text ) .
*    es_response_context-count = lines( zcl_hay_model=>get_application_model( )-data_model ).


      ls_model-guid = lv_guid = 'GUID_DEFAULT'.
      MOVE-CORRESPONDING ls_root_info TO ls_model-root_info.


*sabit metinler
      lo_provider->get_text(
       EXPORTING
          iv_guid = lv_guid
       IMPORTING
      es_return = ls_text ) .

      MOVE-CORRESPONDING ls_text TO ls_model-text.
      APPEND ls_model TO et_entityset.
    ELSE.

*    DATA: lt_return TYPE TABLE OF bapiret2.
*      IF sy-subrc IS INITIAL.

        DATA: lo_exception TYPE REF TO /iwbep/cx_mgw_tech_exception.
        DATA lv_text TYPE bapi_msg.
        CREATE OBJECT lo_exception.
*      lo_exception->get_msg_container( )->add_messages_from_bapi( it_bapi_messages = lt_return ).


        lv_text = 'Türk Telekom Çarşı alışverişe kapalıdır.'.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid            = /iwbep/cx_mgw_busi_exception=>business_error
            message           = lv_text
            message_container = lo_exception->get_msg_container( ).

      ENDIF.
    ENDMETHOD.


  METHOD benefitsset_get_entity.
**TRY.
*CALL METHOD SUPER->BENEFITSSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
*
    DATA: lt_catalog  TYPE zben_tt_catalog,
          ls_benefits TYPE zben_s_benefits,
          lt_benefits TYPE zben_tt_benefits.

    DATA: ls_model TYPE zben_s_app_model.
    DATA: lt_model TYPE TABLE OF zben_s_app_model.

    DATA: lv_guid       TYPE sysuuid_c32,
          lv_catalog_id TYPE zben_s_catalog-catalog_id,
          lv_benefit_id TYPE zben_s_benefits-benefit_id,
          ls_period     TYPE zben_period.

    DATA: lo_data_provider TYPE REF TO zcl_ben_data_provider.
    CREATE OBJECT lo_data_provider.

    TRY.
        lo_data_provider->get_period(
          IMPORTING
             es_period = ls_period ).

      CATCH cx_sy_itab_line_not_found.

    ENDTRY.

    CHECK ls_period IS NOT INITIAL.


    CASE iv_entity_name.
      WHEN 'Benefits'.
*
        DATA(lv_guidx) =  VALUE #( it_key_tab[ name = 'Guid' ]-value OPTIONAL ).
        lv_guid = lv_guidx.

        DATA(lv_catalog_idx) = VALUE #( it_key_tab[ name = 'CatalogId' ]-value OPTIONAL ).
        lv_catalog_id = lv_catalog_idx.

        DATA(lv_benefit_idx) = VALUE #( it_key_tab[ name = 'BenefitId' ]-value OPTIONAL ).
        lv_benefit_id = lv_benefit_idx.
        CHECK lv_guid IS NOT INITIAL AND lv_catalog_id IS NOT INITIAL AND lv_benefit_id IS NOT INITIAL.

        CALL METHOD lo_data_provider->get_benefit
          EXPORTING
            iv_benefit_id = lv_benefit_id
            iv_catalog_id = lv_catalog_id
          IMPORTING
            et_benefits   = lt_benefits
            es_model      = ls_model.

        .

        READ TABLE lt_benefits INTO ls_benefits INDEX 1.

        MOVE-CORRESPONDING ls_benefits TO er_entity.
        er_entity-guid = lv_guid.

      WHEN OTHERS.
        RETURN.
    ENDCASE.



*    TRY.
*        copy_data_to_ref( EXPORTING  is_data = ls_benefits
*                              CHANGING  cr_data = er_entity ).
*      CATCH cx_sy_itab_line_not_found..

*    ENDTRY.
*
*    DATA: lo_data_provider TYPE REF TO zcl_ben_data_provider.
*    CREATE OBJECT lo_data_provider.

*
*    CASE iv_entity_name.
*      WHEN 'Application'.
*
**        DATA(ls_guidx) =  VALUE #( it_key_tab[ name = 'Guid' ]-value OPTIONAL ).
**        lv_guid = ls_guidx.
**
**        CHECK lv_guid IS NOT INITIAL.
**        zcl_ben_odata_adapter=>get_details(
**          EXPORTING
**            iv_guid  = lv_guid
**          IMPORTING
**            is_model = ls_model
**        ).
*
**
**        copy_data_to_ref( EXPORTING  is_data = ls_model
**                           CHANGING  cr_data = er_entityset ).
*
*      WHEN OTHERS.
*        RETURN.
*    ENDCASE.
*    lo_data_provider->get_benefit(
*      EXPORTING
*        iv_guid       =
*        iv_benefit_id =                  " BENEFIT_ID
**      IMPORTING
**        et_benefits   =                  " Çarşı yan haklar structure
*    )..

*    DATA: lt_catalog  TYPE zben_tt_catalog,
*          ls_benefits TYPE zben_s_benefits,
*          lt_benefits TYPE zben_tt_benefits.
*
*    CALL METHOD lo_data_provider->get_catalogs
*      RECEIVING
*        rt_catalogs = lt_catalog.


  ENDMETHOD.


  METHOD benefitsset_get_entityset.


    DATA: lv_key TYPE char255.

    DATA :lv_guid       TYPE sysuuid_c32,
          lv_catalog_id TYPE zben_s_catalog-catalog_id.

    lv_catalog_id =  VALUE #( it_key_tab[ name = 'CatalogId' ]-value OPTIONAL ).
    lv_guid =  VALUE #( it_key_tab[ name = 'Guid' ]-value OPTIONAL ).
*         lv_guid = ls_guidx.
    .


    DATA: lo_data_provider TYPE REF TO zcl_ben_data_provider.
    CREATE OBJECT lo_data_provider.


    CALL METHOD lo_data_provider->get_catalog_benefits
      EXPORTING
        iv_guid       = lv_guid
        iv_catalog_id = lv_catalog_id
      IMPORTING
*       et_benefits   = lt_benefits
        es_model      = DATA(ls_model).


    TRY.
        et_entityset = CORRESPONDING #( ls_model-catalogs[ 1 ]-benefits ) .
      CATCH cx_sy_itab_line_not_found.

    ENDTRY.


*    SELECT * FROM zben_benefits
*      INTO CORRESPONDING FIELDS OF TABLE @et_entityset
*      WHERE catalog_id = @lv_catalog_id.
*
*
*    LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<ls_entityset>).
*      lv_key = |(Guid='{ <ls_entityset>-guid }',CatalogId='{ <ls_entityset>-catalog_id }',BenefitId='{ <ls_entityset>-benefit_id }')|.
*      <ls_entityset>-file-file_url =  |/sap/opu/odata/sap/ZBEN_TT_CARSI_SRV/FilesSet{ lv_key }/$value|   .
**        <ls_entityset>-catalog_id
**        <ls_entityset>-benefit_
**        <ls_entityset>-files-file_url = 'ZBEN_TT_CARSI_SRV/FilesSet(CatalogId=''AKR'',BenefitId=''17'',Guid=''xxx'')/$value'.
*
*    ENDLOOP.



  ENDMETHOD.


  method CARTSET_CREATE_ENTITY.
**TRY.
*CALL METHOD SUPER->CARTSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  METHOD cartset_delete_entity.
**TRY.
*CALL METHOD SUPER->CARTSET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA: ls_entityset    TYPE zben_s_cart,
          ls_key_tab      TYPE /iwbep/s_mgw_name_value_pair,
          lv_error_entity TYPE string.

    DATA: lv_guid       TYPE sysuuid_c32,
*          lv_catalog_id TYPE zben_s_catalog-catalog_id,
          lv_benefit_id TYPE zben_s_benefits-benefit_id,
          lv_pernr      TYPE zben_s_cart-pernr,
          lv_zyear      TYPE zben_s_cart-zyear.
    DATA: ls_defin_pers      TYPE zben_defin_pers.

    DATA(lv_guidx) =  VALUE #( it_key_tab[ name = 'Guid' ]-value OPTIONAL ).
    lv_guid = lv_guidx.

    DATA(lv_benefit_idx) = VALUE #( it_key_tab[ name = 'BenefitId' ]-value OPTIONAL ).
    lv_benefit_id = lv_benefit_idx.

    DATA(lv_pernrx) =  VALUE #( it_key_tab[ name = 'Pernr' ]-value OPTIONAL ).
    lv_pernr = lv_pernrx.

    DATA(lv_zyearx) = VALUE #( it_key_tab[ name = 'Zyear' ]-value OPTIONAL ).
    lv_zyear = lv_zyearx.
*>>>>> added by ZTURAN 12.07.2023 15:33:31


    DATA: lt_return TYPE TABLE OF bapiret2.
    DATA lv_text TYPE bapi_msg.

    IF lv_benefit_id EQ 60.
*

      DATA: lo_exception TYPE REF TO /iwbep/cx_mgw_tech_exception.
      CREATE OBJECT lo_exception.
      lo_exception->get_msg_container( )->add_messages_from_bapi( it_bapi_messages = lt_return ).


      lv_text = 'Yemek kartını sepetinizden silemezsiniz!'.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message           = lv_text
          message_container = lo_exception->get_msg_container( ).



    ENDIF.


*>>>>> ended by ZTURAN 12.07.2023 15:33:31
*    READ TABLE it_key_tab INTO ls_key_tab INDEX 1.

    SELECT SINGLE * FROM zben_tran_pers
      INTO @DATA(ls_tran_pers)
      WHERE pernr = @lv_pernr
        AND zyear = @lv_zyear
       AND delete_ind NE 'X'.

    SELECT SINGLE * FROM zben_tran_ben
      INTO @DATA(ls_tran_ben)
      WHERE benefit_id EQ @lv_benefit_id
          AND pernr EQ @lv_pernr
          AND zyear EQ @lv_zyear
          AND delete_ind NE 'X'.


    SELECT SINGLE * FROM zben_defin_pers
      INTO ls_defin_pers
      WHERE pernr = lv_pernr
        AND zyear = lv_zyear.
*    ENDIF.


    SELECT SINGLE * FROM zben_tran_ben
      INTO @DATA(lt_tran_ben)
      WHERE benefit_id NE @lv_benefit_id.


    ls_tran_pers-remain_total    = ls_tran_pers-remain_total + ( ls_tran_ben-amount_net - ls_tran_ben-amount_discount ).
    ls_tran_pers-cart_total      = ls_tran_pers-cart_total - ( ls_tran_ben-amount_net - ls_tran_ben-amount_discount ).
    ls_tran_pers-amount_discount = ls_tran_pers-amount_discount - ls_tran_ben-amount_discount.
    ls_tran_pers-fixed_budget    = ls_tran_pers-fixed_budget + ls_tran_ben-amount_net.
    MODIFY zben_tran_pers FROM ls_tran_pers.

*    DELETE FROM zben_tran_ben WHERE benefit_id = lv_benefit_id.
    UPDATE zben_tran_ben SET  delete_ind = 'X'
                         WHERE benefit_id = lv_benefit_id
                         AND delete_ind NE 'X'.

    IF ls_tran_pers-remain_total EQ ls_defin_pers-fixed_budget.

****      UPDATE zben_tran_pers SET status = 'DE'
****                                delete_ind = 'X'
****                            WHERE pernr = lv_pernr
****                              AND zyear = lv_zyear
****                              AND delete_ind NE 'X'.
    ENDIF.
    IF ( sy-subrc = 0 ).
* * delete completed
    ELSE.
* * entity not found
      CONCATENATE iv_entity_name
                  '('''
                  ls_key_tab-value
                  ''')'
        INTO lv_error_entity.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid      = /iwbep/cx_mgw_busi_exception=>resource_not_found
          entity_type = lv_error_entity.
    ENDIF.
  ENDMETHOD.


  method CARTSET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->CARTSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  METHOD cartset_get_entityset.
**TRY.
*CALL METHOD SUPER->CARTSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.


    DATA(lv_pernr)  =   zcl_hr_person_helper=>get_pernr_from_uname(
        iv_uname = sy-uname
      ).

    DATA: lo_data_provider TYPE REF TO zcl_ben_data_provider.
    CREATE OBJECT lo_data_provider.


    TRY.
        lo_data_provider->get_period(
          IMPORTING
             es_period = DATA(ls_period) ).

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.


    SELECT *
      FROM zben_tran_ben
      INTO CORRESPONDING FIELDS OF TABLE et_entityset
      WHERE pernr EQ lv_pernr AND
            zyear EQ ls_period-begin_date(4)
        AND delete_ind NE 'X'. .
*>>>>> added by ZTURAN 12.07.2023 14:58:33

    DATA: ls_entity TYPE zben_s_cart.
    DATA: ls_benefits TYPE zben_benefits.
    DATA: ls_tran_ben TYPE zben_tran_ben.

    SELECT SINGLE *
      FROM zben_tran_pers
      INTO @DATA(ls_tran_pers)
      WHERE pernr EQ @lv_pernr AND
            zyear EQ @ls_period-begin_date(4)
        AND delete_ind NE 'X'.

    SELECT SINGLE *
      FROM zben_benefits
      INTO CORRESPONDING FIELDS OF ls_benefits
      WHERE catalog_id = 'YMK'
        AND benefit_id = 60.


    SELECT SINGLE *
      FROM zben_defin_pers
      INTO @DATA(ls_defin_pers)
      WHERE pernr EQ @lv_pernr AND
            zyear EQ @ls_period-begin_date(4).


    IF ls_tran_pers IS INITIAL.
      IF et_entityset IS INITIAL .
        MOVE-CORRESPONDING ls_benefits TO ls_entity.
        ls_entity-pernr = lv_pernr.
        ls_entity-zyear = ls_period-begin_date(4).
        ls_entity-amount_net = ls_defin_pers-flexible_budget.
        ls_entity-last_amount_net = ls_entity-amount_net.
        APPEND ls_entity TO et_entityset.
        MOVE-CORRESPONDING ls_entity TO ls_tran_ben.
        MODIFY zben_tran_ben FROM ls_tran_ben.
        DELETE ADJACENT DUPLICATES FROM et_entityset.
      ENDIF.
    ELSE.
      IF ls_tran_pers-flexible_budget GT 0.
        MOVE-CORRESPONDING ls_benefits TO ls_entity.
        ls_entity-pernr = lv_pernr.
        ls_entity-zyear = ls_period-begin_date(4).
        ls_entity-amount_net = ls_tran_pers-flexible_budget.
        ls_entity-last_amount_net = ls_tran_pers-flexible_budget + ls_tran_pers-reduce_tax.
*      MODIFY et_entityset FROM ls_entity.
        MOVE-CORRESPONDING ls_entity TO ls_tran_ben.
        MODIFY zben_tran_ben FROM ls_tran_ben.
        DELETE ADJACENT DUPLICATES FROM et_entityset.
      ENDIF.
    ENDIF.

*>>>>> ended by ZTURAN 12.07.2023 14:58:33
    LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<ls_entity>).

      <ls_entity>-file  =  zcl_ben_file_handler=>get_benefits_image(
                              iv_catalog_id = <ls_entity>-catalog_id
                              iv_benefit_id = <ls_entity>-benefit_id
                            ).

    ENDLOOP.

  ENDMETHOD.


  method CATALOGSSET_CREATE_ENTITY.
**TRY.
*CALL METHOD SUPER->CATALOGSSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  method CATALOGSSET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->CATALOGSSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  METHOD catalogsset_get_entityset.
**TRY.

    DATA: lv_guid   TYPE sysuuid_c32,
          ls_period TYPE zben_period.

    DATA: lo_provider TYPE REF TO zcl_ben_data_provider.
    CREATE OBJECT lo_provider.

    TRY.
        lo_provider->get_period(
          IMPORTING
             es_period = ls_period ).

      CATCH cx_sy_itab_line_not_found.

    ENDTRY.

    CHECK ls_period IS NOT INITIAL.

    DATA(lv_guidx) =  VALUE #( it_key_tab[ name = 'Guid' ]-value OPTIONAL ).
    lv_guid = lv_guidx.

    DATA: lt_catalog  TYPE zben_tt_catalog.

    CALL METHOD lo_provider->get_catalogs
      EXPORTING
        iv_guid     = lv_guid
      RECEIVING
        rt_catalogs = lt_catalog.

    MOVE-CORRESPONDING lt_catalog[] TO et_entityset[].

    .
  ENDMETHOD.


  method DEFINEDBENEFITSS_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->DEFINEDBENEFITSS_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  METHOD definedbenefitss_get_entityset.
**TRY.
*CALL METHOD SUPER->DEFINEDBENEFITSS_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**                 =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA: lv_guid             TYPE sysuuid_c32,
          lt_defined_benefits TYPE zben_tt_defined_ben,
          lv_benefit_group    TYPE zben_s_defined_ben-benefit_group,
          ls_period           TYPE zben_period.

    DATA: lo_data_provider    TYPE REF TO zcl_ben_data_provider.
    CREATE OBJECT lo_data_provider.


    DATA(lv_guidx) =  VALUE #( it_key_tab[ name = 'Guid' ]-value OPTIONAL ).
    lv_guid = lv_guidx.

    CALL METHOD lo_data_provider->get_defined_benefits
      EXPORTING
        iv_guid             = lv_guid
      RECEIVING
        rt_defined_benefits = lt_defined_benefits.


    MOVE-CORRESPONDING lt_defined_benefits[] TO et_entityset[].

  ENDMETHOD.


  METHOD pdffileset_get_entity.
    DATA(lt_keys) = io_tech_request_context->get_keys( ).
    DATA: ls_file     TYPE zben_s_files.
    DATA: ls_return TYPE  bapiret2.
    DATA: lv_filename TYPE char255.
    DATA: len TYPE i.
    DATA: ls_files  TYPE zben_s_images.

    DATA  : lv_string TYPE string.
    DATA: lv_decodedx     TYPE xstring,
          lt_data         TYPE solix_tab,
          lv_bin_filesize TYPE i.
    DATA: xstring            TYPE xstring.
    DATA: lo_cached_response TYPE REF TO if_http_response.
    DATA ls_lheader TYPE ihttpnvp.


    ls_file-catalog_id = VALUE #( lt_keys[ name = 'CATALOG_ID' ]-value OPTIONAL ).
    ls_file-benefit_id      = VALUE #( lt_keys[ name = 'BENEFIT_ID' ]-value OPTIONAL ).

    SELECT SINGLE * FROM zben_bnft_image
     INTO @DATA(ls_filex)
      WHERE catalog_id = @ls_file-catalog_id
         AND benefit_id = @ls_file-benefit_id.

*
    CASE ls_file-benefit_id.
      WHEN 99999.

        er_entity-catalog_id = ls_filex-catalog_id .
        er_entity-benefit_id =  ls_filex-benefit_id .
        DATA : xstringx TYPE xstring.

        xstringx = ls_filex-value..
        er_entity-value       = xstringx.
*        er_entity-value  = ls_file-value.
      WHEN OTHERS.

        RETURN.
    ENDCASE.


  ENDMETHOD.
ENDCLASS.
