class ZCL_BEN_ODATA_ADAPTER definition
  public
  final
  create public .

public section.

  class-methods GET_RETURN
    returning
      value(ET_RETURN) type BAPIRET2_TT .
  class-methods GET_DETAILS
    importing
      !IV_GUID type SYSUUID_C32
    exporting
      !IS_MODEL type ZBEN_S_APP_MODEL .
  class-methods INIT_APPLICATION
    importing
      !IV_GUID type SYSUUID_C32 .
  class-methods PROCESS_APPROVE_SELECTION
    changing
      !CS_MODEL type ZBEN_S_APP_MODEL .
  class-methods ADD_TO_BOX
    changing
      !CS_MODEL type ZBEN_S_APP_MODEL .
  class-methods SELL_AMOUNT
    changing
      !CS_MODEL type ZBEN_S_APP_MODEL .
  class-methods PROCESS_DEFAULT_SELECTION
    changing
      !CS_MODEL type ZBEN_S_APP_MODEL .
  class-methods PROCESS_CHANGE_SELECTION
    changing
      !CS_MODEL type ZBEN_S_APP_MODEL .
  class-methods PROCESS_RESET_SELECTION
    changing
      !CS_MODEL type ZBEN_S_APP_MODEL .
protected section.
private section.

  class-data MT_RETURN type BAPIRET2_TT .

  class-methods PERFORM_VALIDATIONS .
ENDCLASS.



CLASS ZCL_BEN_ODATA_ADAPTER IMPLEMENTATION.


  METHOD add_to_box.

    DATA ls_tran_pers TYPE zben_tran_pers.
    DATA lt_tran_pers TYPE TABLE OF zben_tran_pers.
    DATA ls_tran_ben TYPE zben_tran_ben.
    DATA lt_tran_ben TYPE TABLE OF zben_tran_ben.
    DATA ls_defin_pers TYPE zben_defin_pers.
    DATA lv_discount TYPE zben_tran_pers-amount_discount.
    DATA: lt_image TYPE TABLE OF zben_bnft_image.
    DATA: lv_message_v1 TYPE bapiret2-message_v1.

    IF cs_model-cart_items IS NOT INITIAL.
      SELECT * FROM zben_benefits
        INTO TABLE @DATA(lt_benefits)
        FOR ALL ENTRIES IN @cs_model-cart_items
        WHERE benefit_id = @cs_model-cart_items-benefit_id.

      SELECT * FROM zben_tran_ben
         INTO TABLE @DATA(lt_tran_benefits)
         FOR ALL ENTRIES IN @cs_model-cart_items
         WHERE benefit_id = @cs_model-cart_items-benefit_id
           AND pernr = @cs_model-root_info-pernr
           AND zyear = @cs_model-root_info-zyear
*           AND plate = @cs_model-root_info-plate
           AND delete_ind NE 'X'.

*
*      SELECT * FROM zben_bnft_image
*        INTO TABLE lt_image
*        FOR ALL ENTRIES IN cs_model-cart_items
*        WHERE catalog_id = cs_model-cart_items-catalog_id
*          AND benefit_id = cs_model-cart_items-benefit_id.


    ENDIF.

*    SELECT SINGLE * FROM zben_def_per_log
*           INTO ls_defin_pers
*           WHERE pernr = cs_model-root_info-pernr
*           AND zyear = cs_model-root_info-zyear.
*    IF ls_defin_pers IS INITIAL.

    SELECT SINGLE * FROM zben_defin_pers
           INTO ls_defin_pers
           WHERE pernr = cs_model-root_info-pernr
           AND zyear = cs_model-root_info-zyear.

*    ENDIF.

    SELECT SINGLE * FROM zben_tran_pers
       INTO ls_tran_pers
      WHERE pernr = cs_model-root_info-pernr
        AND zyear = cs_model-root_info-zyear
        AND delete_ind NE 'X'.





    DATA: lt_cart_item TYPE zben_tt_cart.
    lt_cart_item[] = cs_model-cart_items[].
    DATA: lr_benefitid  TYPE RANGE OF zben_s_cart-benefit_id.

    IF lt_tran_benefits IS NOT INITIAL.
      lr_benefitid = VALUE #( FOR ls_value IN lt_tran_benefits ( sign = 'I'
                                                             option = 'EQ'
                                                             low = ls_value-benefit_id ) ).

      DELETE lt_cart_item WHERE benefit_id IN lr_benefitid.
      IF lt_cart_item IS INITIAL.
        APPEND zcl_ben_utils=>message_number_to_return(
                          iv_type       = 'E'
                          iv_number     = '001'
                          iv_id         = 'ZBEN'
*                   iv_message_v1 =
*                   iv_message_v2 =
*                   iv_message_v3 =
*                   iv_message_v4 =
                        ) TO mt_return.
      ENDIF.
    ENDIF.


*    MOVE-CORRESPONDING cs_model-root_info TO ls_tran_pers.


    LOOP AT lt_cart_item INTO DATA(ls_item).
      READ TABLE lt_benefits INTO DATA(ls_benefits) WITH KEY benefit_id = ls_item-benefit_id.
      IF sy-subrc EQ 0.
*        READ TABLE lt_tran_benefits INTO DATA(ls_tran_benefits) WITH KEY benefit_id = ls_item-benefit_id.
*        IF sy-subrc NE 0.

        lv_discount =  ls_item-amount_net * ls_benefits-discount_rate .
        IF ls_tran_pers IS INITIAL.
          ls_tran_pers-remain_total = ls_defin_pers-fixed_budget - ( ls_item-amount_net - lv_discount ).
          ls_tran_pers-cart_total   =  ls_defin_pers-flexible_budget + ls_defin_pers-fixed_budget - ls_tran_pers-remain_total  .
          ls_tran_pers-actual_budget   =  ls_defin_pers-fixed_budget + ls_defin_pers-flexible_budget .
          ls_tran_pers-flexible_budget  = cs_model-root_info-flexible_budget.
        ELSE.
          ls_tran_pers-remain_total =  ls_tran_pers-remain_total - ( ls_item-amount_net - lv_discount ).
          ls_tran_pers-cart_total   =  ls_tran_pers-cart_total + ( ls_item-amount_net - lv_discount ) .
        ENDIF.

*        lv_discount =  ls_item-amount_net * ls_benefits-discount_rate .
*        ls_tran_pers-remain_total =  ls_tran_pers-remain_total - ( ls_item-amount_net - lv_discount ).
        WRITE ls_tran_pers-remain_total TO lv_message_v1.
        CONDENSE lv_message_v1.
        IF ls_tran_pers-remain_total LT 0.
          APPEND zcl_ben_utils=>message_number_to_return(
                            iv_type       = 'E'
                            iv_number     = '006'
                            iv_id         = 'ZBEN'
                            iv_message_v1 = lv_message_v1
*                   iv_message_v2 =
*                   iv_message_v3 =
*                   iv_message_v4 =
                          ) TO mt_return.
          EXIT.
        ENDIF.

*>>>>> added by ZTURAN 09.07.2023 17:59:32
        ls_tran_pers-annual_income    = cs_model-root_info-annual_income.
        ls_tran_pers-income_tax_rate  = cs_model-root_info-income_tax_rate.
*        ls_tran_pers-flexible_budget  = cs_model-root_info-flexible_budget.
        ls_tran_pers-fixed_budget     = ls_tran_pers-remain_total.
*        IF ls_tran_pers-reduce_tax is INITIAL.
*        ls_tran_pers-reduce_tax       = cs_model-root_info-reduce_tax.
*        ENDIF.

        ls_tran_pers-default_selected = cs_model-root_info-default_selected.
