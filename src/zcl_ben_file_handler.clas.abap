class ZCL_BEN_FILE_HANDLER definition
  public
  final
  create public .

public section.

  class-methods UPDATE_FILES_SERVICES
    importing
      !IS_MODEL type ZBEN_S_APP_MODEL
    returning
      value(ET_RETURN) type BAPIRET2_TT .
  class-methods UPLOAD_FILE
    exporting
      !ES_RETURN type BAPIRET2
    changing
      !CS_FILE type ZBEN_S_FILES .
  class-methods DOWNLOAD_FILE
    exporting
      !ES_RETURN type BAPIRET2
    changing
      !CS_FILE type ZBEN_S_FILES .
  class-methods DELETE_FILE .
  class-methods GET_SERVICE_ENTRY_FILES
    importing
      !IV_GUID type SYSUUID_C32
      !IV_CATALOG_ID type ZBEN_DE_CAT_ID
      !IV_BENEFIT_ID type ZBEN_DE_BENEFIT_ID
    returning
      value(ET_FILES) type ZBEN_TT_FILES .
  class-methods GET_BENEFITS_IMAGE
    importing
      !IV_GUID type SYSUUID_C32 optional
      !IV_CATALOG_ID type ZBEN_DE_CAT_ID
      !IV_BENEFIT_ID type ZBEN_DE_BENEFIT_ID
    returning
      value(ES_FILES) type ZBEN_S_FILES .
protected section.
private section.

  class-methods READ_FILES_SERVICE_ENTRY
    exporting
      !ES_RETURN type BAPIRET2
    changing
      !CS_FILE type ZBEN_S_FILES .
  class-methods READ_FILES_API
    exporting
      !ES_RETURN type BAPIRET2
    changing
      !CS_FILE type ZBEN_S_FILES .
  class-methods UPDATE_FILES_API
    exporting
      !ES_RETURN type BAPIRET2
    changing
      !CS_FILE type ZBEN_S_FILES .
ENDCLASS.



CLASS ZCL_BEN_FILE_HANDLER IMPLEMENTATION.


  method DELETE_FILE.
  endmethod.


  METHOD download_file.

*    DATA: ls_return TYPE bapiret2.
**
**    DATA(lt_files) = get_service_entry_files( iv_guid = cs_file-guid iv_lblni = cs_file-lblni ) .
**    DELETE lt_files WHERE item_no NE cs_file-item_no.
**    CHECK lt_files IS NOT INITIAL.
**    cs_file = lt_files[ 1 ].
*
*    read_files_api( IMPORTING es_return = ls_return  CHANGING cs_file =  cs_file ).

  ENDMETHOD.


  METHOD get_benefits_image.
    DATA: lv_key TYPE char255.
    SELECT SINGLE * FROM zben_bnft_image
      INTO CORRESPONDING FIELDS OF es_files
      WHERE catalog_id = iv_catalog_id
        AND benefit_id = iv_benefit_id.

*    MOVE-CORRESPONDING ls_file TO ls_files.
    DATA: guid TYPE guid_32.
    CALL FUNCTION 'GUID_CREATE'
      IMPORTING
        ev_guid_32 = guid.

    lv_key = |(Guid='{ guid }',CatalogId='{ es_files-catalog_id }',BenefitId='{ es_files-benefit_id }')|.

    es_files-file_url =  |/sap/opu/odata/sap/ZBEN_TT_CARSI_SRV/BenefitFileSet{ lv_key }/$value|   .
*    es_files-file_url =  |/sap/opu/odata/sap/ZBEN_TT_CARSI_SRV/FilesSet{ lv_key }/$value?originMaterial=X|   .

*    ls_files-editable = <ls_model>-ui_config-upload_editable.
*    APPEND ls_files TO <ls_model>-files.
  ENDMETHOD.


  METHOD get_service_entry_files.