*        ls_tran_pers-CHANGE_SELECTED  = cs_model-root_info-CHANGE_SELECTED.
        ls_tran_pers-user_accepted    = cs_model-root_info-user_accepted.
        ls_tran_pers-selected_option  = cs_model-root_info-user_accepted.

*>>>>> ended by ZTURAN 09.07.2023 17:59:32

        ls_tran_pers-amount_discount   =  ls_tran_pers-amount_discount + lv_discount  .
*        GET TIME STAMP FIELD ls_tran_pers-create_time.
        ls_tran_pers-create_time = |{ sy-datum }{ sy-uzeit }|.
        ls_tran_pers-create_uname = sy-uname.
        ls_tran_pers-pernr = cs_model-root_info-pernr.
        ls_tran_pers-zyear = sy-datum+0(4).
        ls_tran_pers-status = 'SA'. "Kaydedildi.
        MODIFY zben_tran_pers FROM ls_tran_pers.


        ls_tran_ben-plate             = ls_item-plate.
        ls_tran_ben-pernr             = cs_model-root_info-pernr.
        ls_tran_ben-zyear             = cs_model-root_info-zyear.
        ls_tran_ben-benefit_id        = ls_item-benefit_id.
        ls_tran_ben-catalog_id        = ls_item-catalog_id.
        ls_tran_ben-benefit_group     = ls_item-benefit_group.
        ls_tran_ben-benefit_name      = ls_item-benefit_name.
        ls_tran_ben-amount_net        = ls_item-amount_net.
*     ls_tran_ben- DEFAULT_SELECTION = ls_item-de.
        ls_tran_ben-amount_discount   = lv_discount.
        ls_tran_ben-discount_rate     = ls_item-discount_rate.
        ls_tran_ben-last_amount_net   = ls_tran_ben-amount_net - ( ls_tran_ben-amount_net * ls_item-discount_rate ).
        MODIFY zben_tran_ben FROM ls_tran_ben.

      ENDIF.
    ENDLOOP.

    COMMIT WORK AND WAIT .

  ENDMETHOD.


  METHOD get_details.
*    DATA: lo_catalog TYPE REF TO zcl_ben_data_provider.
*    CREATE OBJECT lo_catalog.
***  zcl_ben_data provir get catalog
***  zcl_ben_data provir get catalog_benefits
***
***  append ls_model
**    DATA(ls_application_model) = zcl_hay_model=>get_application_model( ) .
*    DATA: lt_catalog  TYPE zben_tt_catalog,
*          ls_benefits TYPE zben_s_benefits,
*          lt_benefits TYPE zben_tt_benefits.
*
*    CALL METHOD lo_catalog->get_catalogs
*      RECEIVING
*        rt_catalogs = lt_catalog.
*
*    LOOP AT lt_catalog INTO DATA(ls_catalog).
*
*      CALL METHOD lo_catalog->get_catalog_benefits
*        EXPORTING
*          iv_guid       = iv_guid
*          iv_catalog_id = ls_catalog-catalog_id
*        IMPORTING
*          et_benefits   = lt_benefits.
*
*      LOOP AT lt_benefits INTO ls_benefits
*                          WHERE catalog_id = ls_catalog-catalog_id.
*
*        APPEND ls_benefits TO ls_catalog-benefits.
*      ENDLOOP.
*
*      MODIFY lt_catalog FROM ls_catalog.
*
*    ENDLOOP.
*    is_model-catalogs[] = lt_catalog[].

  ENDMETHOD.


  method GET_RETURN.
    et_return = mt_return.
  endmethod.


  method INIT_APPLICATION.
  endmethod.


  method PERFORM_VALIDATIONS.
  endmethod.


  METHOD process_approve_selection.

    DATA ls_tran_pers TYPE zben_tran_pers.
    DATA ls_tran_ben TYPE zben_tran_ben.
    DATA lt_tran_ben TYPE TABLE OF zben_tran_ben.



    LOOP AT cs_model-cart_items INTO DATA(ls_item).
      CLEAR:ls_tran_pers,ls_tran_ben.
*      Benefit Tran
      MOVE-CORRESPONDING ls_item TO ls_tran_ben.
      ls_tran_ben-pernr = cs_model-root_info-pernr.
      ls_tran_ben-zyear = cs_model-root_info-zyear.
      APPEND ls_tran_ben TO lt_tran_ben.

*       Personel tran
      SELECT SINGLE * FROM zben_tran_pers
         INTO ls_tran_pers
         WHERE pernr = ls_tran_ben-pernr
           AND zyear = ls_tran_ben-zyear
           AND delete_ind NE 'X'.

      ls_tran_pers-approve_time = |{ sy-datum }{ sy-uzeit }|.
      ls_tran_pers-approve_uname    = sy-uname.
      ls_tran_pers-pernr = cs_model-root_info-pernr.
      ls_tran_pers-zyear = sy-datum+0(4).
      ls_tran_pers-status = 'AP'. "Kaydedildi.
      MODIFY zben_tran_pers FROM ls_tran_pers. "burada where delete ind ne 'X' koşulu eklenmesi gerekebilir

    ENDLOOP.



    MODIFY zben_tran_ben FROM TABLE lt_tran_ben.
    IF ls_tran_pers IS NOT INITIAL.
      MODIFY zben_tran_pers FROM ls_tran_pers.
    ENDIF.


    COMMIT WORK AND WAIT .
**>>>>> added by ZTURAN 08.07.2023 12:23:58
*    DATA: lv_guid      TYPE sysuuid_c32,
*          ls_root_info TYPE zben_s_root_info.
*    DATA: lo_provider TYPE REF TO zcl_ben_data_provider.
*    CREATE OBJECT lo_provider.
*
*
*
*    lo_provider->get_root_info(
*        EXPORTING
*           iv_guid         = lv_guid
*       IMPORTING
*           es_return = ls_root_info ) .
**    ls_model-guid = lv_guid = 'GUID_DEFAULT'.
*    MOVE-CORRESPONDING ls_root_info TO cs_model-root_info.


    DATA: ls_benefits TYPE zben_benefits.
    DATA: ls_defin_pers TYPE zben_defin_pers.
    DATA: lv_discount TYPE zben_s_root_info-sell_amount.
*    DATA: ls_tran_ben TYPE zben_tran_ben.
    SELECT SINGLE * FROM zben_benefits
               INTO ls_benefits
               WHERE catalog_id = 'MRK'
               AND benefit_id   = 59.

    CLEAR: ls_tran_ben.
    SELECT SINGLE * FROM zben_tran_ben
       INTO ls_tran_ben
      WHERE pernr = cs_model-root_info-pernr
        AND zyear = cs_model-root_info-zyear
        AND benefit_id = 59
        AND delete_ind NE abap_true.
*
*      remain=3000
*
    IF cs_model-root_info-remain_total GT  0 .
      IF ls_tran_ben IS INITIAL.
        ls_tran_ben-pernr = cs_model-root_info-pernr.
        ls_tran_ben-zyear = cs_model-root_info-zyear.
        ls_tran_ben-benefit_id        = ls_benefits-benefit_id.
        ls_tran_ben-benefit_group     = ls_benefits-benefit_group .
        ls_tran_ben-benefit_name      = ls_benefits-benefit_name .
****        IF ls_benefits-discount_rate GT 0.
****          lv_discount = cs_model-root_info-remain_total * ls_benefits-discount_rate.
****        ENDIF.
        ls_tran_ben-amount_net        = cs_model-root_info-remain_total + lv_discount.
*   ls_tran_ben-DEFAULT_SELECTION = ls_benefits- .
*        ls_tran_ben-amount_discount   = ls_benefits-amount_discount .
        ls_tran_ben-discount_rate     = ls_benefits-discount_rate .
        ls_tran_ben-catalog_id        = ls_benefits-catalog_id .
*   ls_tran_ben-DELETE_IND          ls_benefits- .

      ELSE.
***        IF ls_benefits-discount_rate GT 0.
***          lv_discount = cs_model-root_info-remain_total * ls_benefits-discount_rate.
***        ENDIF.
        ls_tran_ben-amount_net = ls_tran_ben-amount_net + cs_model-root_info-remain_total + lv_discount.
      ENDIF.
      MODIFY zben_tran_ben FROM ls_tran_ben.



      SELECT SINGLE * FROM zben_defin_pers
             INTO ls_defin_pers
             WHERE pernr = cs_model-root_info-pernr
             AND zyear = cs_model-root_info-zyear.



      SELECT SINGLE * FROM zben_tran_pers
         INTO ls_tran_pers
        WHERE pernr = cs_model-root_info-pernr
          AND zyear = cs_model-root_info-zyear
          AND delete_ind NE abap_true.



      IF ls_tran_pers IS NOT INITIAL.
        ls_tran_pers-pernr           = ls_defin_pers-pernr.
        ls_tran_pers-zyear           = ls_defin_pers-zyear.
        ls_tran_pers-status = 'AP'. "ONAYLANDI.

        ls_tran_pers-create_time = |{ sy-datum }{ sy-uzeit }|.
        ls_tran_pers-create_uname = sy-uname.

*      ls_tran_pers-default_selected =  abap_true.
        ls_tran_pers-annual_income   = cs_model-root_info-annual_income.
        ls_tran_pers-income_tax_rate = ls_defin_pers-income_tax_rate.
***        IF ls_benefits-discount_rate GT 0.
***          lv_discount = cs_model-root_info-remain_total * ls_benefits-discount_rate.
***        ENDIF.
        ls_tran_pers-cart_total      =  cs_model-root_info-cart_total + cs_model-root_info-remain_total.
        ls_tran_pers-remain_total    = 0.
        ls_tran_pers-amount_discount    = cs_model-root_info-amount_discount + lv_discount.
        ls_tran_pers-flexible_budget = cs_model-root_info-flexible_budget.
        ls_tran_pers-fixed_budget    = cs_model-root_info-fixed_budget.

        ls_tran_pers-actual_budget   =  cs_model-root_info-actual_budget.
        CLEAR:  ls_tran_pers-fixed_budget,ls_tran_pers-remain_total.
*
      ELSE.

        ls_tran_pers-pernr           = ls_defin_pers-pernr.
        ls_tran_pers-zyear           = ls_defin_pers-zyear.
        ls_tran_pers-status = 'AP'. "Kaydedildi.

        ls_tran_pers-create_time = |{ sy-datum }{ sy-uzeit }|.
        ls_tran_pers-create_uname = sy-uname.

*      ls_tran_pers-default_selected =  abap_true.
        ls_tran_pers-annual_income   = ls_defin_pers-annual_income.
        ls_tran_pers-income_tax_rate = ls_defin_pers-income_tax_rate.
        ls_tran_pers-flexible_budget = ls_defin_pers-flexible_budget.
        ls_tran_pers-fixed_budget    = ls_defin_pers-fixed_budget + cs_model-root_info-sell_amount..
        ls_tran_pers-cart_total   =  ls_defin_pers-flexible_budget + ls_defin_pers-fixed_budget.
        ls_tran_pers-actual_budget   =  ls_defin_pers-fixed_budget + ls_defin_pers-flexible_budget .
        CLEAR:  ls_tran_pers-fixed_budget,ls_tran_pers-remain_total.






      ENDIF.

    ENDIF.

    MODIFY zben_tran_pers FROM ls_tran_pers.
*    ENDLOOP.

    COMMIT WORK AND WAIT .

**>>>>> ended by ZTURAN 08.07.2023 12:23:58
  ENDMETHOD.


  METHOD PROCESS_CHANGE_SELECTION.

    DATA ls_benefits TYPE zben_benefits.
    DATA ls_tran_pers TYPE zben_tran_pers.
    DATA lt_tran_pers TYPE TABLE OF zben_tran_pers.
    DATA ls_tran_ben TYPE zben_tran_ben.
    DATA lt_tran_ben TYPE TABLE OF zben_tran_ben.
    DATA ls_defin_pers TYPE zben_defin_pers.
    DATA lv_discount TYPE zben_tran_pers-amount_discount.
    DATA: lt_image TYPE TABLE OF zben_bnft_image.



    SELECT SINGLE * FROM zben_benefits
           INTO ls_benefits
           WHERE catalog_id = 'YMK'.

    SELECT SINGLE * FROM zben_defin_pers
           INTO ls_defin_pers
           WHERE pernr = cs_model-root_info-pernr
           AND zyear = cs_model-root_info-zyear.


      ls_tran_ben-pernr             = cs_model-root_info-pernr.
      ls_tran_ben-zyear             = cs_model-root_info-zyear.
      ls_tran_ben-benefit_id        = ls_benefits-benefit_id.
      ls_tran_ben-catalog_id        = ls_benefits-catalog_id.
      ls_tran_ben-benefit_group     = ls_benefits-benefit_group.
      ls_tran_ben-benefit_name      = ls_benefits-benefit_name.
*      burada hesaplama yapılacak
      ls_tran_ben-amount_net        = ls_defin_pers-flexible_budget.
      ls_tran_ben-last_amount_net   = ls_defin_pers-flexible_budget.
      ls_tran_ben-amount_discount   = lv_discount.
*****        ls_tran_ben-discount_rate     = ls_item-discount_rate.
      MODIFY zben_tran_ben FROM ls_tran_ben.



      ls_tran_pers-pernr           = ls_defin_pers-pernr.
      ls_tran_pers-zyear           = ls_defin_pers-zyear.
      ls_tran_pers-status = 'SA'. "Kaydedildi..

      ls_tran_pers-create_time = |{ sy-datum }{ sy-uzeit }|.
      ls_tran_pers-create_uname = sy-uname.

      ls_tran_pers-default_selected = abap_false.
      ls_tran_pers-annual_income   = ls_defin_pers-annual_income.
      ls_tran_pers-income_tax_rate = ls_defin_pers-income_tax_rate.
      ls_tran_pers-flexible_budget = ls_defin_pers-flexible_budget.
      ls_tran_pers-fixed_budget    = ls_defin_pers-fixed_budget + cs_model-root_info-sell_amount..
      ls_tran_pers-cart_total      =  ls_defin_pers-flexible_budget .
      ls_tran_pers-actual_budget   =  ls_defin_pers-fixed_budget + ls_defin_pers-flexible_budget .
      ls_tran_pers-remain_total    =  ls_defin_pers-fixed_budget .
*      CLEAR:  ls_tran_pers-fixed_budget,ls_tran_pers-remain_total.

      MODIFY zben_tran_pers FROM ls_tran_pers.