*    DATA : lv_mimetype  TYPE mimetypes-type,
*           lv_object_id TYPE sibfboriid,
*           lv_key       TYPE char128,
*           lv_item_no   TYPE zben_de_item_no.
*
*    lv_object_id = iv_CATALOG_ID.
*
*    TRY.
*        cl_binary_relation=>read_links_of_objects(
*          EXPORTING
*            it_objects = VALUE #( ( instid = lv_object_id typeid = 'BUS2091' catid = 'BO' ) )
*          IMPORTING
*            et_links_a = DATA(lt_links) ).
*      CATCH cx_obl_model_error.
*      CATCH cx_obl_parameter_error.
*      CATCH cx_obl_internal_error.
*    ENDTRY.
*
*    DELETE lt_links WHERE reltype NE 'ATTA'.
*
*    SORT lt_links BY utctime.
*
*    LOOP AT lt_links ASSIGNING FIELD-SYMBOL(<ls_link>).
*      CLEAR lv_mimetype.
*
**      TRY .
*      SELECT SINGLE * FROM sood
*          INTO @DATA(ls_sood)
*          WHERE objtp = @<ls_link>-instid_b+17(3)
*            AND objyr = @<ls_link>-instid_b+20(2)
*            AND objno = @<ls_link>-instid_b+22(12) .
*
*      CHECK sy-subrc = 0.
*      APPEND INITIAL LINE TO et_files ASSIGNING FIELD-SYMBOL(<ls_file>).
*      <ls_file>-object_id    = <ls_link>-instid_a.
*      <ls_file>-object_type  = <ls_link>-typeid_a.
*      <ls_file>-object_cat   = <ls_link>-catid_a.
*      <ls_file>-document_id  = <ls_link>-instid_b.
*      <ls_file>-file_name    = |{ ls_sood-objdes }|.
*      <ls_file>-create_user  = ls_sood-crono.
**        <ls_file>-creator_name    = ls_sood-cronam.
**        <ls_file>-create_date   = <ls_link>-utctime.
*
*      ADD 1 TO lv_item_no.
*      CALL FUNCTION 'SDOK_MIMETYPE_GET'
*        EXPORTING
*          extension = ls_sood-file_ext
*        IMPORTING
*          mimetype  = lv_mimetype.
*
*      <ls_file>-mime_type    = lv_mimetype.
**      <ls_file>-item_no      = lv_item_no.
*      <ls_file>-CATALOG_ID        = iv_catalog_id.
**      <ls_file>-guid         = iv_guid.
*      <ls_file>-intid        = <ls_link>-instid_b.
*
*      lv_key = |(CatalaogId='{ iv_catalog_id }',Guid='{ iv_guid }',BenefitId='{ iv_benefit_id }',Intid='{  <ls_file>-intid }')|.
*
*      <ls_file>-file_url =  |/sap/opu/odata/sap/ZBEN_TT_SRV/FilesSet{ lv_key }/$value|   .
*
*    ENDLOOP.



  ENDMETHOD.


  METHOD read_files_api.

    DATA : ls_document_data      TYPE sofolenti1,
           lt_object_content_hex TYPE solix_tab,
           lt_content_bin        TYPE TABLE OF solisti1,
           lv_docsize            TYPE i,
           lv_xstring            TYPE xstring,
           lv_ok                 TYPE xfeld,
           lv_mes                TYPE text100,
           lt_return             TYPE bapiret2_t,
           lv_filename           TYPE text100.

    CALL FUNCTION 'SO_DOCUMENT_READ_API1'
      EXPORTING
        document_id                = cs_file-intid
      IMPORTING
        document_data              = ls_document_data
      TABLES
        object_content             = lt_content_bin
        contents_hex               = lt_object_content_hex
      EXCEPTIONS
        document_id_not_exist      = 1
        operation_no_authorization = 2
        x_error                    = 3
        OTHERS                     = 4.

    lv_docsize = ls_document_data-doc_size.


    TRANSLATE ls_document_data-obj_type TO LOWER CASE.
    cs_file-file_name = |{ ls_document_data-obj_descr }|.

    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = lv_docsize
      IMPORTING
        buffer       = lv_xstring
      TABLES
*       binary_tab   = lt_content_bin
        binary_tab   = lt_object_content_hex
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.


    cs_file-value = lv_xstring.
*    cs_file-file_name  = cs_file-ebeln_po + ls_document_data-


  ENDMETHOD.


  METHOD read_files_service_entry.