*    ENDIF.
*    ENDLOOP.

    COMMIT WORK AND WAIT .

  ENDMETHOD.


  METHOD PROCESS_DEFAULT_SELECTION.

    DATA ls_benefits TYPE zben_benefits.
    DATA ls_tran_pers TYPE zben_tran_pers.
    DATA lt_tran_pers TYPE TABLE OF zben_tran_pers.
    DATA ls_tran_ben TYPE zben_tran_ben.
    DATA lt_tran_ben TYPE TABLE OF zben_tran_ben.
    DATA ls_defin_pers TYPE zben_defin_pers.
    DATA lv_discount TYPE zben_tran_pers-amount_discount.
    DATA: lt_image TYPE TABLE OF zben_bnft_image.

*    IF cs_model-cart_items IS NOT INITIAL.
*      SELECT * FROM zben_benefits
*        INTO TABLE @DATA(lt_benefits)
*        FOR ALL ENTRIES IN @cs_model-cart_items
*        WHERE benefit_id = @cs_model-cart_items-benefit_id.
*
*      SELECT * FROM zben_tran_ben
*         INTO TABLE @DATA(lt_tran_benefits)
*         FOR ALL ENTRIES IN @cs_model-cart_items
*         WHERE benefit_id = @cs_model-cart_items-benefit_id
*           AND pernr = @cs_model-root_info-pernr
*           AND zyear = @cs_model-root_info-zyear.
*
*
*    ENDIF.

*    SELECT SINGLE * FROM zben_def_per_log
*           INTO ls_defin_pers
*           WHERE pernr = cs_model-root_info-pernr
*           AND zyear = cs_model-root_info-zyear.
*    IF ls_defin_pers IS INITIAL.


    SELECT SINGLE * FROM zben_benefits
           INTO ls_benefits
           WHERE catalog_id = 'MRK'
           AND benefit_id   = 59.

    SELECT SINGLE * FROM zben_defin_pers
           INTO ls_defin_pers
           WHERE pernr = cs_model-root_info-pernr
           AND zyear = cs_model-root_info-zyear.

*    ENDIF.

*    SELECT SINGLE * FROM zben_tran_pers
*       INTO ls_tran_pers
*      WHERE pernr = cs_model-root_info-pernr
*        AND zyear = cs_model-root_info-zyear
*        AND delete_ind NE abap_true.
*
*
*
*    IF ls_tran_pers IS NOT INITIAL.
*
*
*
*
*
*    ELSE.

      ls_tran_ben-pernr             = cs_model-root_info-pernr.
      ls_tran_ben-zyear             = cs_model-root_info-zyear.
      ls_tran_ben-benefit_id        = ls_benefits-benefit_id.
      ls_tran_ben-catalog_id        = ls_benefits-catalog_id.
      ls_tran_ben-benefit_group     = ls_benefits-benefit_group.
      ls_tran_ben-benefit_name      = ls_benefits-benefit_name.
*      burada hesaplama yapılacak
      ls_tran_ben-amount_net        = ls_defin_pers-fixed_budget.
      ls_tran_ben-last_amount_net   = ls_defin_pers-fixed_budget.
      ls_tran_ben-amount_discount   = lv_discount.
*****        ls_tran_ben-discount_rate     = ls_item-discount_rate.
      MODIFY zben_tran_ben FROM ls_tran_ben.



      ls_tran_pers-pernr           = ls_defin_pers-pernr.
      ls_tran_pers-zyear           = ls_defin_pers-zyear.
      ls_tran_pers-status = 'AP'. "Onaylandı.

      ls_tran_pers-create_time = |{ sy-datum }{ sy-uzeit }|.
      ls_tran_pers-create_uname = sy-uname.

      ls_tran_pers-default_selected =  abap_true.
      ls_tran_pers-annual_income   = ls_defin_pers-annual_income.
      ls_tran_pers-income_tax_rate = ls_defin_pers-income_tax_rate.
      ls_tran_pers-flexible_budget = ls_defin_pers-flexible_budget.
      ls_tran_pers-fixed_budget    = ls_defin_pers-fixed_budget + cs_model-root_info-sell_amount..
      ls_tran_pers-cart_total   =  ls_defin_pers-flexible_budget + ls_defin_pers-fixed_budget.
      ls_tran_pers-actual_budget   =  ls_defin_pers-fixed_budget + ls_defin_pers-flexible_budget .
      CLEAR:  ls_tran_pers-fixed_budget,ls_tran_pers-remain_total.


      MODIFY zben_tran_pers FROM ls_tran_pers.



*    ENDIF.
*    ENDLOOP.

    COMMIT WORK AND WAIT .

  ENDMETHOD.


  METHOD process_reset_selection.

*    DATA ls_tran_pers TYPE zben_tran_pers.
*    DATA ls_tran_ben TYPE zben_tran_ben.
*    DATA lt_tran_ben TYPE TABLE OF zben_tran_ben.
    UPDATE zben_tran_ben SET delete_ind = 'X' WHERE pernr = cs_model-root_info-pernr
                                                AND zyear = cs_model-root_info-zyear.
*                                                AND benefit_id = 60
*                                                 AND catalog_ıd = 'YMK'.

    UPDATE zben_tran_pers SET delete_ind = 'X'
                              user_accepted = ''
                              status = ''
                        WHERE pernr = cs_model-root_info-pernr
                          AND zyear = cs_model-root_info-zyear.


    COMMIT WORK AND WAIT .
***>>>>> added by ZTURAN 08.07.2023 12:23:58
**    DATA: lv_guid      TYPE sysuuid_c32,
**          ls_root_info TYPE zben_s_root_info.
**    DATA: lo_provider TYPE REF TO zcl_ben_data_provider.
**    CREATE OBJECT lo_provider.
**
**
**
**    lo_provider->get_root_info(
**        EXPORTING
**           iv_guid         = lv_guid
**       IMPORTING
**           es_return = ls_root_info ) .
***    ls_model-guid = lv_guid = 'GUID_DEFAULT'.
**    MOVE-CORRESPONDING ls_root_info TO cs_model-root_info.
*
*
*    DATA: ls_benefits TYPE zben_benefits.
*    DATA: ls_defin_pers TYPE zben_defin_pers.
*    DATA: lv_discount TYPE zben_s_root_info-sell_amount.
**    DATA: ls_tran_ben TYPE zben_tran_ben.
*    SELECT SINGLE * FROM zben_benefits
*               INTO ls_benefits
*               WHERE catalog_id = 'MRK'
*               AND benefit_id   = 59.
*
*    CLEAR: ls_tran_ben.
*    SELECT SINGLE * FROM zben_tran_ben
*       INTO ls_tran_ben
*      WHERE pernr = cs_model-root_info-pernr
*        AND zyear = cs_model-root_info-zyear
*        AND benefit_id = 59
*        AND delete_ind NE abap_true.
**
**      remain=3000
**
*    IF cs_model-root_info-remain_total GT  0 .
*      IF ls_tran_ben IS INITIAL.
*        ls_tran_ben-pernr = cs_model-root_info-pernr.
*        ls_tran_ben-zyear = cs_model-root_info-zyear.
*        ls_tran_ben-benefit_id        = ls_benefits-benefit_id.
*        ls_tran_ben-benefit_group     = ls_benefits-benefit_group .
*        ls_tran_ben-benefit_name      = ls_benefits-benefit_name .
*****        IF ls_benefits-discount_rate GT 0.
*****          lv_discount = cs_model-root_info-remain_total * ls_benefits-discount_rate.
*****        ENDIF.
*        ls_tran_ben-amount_net        = cs_model-root_info-remain_total + lv_discount.
**   ls_tran_ben-DEFAULT_SELECTION = ls_benefits- .
**        ls_tran_ben-amount_discount   = ls_benefits-amount_discount .
*        ls_tran_ben-discount_rate     = ls_benefits-discount_rate .
*        ls_tran_ben-catalog_id        = ls_benefits-catalog_id .
**   ls_tran_ben-DELETE_IND          ls_benefits- .
*
*      ELSE.
****        IF ls_benefits-discount_rate GT 0.
****          lv_discount = cs_model-root_info-remain_total * ls_benefits-discount_rate.
****        ENDIF.
*        ls_tran_ben-amount_net = ls_tran_ben-amount_net + cs_model-root_info-remain_total + lv_discount.
*      ENDIF.
*      MODIFY zben_tran_ben FROM ls_tran_ben.
*
*
*
*      SELECT SINGLE * FROM zben_defin_pers
*             INTO ls_defin_pers
*             WHERE pernr = cs_model-root_info-pernr
*             AND zyear = cs_model-root_info-zyear.
*
*
*
*      SELECT SINGLE * FROM zben_tran_pers
*         INTO ls_tran_pers
*        WHERE pernr = cs_model-root_info-pernr
*          AND zyear = cs_model-root_info-zyear
*          AND delete_ind NE abap_true.
*
*
*
*      IF ls_tran_pers IS NOT INITIAL.
*        ls_tran_pers-pernr           = ls_defin_pers-pernr.
*        ls_tran_pers-zyear           = ls_defin_pers-zyear.
*        ls_tran_pers-status = 'AP'. "ONAYLANDI.
*
*        ls_tran_pers-create_time = |{ sy-datum }{ sy-uzeit }|.
*        ls_tran_pers-create_uname = sy-uname.
*
**      ls_tran_pers-default_selected =  abap_true.
*        ls_tran_pers-annual_income   = cs_model-root_info-annual_income.
*        ls_tran_pers-income_tax_rate = ls_defin_pers-income_tax_rate.
****        IF ls_benefits-discount_rate GT 0.
****          lv_discount = cs_model-root_info-remain_total * ls_benefits-discount_rate.
****        ENDIF.
*        ls_tran_pers-cart_total      =  cs_model-root_info-cart_total + cs_model-root_info-remain_total.
*        ls_tran_pers-remain_total    = 0.
*        ls_tran_pers-amount_discount    = cs_model-root_info-amount_discount + lv_discount.
*        ls_tran_pers-flexible_budget = cs_model-root_info-flexible_budget.
*        ls_tran_pers-fixed_budget    = cs_model-root_info-fixed_budget.
*
*        ls_tran_pers-actual_budget   =  cs_model-root_info-actual_budget.
*        CLEAR:  ls_tran_pers-fixed_budget,ls_tran_pers-remain_total.
**
*      ELSE.
*
*        ls_tran_pers-pernr           = ls_defin_pers-pernr.
*        ls_tran_pers-zyear           = ls_defin_pers-zyear.
*        ls_tran_pers-status = 'AP'. "Kaydedildi.
*
*        ls_tran_pers-create_time = |{ sy-datum }{ sy-uzeit }|.
*        ls_tran_pers-create_uname = sy-uname.
*
**      ls_tran_pers-default_selected =  abap_true.
*        ls_tran_pers-annual_income   = ls_defin_pers-annual_income.
*        ls_tran_pers-income_tax_rate = ls_defin_pers-income_tax_rate.
*        ls_tran_pers-flexible_budget = ls_defin_pers-flexible_budget.
*        ls_tran_pers-fixed_budget    = ls_defin_pers-fixed_budget + cs_model-root_info-sell_amount..
*        ls_tran_pers-cart_total   =  ls_defin_pers-flexible_budget + ls_defin_pers-fixed_budget.
*        ls_tran_pers-actual_budget   =  ls_defin_pers-fixed_budget + ls_defin_pers-flexible_budget .
*        CLEAR:  ls_tran_pers-fixed_budget,ls_tran_pers-remain_total.
*
*
*
*
*
*
*      ENDIF.
*
*    ENDIF.
*
*    MODIFY zben_tran_pers FROM ls_tran_pers.
**    ENDLOOP.
*
*    COMMIT WORK AND WAIT .

**>>>>> ended by ZTURAN 08.07.2023 12:23:58
  ENDMETHOD.


  METHOD sell_amount.

    DATA ls_defin_pers TYPE zben_defin_pers.
    DATA ls_tran_pers TYPE zben_tran_pers.
    DATA lt_tran_pers TYPE TABLE OF zben_tran_pers.
    DATA ls_tran_ben TYPE zben_tran_ben.
    DATA lt_tran_ben TYPE TABLE OF zben_tran_ben.
    DATA lv_discount TYPE zben_tran_pers-amount_discount.
    DATA lv_message_v1 TYPE bapiret2-message_v1.

*zcl_ben_odata_adapter=>check_data( CHANGING  cs_model = ls_model ) ..
*kontroller

    IF cs_model-root_info-selected_option EQ '3'. " Günlük tutarı belirlemek istiyorum.
*      IF cs_model-root_info-sell_amount IS INITIAL.
*        APPEND zcl_ben_utils=>message_number_to_return(
*                                 iv_type       = 'E'
*                                 iv_number     = '004'
*                                 iv_id         = 'ZBEN'
**                   iv_message_v1 =
**                   iv_message_v2 =
**                   iv_message_v3 =
**                   iv_message_v4 =
*                               ) TO mt_return.
*      ELSE.
***      IF cs_model-root_info-sell_amount GT cs_model-root_info-flexible_budget.
***        WRITE cs_model-root_info-flexible_budget TO lv_message_v1.
***        CONDENSE lv_message_v1.
***        APPEND zcl_ben_utils=>message_number_to_return(
***                                 iv_type       = 'E'
***                                 iv_number     = '005'
***                                 iv_id         = 'ZBEN'
***                                 iv_message_v1 = lv_message_v1
****                   iv_message_v2 =
****                   iv_message_v3 =
****                   iv_message_v4 =
***                               ) TO mt_return.
****        ENDIF.
***
***      ENDIF.
    ENDIF.

    CHECK mt_return IS INITIAL.

    SELECT SINGLE * FROM zben_tran_pers
      INTO CORRESPONDING FIELDS OF ls_tran_pers
      WHERE pernr = cs_model-root_info-pernr
        AND zyear = cs_model-root_info-zyear
        AND delete_ind NE 'X'..

*    SELECT SINGLE * FROM zben_def_per_log
*           INTO ls_defin_pers
*           WHERE pernr = cs_model-root_info-pernr
*           AND zyear = cs_model-root_info-zyear.
*    IF ls_defin_pers IS INITIAL.

    SELECT SINGLE * FROM zben_defin_pers
      INTO CORRESPONDING FIELDS OF ls_defin_pers
      WHERE pernr = cs_model-root_info-pernr
        AND zyear = cs_model-root_info-zyear.

    SELECT  * FROM zben_tran_ben
       INTO CORRESPONDING FIELDS OF TABLE lt_tran_ben
       WHERE pernr = cs_model-root_info-pernr
         AND zyear = cs_model-root_info-zyear
         AND delete_ind NE 'X'
         AND catalog_id NE 'YMK'.

    SELECT SINGLE * FROM zben_tran_ben
      INTO @DATA(ls_ben_yemek)
      WHERE pernr     = @cs_model-root_info-pernr
       AND catalog_id = 'YMK'
       AND zyear      = @cs_model-root_info-zyear
       AND delete_ind NE 'X'..