*    DATA : wa_object       TYPE sibflporb,
*           int_rel_options TYPE obl_t_relt,
*           wa_rel_options  TYPE obl_s_relt,
*           int_links       TYPE obl_t_link,
*           wa_links        TYPE obl_s_link.
*
**    ls_object_a-instid = cs_file-matnr.
**    ls_object_a-typeid = 'BUS1001006'.
**    ls_object_a-catid  = 'BO'.
**
**
**    ls_object_b-instid  = cs_file-matnr.
**    ls_object_b-typeid = 'MESSAGE'.
**    ls_object_b-catid  = 'BO'.
*
*    wa_rel_options-low = 'ATTA'.
*    wa_rel_options-sign = 'I'.
*    wa_rel_options-option = 'EQ'.
*    APPEND wa_rel_options TO int_rel_options.
*
*    wa_object-instid = cs_file-lblni.
*    wa_object-typeid = 'BUS2091'.
*    wa_object-catid  = 'BO'.
*    REFRESH int_links[].
*
*    TRY.
*        CALL METHOD cl_binary_relation=>read_links_of_binrels
*          EXPORTING
*            is_object           = wa_object
*            it_relation_options = int_rel_options
*            ip_role             = 'GOSAPPLOBJ'
*          IMPORTING
*            et_links            = int_links.
*
*      CATCH cx_obl_parameter_error.
*      CATCH cx_obl_internal_error.
*      CATCH cx_obl_model_error.
*    ENDTRY.


  ENDMETHOD.


  METHOD update_files_api.


    DATA :
      lv_object_id       TYPE soobjinfi1-object_id,
      lv_rolea           TYPE borident,
      lv_roleb           TYPE borident,
      lv_pre             TYPE string,
      lv_data            TYPE string,
      lv_datax           TYPE xstring,
      lv_doc_type        TYPE soodk-objtp,
      ls_doc_data        TYPE sodocchgi1,
      lt_solix           TYPE STANDARD TABLE OF solix,
      lv_len_name_table  TYPE i,
      lt_file_name_parts TYPE TABLE OF string,
      lv_mes             TYPE string,
      lv_file_name       TYPE text255,
      lv_input           TYPE string.

    DATA: lt_return TYPE table of BAPIRET2.
    DATA: ls_document_info TYPE sofolenti1.
    DATA: ls_folder_id TYPE soodk.
*   DATA : lv_output_length    TYPE i,
*           lt_solix            TYPE solix_tab,
*           lt_soli             TYPE soli_tab,
*           ls_object_hd_change TYPE sood1,
*           lt_objhead          TYPE STANDARD TABLE OF soli,
*           ls_object_id        TYPE soodk.

    DATA: ls_object_a TYPE sibflporb,
          ls_object_b TYPE sibflporb.




    CALL FUNCTION 'SO_FOLDER_ROOT_ID_GET'
      EXPORTING
*       owner                 = sy-uname
        region                = 'B'
      IMPORTING
        folder_id             = ls_folder_id
      EXCEPTIONS
        communication_failure = 1
        owner_not_exist       = 2
        system_failure        = 3
        x_error               = 4
        OTHERS                = 5.


    lv_object_id = ls_folder_id.

    lv_file_name = cs_file-file_name.
    SPLIT lv_file_name AT '.' INTO TABLE lt_file_name_parts.
    DESCRIBE TABLE lt_file_name_parts LINES lv_len_name_table.
    READ TABLE lt_file_name_parts INTO lv_doc_type INDEX lv_len_name_table.
    READ TABLE lt_file_name_parts INTO lv_file_name INDEX 1.

    TRANSLATE lv_doc_type TO UPPER CASE.

    " Document Information
    ls_doc_data-obj_name   = cs_file-file_name.
    ls_doc_data-obj_descr  = cs_file-file_name.
    ls_doc_data-obj_langu  = sy-langu.
*    ls_doc_data-doc_size   = strlen( cs_file-value ). " todo fix

    " Convert to table
*    CALL METHOD cl_document_bcs=>xstring_to_solix
*      EXPORTING
*        ip_xstring = cs_file-value
*      RECEIVING
*        rt_solix   = lt_solix.

" todo fix

    " Insert Document
    CALL FUNCTION 'SO_DOCUMENT_INSERT_API1'
      EXPORTING
        folder_id                  = lv_object_id
        document_data              = ls_doc_data
        document_type              = lv_doc_type
      IMPORTING
        document_info              = ls_document_info
      TABLES
*       OBJECT_CONTENT             = LT_bin
        contents_hex               = lt_solix
      EXCEPTIONS
        folder_not_exist           = 1
        document_type_not_exist    = 2
        operation_no_authorization = 3
        parameter_error            = 4
        x_error                    = 5
        enqueue_error              = 6
        OTHERS                     = 7.

    COMMIT WORK AND WAIT .

    cs_file-foltp = ls_folder_id-objtp.
    cs_file-folyr = ls_folder_id-objyr.
    cs_file-folno = ls_folder_id-objno.
    cs_file-objtp = ls_document_info-object_id(3).
    cs_file-objyr = ls_document_info-object_id+3(2).
    cs_file-objno = ls_document_info-object_id+5(*).
    cs_file-intid = ls_document_info-doc_id.