*    ENDIF.
*parametre bilgilerini getir
    SELECT * FROM zben_t_params
      INTO TABLE @DATA(lt_params).


    FIELD-SYMBOLS: <fs_data> TYPE any.
    DATA: BEGIN OF ls_value,
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
          END OF ls_value.

    DATA: lv_butce TYPE TB_CURR_11_5.
    DATA: lv_gunluk TYPE TB_CURR_11_5.
    DATA: lv_muafiyetsiz TYPE TB_CURR_11_5.
    DATA: lv_muafiyetli TYPE TB_CURR_11_5.
    DATA: lv_top_sgk_kes TYPE TB_CURR_11_5.
    DATA: lv_top_dvg TYPE TB_CURR_11_5.
    DATA: lv_top_vergi TYPE TB_CURR_11_5.
    DATA: lv_top_kesintiler TYPE TB_CURR_11_5.
    DATA: lv_toplam_gunluk TYPE TB_CURR_11_5.
    DATA: lv_top_kullanılabilir_ucret TYPE TB_CURR_11_5.
    DATA: lv_toplam_kesinti TYPE TB_CURR_11_5.
    DATA: lv_yemek_butce TYPE TB_CURR_11_5.
    DATA: lv_butceden_dusulecek_ucret TYPE TB_CURR_11_5.
    DATA: lv_kalan_ucret TYPE TB_CURR_11_5.
    DATA: lv_total_ben TYPE TB_CURR_11_5.
    DATA: lv_fark TYPE TB_CURR_11_5.


    LOOP AT lt_params ASSIGNING FIELD-SYMBOL(<fs_str>).
      IF <fs_str> IS ASSIGNED.
        ASSIGN COMPONENT 'PARAMID' OF STRUCTURE <fs_str> TO <fs_data>.
        IF <fs_data> IS ASSIGNED.
          CASE <fs_data>.
            WHEN 'YST'. "Yıllık SSK Tavan Matrahı
              ls_value-yst = <fs_str>-paramvalue.
            WHEN 'YGS'. "Yıllık İş Günü Sayısı
              ls_value-ygs = <fs_str>-paramvalue.
            WHEN 'YAU'. "Yıllık Asgari Ücret
              ls_value-yau = <fs_str>-paramvalue.
            WHEN 'TEMPKES'. "tempkesinti
              ls_value-tempkes = <fs_str>-paramvalue.
            WHEN 'SSKS'. "SSK Sakat kesinti ORANI
              ls_value-ssks = <fs_str>-paramvalue.
            WHEN 'SSKO'. "SSK prim oranı-Diğer
              ls_value-ssko = <fs_str>-paramvalue.
            WHEN 'SSKN'. "SSK prim oranı-Normal
              ls_value-sskn = <fs_str>-paramvalue.
            WHEN 'SSKE'. "SSK prim oranı-Emekli
              ls_value-sske = <fs_str>-paramvalue.
            WHEN 'SSKA'. "SSK Argeli kesinti ORANI
              ls_value-sska = <fs_str>-paramvalue.
            WHEN 'SSK'. "SGK kesintisi"
              ls_value-ssk = <fs_str>-paramvalue.
            WHEN 'REC'. "işe alım suresi
              ls_value-rec = <fs_str>-paramvalue.
            WHEN 'MUL'. "Mevcut yan hak seçiminde yemek kartına yükleme
              ls_value-mul = <fs_str>-paramvalue.
            WHEN 'GYM'. "Günlük Gelir Vergisi Yemek Muafiyet tutarı
              ls_value-gym = <fs_str>-paramvalue.
            WHEN 'EKEBB'."Eksi KEBB Bakiye Limiti
              ls_value-ekebb = <fs_str>-paramvalue.
            WHEN 'DVO'. "Damga Vergisi Kesinti Oranı
              ls_value-dvo = <fs_str>-paramvalue.

            WHEN OTHERS.
          ENDCASE.
          UNASSIGN <fs_data>.
        ENDIF.
      ENDIF.
    ENDLOOP.
* Personel genel bilgilerini güncelleme..

    ls_tran_pers-pernr           = ls_defin_pers-pernr.
    ls_tran_pers-zyear           = ls_defin_pers-zyear.
    ls_tran_pers-create_time = |{ sy-datum }{ sy-uzeit }|.
    ls_tran_pers-create_uname = sy-uname.

    ls_tran_pers-annual_income   = ls_defin_pers-annual_income.

    ls_tran_pers-income_tax_rate = ls_defin_pers-income_tax_rate.
    ls_tran_pers-selected_option = cs_model-root_info-selected_option.

    CASE cs_model-root_info-selected_option .

      WHEN '2'. " Tümünü almak istiyorum

        ls_tran_pers-flexible_budget = ls_defin_pers-flexible_budget.
        IF ls_value-ygs IS NOT INITIAL.
          ls_tran_pers-gunluk_yemek = ls_defin_pers-flexible_budget / ls_value-ygs..
        ENDIF.

        IF lt_tran_ben IS INITIAL.
          ls_tran_pers-fixed_budget    = ls_defin_pers-fixed_budget.
          ls_tran_pers-actual_budget   = cs_model-root_info-actual_budget.
          ls_tran_pers-remain_total    = cs_model-root_info-actual_budget - ls_defin_pers-flexible_budget.
          ls_tran_pers-cart_total      = cs_model-root_info-actual_budget - ls_tran_pers-remain_total.
*          ls_tran_pers-amount_discount = cs_model-root_info-amount_discount.
*>>>>> added by ZTURAN 12.07.2023 14:17:14
          ls_tran_pers-defined_fixed_budget = ls_defin_pers-fixed_budget.
          ls_tran_pers-majority_budget = 0.
*>>>>> ended by ZTURAN 12.07.2023 14:17:14
          CLEAR:ls_tran_pers-reduce_tax,ls_tran_pers-amount_discount.
          MODIFY zben_tran_pers FROM ls_tran_pers.
        ELSE.

          LOOP AT lt_tran_ben INTO ls_tran_ben.
            lv_total_ben = lv_total_ben + ls_tran_ben-amount_net - ( ls_tran_ben-amount_net * ls_tran_ben-discount_rate ).
          ENDLOOP.
          ls_tran_pers-actual_budget   = cs_model-root_info-actual_budget.
          ls_tran_pers-cart_total      = ls_tran_pers-flexible_budget + lv_total_ben."( ls_tran_pers-actual_budget - ls_defin_pers-flexible_budget - cs_model-root_info-amount_discount ).
          IF ls_tran_pers-cart_total GT ls_tran_pers-actual_budget.
            "Genel mevcut bütçenizi aştınız.
            lv_fark = ls_tran_pers-actual_budget - ls_tran_pers-cart_total.
            WRITE lv_fark TO lv_message_v1.
            CONDENSE lv_message_v1.
            APPEND zcl_ben_utils=>message_number_to_return(
                                 iv_type       = 'E'
                                 iv_number     = '006'
                                 iv_id         = 'ZBEN'
                                 iv_message_v1 = lv_message_v1
                               ) TO mt_return.


          ELSE.
            ls_tran_pers-remain_total    = ls_tran_pers-actual_budget - ls_tran_pers-cart_total.
            ls_tran_pers-fixed_budget    = ls_tran_pers-remain_total.
*          ls_tran_pers-cart_total      = cs_model-root_info-cart_total.
            ls_tran_pers-amount_discount = cs_model-root_info-amount_discount.

*>>>>> added by ZTURAN 12.07.2023 14:17:14
            ls_tran_pers-defined_fixed_budget = ls_defin_pers-fixed_budget.
            ls_tran_pers-majority_budget = 0.
*            ls_tran_pers-majority_budget = ls_tran_pers-actual_budget - ls_defin_pers-flexible_budget - ls_defin_pers-fixed_budget.
*>>>>> ended by ZTURAN 12.07.2023 14:17:14
            CLEAR:ls_tran_pers-reduce_tax.
            MODIFY zben_tran_pers FROM ls_tran_pers.
          ENDIF.
        ENDIF.

*>>>>> added by ZTURAN 12.07.2023 17:25:45
        CLEAR: ls_ben_yemek-delete_ind.
        ls_ben_yemek-amount_net = ls_tran_pers-flexible_budget .
        ls_ben_yemek-last_amount_net = ls_tran_pers-flexible_budget.
        MODIFY zben_tran_ben FROM ls_ben_yemek.
*>>>>> ended by ZTURAN 12.07.2023 17:25:45


      WHEN '1' OR  '3'. " Günlük tutarı belirlemek istiyorum.
        lv_gunluk = ls_defin_pers-flexible_budget / ls_value-ygs.

        IF cs_model-root_info-selected_option EQ '1'.
          CLEAR:cs_model-root_info-sell_amount.
        ENDIF.
        lv_butce = cs_model-root_info-sell_amount * ls_value-ygs.
*        lv_toplamsepet =

        IF lv_butce GT cs_model-root_info-flexible_budget + cs_model-root_info-remain_total + cs_model-root_info-reduce_tax  .

          lv_fark = lv_butce - ( cs_model-root_info-flexible_budget + cs_model-root_info-remain_total  + cs_model-root_info-reduce_tax ).
          WRITE lv_fark TO lv_message_v1.
          CONDENSE lv_message_v1.
          "Genel mevcut bütçenizi aştınız.
          APPEND zcl_ben_utils=>message_number_to_return(
                               iv_type       = 'E'
                               iv_number     = '009'
                               iv_id         = 'ZBEN'
                               iv_message_v1 = lv_message_v1

                             ) TO mt_return.
        ELSE.




          IF cs_model-root_info-sell_amount GT ls_value-gym.
**          muafiyet rakamı aşılırsa
**          lv_bütce = cs_model-root_info-sell_amount * ls_value-ygs.

*            lv_muafiyetsiz              = ls_value-gym - cs_model-root_info-sell_amount.
*            lv_muafiyetli               = lv_gunluk - lv_muafiyetsiz.
*            lv_top_sgk_kes              = ls_value-ssk * lv_muafiyetsiz.
*            lv_top_dvg                  = ls_value-dvo * lv_muafiyetsiz.
*            lv_top_vergi                = ( lv_muafiyetsiz - lv_top_sgk_kes ) * ls_defin_pers-income_tax_rate.
*            lv_top_kesintiler           = lv_muafiyetsiz - ( lv_top_sgk_kes + lv_top_dvg + lv_top_vergi ).
*            lv_toplam_gunluk            = lv_top_kesintiler + lv_muafiyetli.
*            lv_top_kullanılabilir_ucret = lv_toplam_gunluk * ls_value-ygs.
*            lv_toplam_kesinti           = ls_defin_pers-flexible_budget - lv_top_kullanılabilir_ucret.
*            lv_yemek_butce              = cs_model-root_info-sell_amount * ls_value-ygs.
*            lv_butceden_dusulecek_ucret = lv_toplam_kesinti + lv_yemek_butce.
*            lv_kalan_ucret              = ls_defin_pers-flexible_budget - lv_butceden_dusulecek_ucret.

            ls_tran_pers-actual_budget   = ls_defin_pers-fixed_budget + ls_defin_pers-flexible_budget.
            ls_tran_pers-cart_total    = cs_model-root_info-cart_total + ( lv_butce - ( cs_model-root_info-flexible_budget + cs_model-root_info-reduce_tax ) ) ."ls_defin_pers-fixed_budget + lv_kalan_ucret."
*            ls_tran_pers-remain_total    = ( ls_defin_pers-fixed_budget + ls_defin_pers-flexible_budget ) - lv_butce ."ls_defin_pers-fixed_budget + lv_kalan_ucret."
            ls_tran_pers-remain_total      = ls_tran_pers-actual_budget - ls_tran_pers-cart_total .
*            ls_tran_pers-remain_total      = ls_defin_pers-flexible_budget + ls_defin_pers-fixed_budget - ls_tran_pers-remain_total  .
            ls_tran_pers-flexible_budget = lv_butce."ls_defin_pers-flexible_budget - cs_model-root_info-sell_amount.
            ls_tran_pers-fixed_budget    = ls_tran_pers-remain_total." - ls_tran_pers-flexible_budget."ls_defin_pers-fixed_budget + cs_model-root_info-sell_amount..

*>>>>> added by ZTURAN 12.07.2023 14:17:14
            ls_tran_pers-defined_fixed_budget = ls_defin_pers-fixed_budget.
            ls_tran_pers-majority_budget = ls_defin_pers-flexible_budget - lv_butce.
*            ls_tran_pers-majority_budget = ls_tran_pers-fixed_budget - ls_tran_pers-defined_fixed_budget.
*>>>>> ended by ZTURAN 12.07.2023 14:17:14

*          ls_tran_pers-reduce_tax      = lv_toplam_kesinti.
            CLEAR: ls_tran_pers-reduce_tax.
*>>>>> added by ZTURAN 12.07.2023 17:25:45
            IF ls_tran_pers-flexible_budget EQ 0.
              ls_ben_yemek-delete_ind = 'X'.
            ELSE.
              CLEAR: ls_ben_yemek-delete_ind.
            ENDIF.
            ls_ben_yemek-amount_net = ls_tran_pers-flexible_budget .
            ls_ben_yemek-last_amount_net = ls_tran_pers-flexible_budget.
            MODIFY zben_tran_ben FROM ls_ben_yemek.
*>>>>> ended by ZTURAN 12.07.2023 17:25:45
          ELSE.

            lv_muafiyetsiz              = ls_value-gym - cs_model-root_info-sell_amount.
            lv_muafiyetli               = lv_gunluk - lv_muafiyetsiz.
            lv_top_sgk_kes              = ls_value-ssk * lv_muafiyetsiz.
            lv_top_dvg                  = ls_value-dvo * lv_muafiyetsiz.
            lv_top_vergi                = ( lv_muafiyetsiz - lv_top_sgk_kes ) * ls_defin_pers-income_tax_rate.
            lv_top_kesintiler           = lv_muafiyetsiz - ( lv_top_sgk_kes + lv_top_dvg + lv_top_vergi ).
            lv_toplam_gunluk            = lv_top_kesintiler + lv_muafiyetli.
            lv_top_kullanılabilir_ucret = lv_toplam_gunluk * ls_value-ygs.
            lv_toplam_kesinti           = ls_defin_pers-flexible_budget - lv_top_kullanılabilir_ucret.
            lv_yemek_butce              = cs_model-root_info-sell_amount * ls_value-ygs.
            lv_butceden_dusulecek_ucret = lv_toplam_kesinti + lv_yemek_butce.
            lv_kalan_ucret              = ls_defin_pers-flexible_budget - lv_butceden_dusulecek_ucret.


            ls_tran_pers-actual_budget   = ls_defin_pers-fixed_budget + ls_defin_pers-flexible_budget.
            ls_tran_pers-flexible_budget = lv_butce."ls_defin_pers-flexible_budget - cs_model-root_info-sell_amount.