** Dosyanın ML81N ile ilişkisinin kurulması
*
*    ls_object_a-instid = cs_file-lblni.
*    ls_object_a-typeid = 'BUS2091'.
*    ls_object_a-catid  = 'BO'.
*
*    ls_object_b-instid  = cs_file-intid.
*    ls_object_b-typeid = 'MESSAGE'.
*    ls_object_b-catid  = 'BO'.
*
*    TRY.
*        cl_binary_relation=>create_link(
*          EXPORTING
*            is_object_a = ls_object_a
*            is_object_b = ls_object_b
*            ip_reltype  = 'ATTA' ).
*      CATCH cx_obl_parameter_error.
*      CATCH cx_obl_model_error.
*      CATCH cx_obl_internal_error.
*    ENDTRY.
**
*
*    IF sy-subrc IS NOT INITIAL AND sy-msgty IS NOT INITIAL AND sy-msgno IS NOT INITIAL.
*      APPEND zcl_abap_utils=>message_number_to_return( EXPORTING iv_type       = sy-msgty
*                                                                 iv_number     = sy-msgno
*                                                                 iv_id         = sy-msgid
*                                                                 iv_message_v1 = sy-msgv1
*                                                                 iv_message_v2 = sy-msgv2
*                                                                 iv_message_v3 = sy-msgv3
*                                                                 iv_message_v4 = sy-msgv4
*                                                                ) TO lt_return.
*
*      READ TABLE lt_return INTO es_return INDEX 1.
*      RETURN.
*    ENDIF.


  ENDMETHOD.


  METHOD update_files_services.

*    DATA : ls_folder_id        TYPE soodk,
*           lv_output_length    TYPE i,
*           lt_solix            TYPE solix_tab,
*           lt_soli             TYPE soli_tab,
*           ls_object_hd_change TYPE sood1,
*           lt_objhead          TYPE STANDARD TABLE OF soli,
*           ls_object_id        TYPE soodk.
*
*    DATA: ls_object_a TYPE sibflporb,
*          ls_object_b TYPE sibflporb.
*
*    DATA : ls_document_data      TYPE sofolenti1,
*           lt_object_content_hex TYPE solix_tab,
*           lt_content_bin        TYPE TABLE OF solisti1,
*           lv_docsize            TYPE i,
*           lv_xstring            TYPE xstring,
*           lv_ok                 TYPE xfeld,
*           lv_mes                TYPE text100,
*           lt_return             TYPE bapiret2_t,
*           lv_filename           TYPE text100.
*
*
*    LOOP AT is_model-catalogs INTO DATA(ls_catalogs).
*
*      LOOP AT ls_catalogs-benefits INTO DATA(ls_benefits).
*        LOOP AT ls_benefits-files into DATA(ls_file).
*
*
*
**        LOOP AT ls_service_entry-files INTO DATA(ls_file).
*
*        ls_object_a-instid = ls_file-benefit_id.
*        ls_object_a-typeid = 'BUS2091'.
*        ls_object_a-catid  = 'BO'.
*
*        ls_object_b-instid  = ls_file-intid.
*        ls_object_b-typeid = 'MESSAGE'.
*        ls_object_b-catid  = 'BO'.
*
*        TRY.
*            cl_binary_relation=>create_link(
*              EXPORTING
*                is_object_a = ls_object_a
*                is_object_b = ls_object_b
*                ip_reltype  = 'ATTA' ).
*          CATCH cx_obl_parameter_error.
*          CATCH cx_obl_model_error.
*          CATCH cx_obl_internal_error.
*        ENDTRY.
*
*        IF sy-subrc IS NOT INITIAL AND sy-msgty IS NOT INITIAL AND sy-msgno IS NOT INITIAL.
*          APPEND zcl_abap_utils=>message_number_to_return( EXPORTING iv_type       = sy-msgty
*                                                                     iv_number     = sy-msgno
*                                                                     iv_id         = sy-msgid
*                                                                     iv_message_v1 = sy-msgv1
*                                                                     iv_message_v2 = sy-msgv2
*                                                                     iv_message_v3 = sy-msgv3
*                                                                     iv_message_v4 = sy-msgv4
*                                                                    ) TO et_return.
*          RETURN.
*        ENDIF.
*
*        ENDLOOP.
*      ENDLOOP.
*
*    ENDLOOP.


  ENDMETHOD.


  METHOD upload_file.

    DATA: ls_return TYPE bapiret2.

    DATA lv_extension TYPE sood-file_ext.
    CALL FUNCTION 'TRINT_FILE_GET_EXTENSION'
      EXPORTING
        filename  = cs_file-file_name
      IMPORTING
        extension = lv_extension.

    DATA lv_mimetype TYPE mimetypes-type.
    CALL FUNCTION 'SDOK_MIMETYPE_GET'
      EXPORTING
        extension = lv_extension
      IMPORTING
        mimetype  = cs_file-mime_type.

    update_files_api( IMPORTING es_return = ls_return  CHANGING cs_file = cs_file ).

    es_return = ls_return.

  ENDMETHOD.
ENDCLASS.