*            IF cs_model-root_info-reduce_tax IS INITIAL.
*              ls_tran_pers-cart_total      = ( ls_tran_pers-actual_budget - cs_model-root_info-flexible_budget - cs_model-root_info-remain_total - cs_model-root_info-reduce_tax ).
*              ls_tran_pers-remain_total    = ls_tran_pers-actual_budget - ls_tran_pers-cart_total - lv_toplam_kesinti.
*            ELSE.
            IF cs_model-root_info-selected_option EQ '1'.
              ls_tran_pers-cart_total      = ( ls_tran_pers-actual_budget - cs_model-root_info-flexible_budget - cs_model-root_info-remain_total - cs_model-root_info-reduce_tax )." + lv_butceden_dusulecek_ucret.
              ls_tran_pers-remain_total    = ls_tran_pers-actual_budget - ls_tran_pers-cart_total - lv_toplam_kesinti.
            ELSE.
              ls_tran_pers-cart_total      = ( ls_tran_pers-actual_budget - cs_model-root_info-flexible_budget - cs_model-root_info-remain_total - cs_model-root_info-reduce_tax ) + lv_butceden_dusulecek_ucret.
              ls_tran_pers-remain_total    = ls_tran_pers-actual_budget - ls_tran_pers-cart_total." - lv_toplam_kesinti.
            ENDIF.

*            ENDIF.

            ls_tran_pers-reduce_tax      = lv_toplam_kesinti.
            ."ls_defin_pers-fixed_budget + cs_model-root_info-sell_amount.
            ls_tran_pers-fixed_budget    = ls_tran_pers-remain_total." - ls_tran_pers-flexible_budget."ls_defin_pers-fixed_budget + cs_model-root_info-sell_amount..
*            ls_tran_pers-actual_budget   = ls_defin_pers-fixed_budget + ls_defin_pers-flexible_budget.
**            ls_tran_pers-cart_total      = ls_defin_pers-flexible_budget + ls_defin_pers-fixed_budget - ls_tran_pers-remain_total  .
*            ls_tran_pers-cart_total      = cs_model-root_info-cart_total + ( lv_butce - ( cs_model-root_info-flexible_budget + cs_model-root_info-reduce_tax ) ).
**            ls_tran_pers-remain_total    = ls_defin_pers-fixed_budget + lv_kalan_ucret."ls_defin_pers-fixed_budget + cs_model-root_info-sell_amount.
*            ls_tran_pers-remain_total      = ls_tran_pers-actual_budget - ls_tran_pers-cart_total .
*
*            ls_tran_pers-fixed_budget    = ls_tran_pers-remain_total." - ls_tran_pers-flexible_budget."ls_defin_pers-fixed_budget + cs_model-root_info-sell_amount..
*
*
*            ls_tran_pers-reduce_tax      = lv_toplam_kesinti.
*>>>>> added by ZTURAN 12.07.2023 14:17:14
            ls_tran_pers-defined_fixed_budget = ls_defin_pers-fixed_budget.
            ls_tran_pers-majority_budget = ls_defin_pers-flexible_budget - lv_butce.
*            ls_tran_pers-majority_budget = ls_tran_pers-fixed_budget - ls_tran_pers-defined_fixed_budget.
*>>>>> ended by ZTURAN 12.07.2023 14:17:14
*>>>>> added by ZTURAN 12.07.2023 17:25:45
            IF ls_tran_pers-flexible_budget EQ 0.
              ls_ben_yemek-delete_ind = 'X'.
            ELSE.
              CLEAR: ls_ben_yemek-delete_ind.
            ENDIF.
            ls_ben_yemek-amount_net = ls_tran_pers-flexible_budget .
            ls_ben_yemek-last_amount_net = ls_tran_pers-flexible_budget + ls_tran_pers-reduce_tax.
            MODIFY zben_tran_ben FROM ls_ben_yemek.
*>>>>> ended by ZTURAN 12.07.2023 17:25:45
          ENDIF.
          IF ls_value-ygs IS NOT INITIAL.
            ls_tran_pers-gunluk_yemek = lv_butce / ls_value-ygs..
          ENDIF.

          MODIFY zben_tran_pers FROM ls_tran_pers.
        ENDIF.
    ENDCASE.


***    MODIFY zben_tran_pers FROM ls_tran_pers.


*      ls_defin_pers-fixed_budget = ls_defin_pers-fixed_budget + cs_model-root_info-sell_amount.
*      ls_defin_pers-flexible_budget = ls_defin_pers-flexible_budget - cs_model-root_info-sell_amount.
*      MODIFY zben_defin_pers FROM ls_defin_pers."20062023
*      MODIFY zben_def_per_log FROM ls_defin_pers."20062023


    CHECK mt_return IS INITIAL.


    APPEND zcl_ben_utils=>message_number_to_return(
                               iv_type       = 'S'
                               iv_number     = '007'
                               iv_id         = 'ZBEN'

                             ) TO mt_return.
* Personel sepet bilgilerini güncelleme.



*          ls_tran_pers-amount_discount   =  ls_tran_pers-amount_discount + lv_discount  .
**        GET TIME STAMP FIELD ls_tran_pers-create_time.
*          ls_tran_pers-create_time = |{ sy-datum }{ sy-uzeit }|.
*          ls_tran_pers-create_uname = sy-uname.
*          ls_tran_pers-pernr = cs_model-root_info-pernr.
*          ls_tran_pers-zyear = sy-datum+0(4).
*          ls_tran_pers-status = 'SA'. "Kaydedildi.

*
*          ls_tran_ben-pernr             = cs_model-root_info-pernr.
*          ls_tran_ben-zyear             = cs_model-root_info-zyear.
*          ls_tran_ben-benefit_id        = ls_item-benefit_id.
*          ls_tran_ben-catalog_id        = ls_item-catalog_id.
*          ls_tran_ben-benefit_group     = ls_item-benefit_group.
*          ls_tran_ben-benefit_name      = ls_item-benefit_name.
*          ls_tran_ben-amount_net        = ls_item-amount_net.
**     ls_tran_ben- DEFAULT_SELECTION = ls_item-de.
*          ls_tran_ben-amount_discount   = lv_discount.
*          ls_tran_ben-discount_rate     = ls_item-discount_rate.
*          MODIFY zben_tran_ben FROM ls_tran_ben.
**        ELSE.
**
**          APPEND zcl_ben_utils=>message_number_to_return(
**                   iv_type       = 'E'
**                   iv_number     = '001'
**                   iv_id         = 'ZBEN'
***                   iv_message_v1 =
***                   iv_message_v2 =
***                   iv_message_v3 =
***                   iv_message_v4 =
**                 ) TO mt_return.
**
**        ENDIF.
**        READ TABLE lt_image INTO DATA(ls_image) WITH KEY catalog_id = ls_item-catalog_id
**                                                 benefit_id = ls_item-benefit_id.
**        IF sy-subrc EQ 0.
**          MOVE-CORRESPONDING ls_image TO ls_item-file.
**          MODIFY cs_model-cart_items  FROM ls_item.
**        ENDIF.
*      ENDIF.
*    ENDLOOP.
**
**    BREAK-POINT.
*
**    MOVE-CORRESPONDING cs_model-root_info TO ls_tran_ben.
*
**    MODIFY zben_tran_ben FROM TABLE lt_tran_ben.
**    MODIFY zben_tran_pers FROM TABLE lt_tran_pers.
**    MODIFY zben_tran_pers FROM ls_tran_pers.

    COMMIT WORK AND WAIT .

  ENDMETHOD.
ENDCLASS.
