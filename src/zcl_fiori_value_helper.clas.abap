class ZCL_FIORI_VALUE_HELPER definition
  public
  final
  create public .

public section.

  class-methods PREPARE_VALUE_HELP
    importing
      !IR_CRITER1 type ZBEN_TT_CRITERIA_RANGE optional
      !IR_CRITER2 type ZBEN_TT_CRITERIA_RANGE optional
      !IR_CRITER3 type ZBEN_TT_CRITERIA_RANGE optional
    changing
      !CS_VALUE_HELP type ZBEN_S_VALUE_HELP .
  class-methods PREPARE_VALUE_HELP_BEN
    importing
      !IR_CRITER1 type ZBEN_TT_CRITERIA_RANGE optional
      !IR_CRITER2 type ZBEN_TT_CRITERIA_RANGE optional
      !IR_CRITER3 type ZBEN_TT_CRITERIA_RANGE optional
    changing
      !CS_VALUE_HELP type ZBEN_S_VALUE_HELP .
protected section.
private section.
ENDCLASS.



CLASS ZCL_FIORI_VALUE_HELPER IMPLEMENTATION.


  METHOD prepare_value_help.
*    DATA: lr_kinds TYPE RANGE OF zmm_t_may_kinds-material_kind,
*          lr_werks TYPE RANGE OF t001w-werks,
*          lr_mtart TYPE RANGE OF mara-mtart.
*
*    DATA: lv_matkl_like  TYPE mara-matkl.
*
*    DATA : lr_matnr TYPE RANGE OF mara-matnr.
*
*
*    CASE  cs_value_help-name.
*      WHEN 'MaterialKind'.
*
*        DATA(lt_values) = zcl_abap_utils=>get_domain_fixed_values( 'ZMM_MATERIAL_KIND' ).
*        cs_value_help-values = CORRESPONDING #( lt_values MAPPING key = domvalue_l value1 =  ddtext ) .
*
*      WHEN 'Mtart'.
*
*
*        lr_kinds = CORRESPONDING #( ir_criter1 ) .
*
*        IF lr_kinds IS NOT INITIAL.
*
*          SELECT *
*            FROM zmm_t_may_kinds
*            INTO TABLE @DATA(lt_kinds)
*            WHERE material_kind IN @lr_kinds.
*          IF lt_kinds IS NOT INITIAL.
*            SELECT *
*              FROM t134t
*              INTO TABLE @DATA(lt_t134t)
*              FOR ALL ENTRIES IN @lt_kinds
*              WHERE mtart EQ @lt_kinds-mtart AND
*                    spras EQ @sy-langu .
*
*            cs_value_help-values = CORRESPONDING #( lt_t134t MAPPING key = mtart value1 =  mtbez ) .
*          ENDIF.
*        ENDIF.
*
*      WHEN 'Matkl'.
*
*
*
*        lr_kinds = CORRESPONDING #( ir_criter1 ) .
*
*        CHECK lr_kinds IS NOT INITIAL.
*        DATA(lv_kind) = lr_kinds[ 1 ]-low .
*
*        CASE lv_kind.
*          WHEN 'DV'.
*            lv_matkl_like = 'DV%'.
*          WHEN 'ST'.
*            lv_matkl_like = 'S-%'.
*          WHEN 'DS'.
*            lv_matkl_like = 'MG%'.
*
*        ENDCASE.
*
*        SELECT *
*          FROM t023t
*          INTO TABLE @DATA(lt_t023t)
*          WHERE spras EQ @sy-langu AND
*                matkl LIKE @lv_matkl_like.
*        cs_value_help-values = CORRESPONDING #( lt_t023t MAPPING key = matkl value1 =  wgbez value2 = wgbez60 ) .
*
*      WHEN 'Meins'.
*
*        SELECT *
*          FROM t006a
*          INTO TABLE @DATA(lt_t006a)
*          WHERE spras EQ @sy-langu."AND
**                msehi EQ 'ST'.
*
*
*        LOOP AT lt_t006a ASSIGNING FIELD-SYMBOL(<ls_t006a>).
*          CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
*            EXPORTING
*              input          = <ls_t006a>-msehi
*              language       = sy-langu
*            IMPORTING
*              output         = <ls_t006a>-msehi
*            EXCEPTIONS
*              unit_not_found = 1
*              OTHERS         = 2.
*          IF sy-subrc <> 0.
*          ENDIF.
*        ENDLOOP.
*        cs_value_help-values = CORRESPONDING #( lt_t006a MAPPING key = msehi value1 =  msehl ) .
*        SORT cs_value_help-values BY key.
*      WHEN 'Extwg'.
*
*        SELECT *
*          FROM twewt
*          INTO TABLE @DATA(lt_twewt)
*          WHERE spras EQ @sy-langu.
*        cs_value_help-values = CORRESPONDING #( lt_twewt MAPPING key = extwg value1 =  ewbez ) .
*
*
*      WHEN 'VendorChoice'.
*
*        SELECT *
*          FROM lfa1
*          INTO TABLE @DATA(lt_lfa1)
*          WHERE loevm EQ @space AND sperr EQ @space.
*
*        cs_value_help-values = CORRESPONDING #( lt_lfa1 MAPPING key = lifnr value1 =  name1 ) .
*
*      WHEN 'Dismm'.
*
*        SELECT *
*          FROM t438t
*          INTO TABLE @DATA(lt_t438t)
*         WHERE spras EQ @sy-langu.
*
*        cs_value_help-values = CORRESPONDING #( lt_t438t MAPPING key = dismm value1 =  dibez ) .
*
*      WHEN 'Lgfsb'.
*
*        SELECT *
*          FROM t001l
*          INTO TABLE @DATA(lt_t001l).
*
*        cs_value_help-values = CORRESPONDING #( lt_t001l MAPPING key = lgort value1 =  lgobe value2 =  werks ) .
*
*      WHEN 'Werks'.
*
*        SELECT *
*          FROM t001w
*          INTO TABLE @DATA(lt_t001w)
*          WHERE spras EQ 'T'.
*
*        cs_value_help-values = CORRESPONDING #( lt_t001w MAPPING key = werks value1 =  name1 ) .
*
*      WHEN 'ExpandWerks'.
*
*
*        lr_matnr = CORRESPONDING #( ir_criter1 ) .
*
*        LOOP AT lr_matnr ASSIGNING FIELD-SYMBOL(<ls_matnr>) WHERE low IS NOT INITIAL.
*          CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
*            EXPORTING
*              input        = <ls_matnr>-low
*            IMPORTING
*              output       = <ls_matnr>-low
*            EXCEPTIONS
*              length_error = 1
*              OTHERS       = 2.
*        ENDLOOP.
*
*        SELECT *
*          FROM t001w
*          INTO TABLE lt_t001w
*          WHERE spras EQ 'T'.
*
**        IF lr_matnr IS NOT INITIAL.
**
**          SELECT *
**           FROM marc
**           INTO TABLE @DATA(lt_marc) WHERE matnr IN @lr_matnr.
*
**          LOOP AT lt_marc INTO DATA(ls_marc).
**            DELETE lt_t001w WHERE werks EQ ls_marc-werks.
**          ENDLOOP.
*
**        ENDIF.
*
*
*        cs_value_help-values = CORRESPONDING #( lt_t001w MAPPING key = werks value1 =  name1 ) .
*      WHEN 'Lgort'.
*
*        lr_werks = CORRESPONDING #( ir_criter1 ) .
*
*        SELECT *
*          FROM t001l
*          INTO TABLE @DATA(lt_t001lx) WHERE werks IN @lr_werks.
*
*        DELETE lt_t001lx WHERE lgort(1) NE 'D'.
*
*        cs_value_help-values = CORRESPONDING #( lt_t001lx MAPPING key = lgort value1 =  lgobe value2 =  werks ) .
*
*      WHEN 'ExpandLgort'.
*
*        lr_matnr = CORRESPONDING #( ir_criter1 ) .
*        lr_werks = CORRESPONDING #( ir_criter2 ) .
*
*        LOOP AT lr_matnr ASSIGNING <ls_matnr> WHERE low IS NOT INITIAL.
*          CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
*            EXPORTING
*              input        = <ls_matnr>-low
*            IMPORTING
*              output       = <ls_matnr>-low
*            EXCEPTIONS
*              length_error = 1
*              OTHERS       = 2.
*        ENDLOOP.
*
*        SELECT *
*          FROM t001l
*          INTO TABLE @lt_t001lx WHERE werks IN @lr_werks.
*
*        DELETE lt_t001lx WHERE lgort(1) NE 'D'.
*
*        IF lr_matnr IS NOT INITIAL.
*
*          SELECT *
*           FROM mard
*           INTO TABLE @DATA(lt_mard) WHERE matnr IN @lr_matnr.
*
*          LOOP AT lt_mard INTO DATA(ls_mard).
*            DELETE lt_t001lx WHERE lgort EQ ls_mard-lgort.
*          ENDLOOP.
*
*        ENDIF.
*
*        cs_value_help-values = CORRESPONDING #( lt_t001lx MAPPING key = lgort value1 =  lgobe value2 =  werks ) .
*
*      WHEN 'Bklas'.
*
*        lr_mtart = CORRESPONDING #( ir_criter1 ) .
*        CHECK lr_mtart IS NOT INITIAL.
*        SELECT t025t~bklas , t025t~bkbez
*          FROM t025t
*          INNER JOIN t025 ON t025~bklas EQ t025t~bklas
*          INNER JOIN t134 ON t134~kkref EQ t025~kkref
*          INTO TABLE @DATA(lt_t025t)
*          WHERE spras EQ 'T' AND
*                mtart IN @lr_mtart.
*
*        cs_value_help-values = CORRESPONDING #( lt_t025t MAPPING key = bklas value1 =  bkbez ) .
*
*      WHEN 'Equnr'.
*
*        SELECT *
*          FROM eqkt
*          INTO TABLE @DATA(lt_eqkt)
*          WHERE spras EQ 'T'.
*
*        cs_value_help-values = CORRESPONDING #( lt_eqkt MAPPING key = equnr value1 =  eqktu ) .
*
*      WHEN 'Lifnr'.
*
*
*        SELECT *
*          FROM lfa1
*          INTO TABLE @DATA(lt_lfa1x)
*          WHERE loevm EQ @space AND sperr EQ @space.
*
*        cs_value_help-values = CORRESPONDING #( lt_lfa1x MAPPING key = lifnr value1 =  name1 ) .
*
*      WHEN 'Currency'.
*        cs_value_help-values = VALUE #( ( key = 'TRY' value1 = 'Türk Lirası' ) ( key = 'USD' value1 = 'Amerikan doları' ) ) .
*
*      WHEN OTHERS.
*    ENDCASE.
*
*
*
*    CASE cs_value_help-name..
*      WHEN 'Lifnr' OR 'Equnr' OR 'Bklas' OR 'Extwg' OR  'VendorChoice' OR 'Lgfsb' OR 'Currency'.
*
*        IF cs_value_help-values IS NOT INITIAL.
*          READ TABLE cs_value_help-values TRANSPORTING NO FIELDS WITH KEY key = space.
*          IF sy-subrc IS NOT INITIAL.
*            INSERT VALUE #( key = space value1 = 'Boş değer' ) INTO cs_value_help-values INDEX 1.
*          ENDIF.
*        ENDIF.
*
*    ENDCASE.
*
*

  ENDMETHOD.


  method PREPARE_VALUE_HELP_BEN.

* DATA: lr_pernr TYPE RANGE OF pa0001-pernr,
*          lr_kinds TYPE RANGE OF zmm_t_may_kinds-material_kind,
*          lr_werks TYPE RANGE OF t001w-werks,
*          lr_mtart TYPE RANGE OF mara-mtart.
*
*    DATA: lv_matkl_like  TYPE mara-matkl.
*
*    DATA : lr_matnr TYPE RANGE OF mara-matnr.
*
*    CONSTANTS : c_organization VALUE 'O' TYPE otype.

*    CASE  cs_value_help-name.
*      WHEN 'Pernr'.
*
**        lr_name1 =
*        SELECT pernr, ename, stext
*           FROM pa0001
*          INNER JOIN hrp1000 ON hrp1000~objid EQ pa0001~orgeh AND
*                                hrp1000~otype EQ @c_organization
*          INTO TABLE @DATA(lt_values).
**        DATA(lt_values) = zcl_abap_utils=>get_domain_fixed_values( 'PERNR' ).
*        cs_value_help-values = CORRESPONDING #( lt_values MAPPING key = pernr value1 = ename value2 = stext ) .
*
*
*      WHEN 'Meins'.
*
*        SELECT *
*          FROM t006a
*          INTO TABLE @DATA(lt_t006a)
*          WHERE spras EQ @sy-langu."AND
**                msehi EQ 'ST'.
*
*
*        LOOP AT lt_t006a ASSIGNING FIELD-SYMBOL(<ls_t006a>).
*          CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
*            EXPORTING
*              input          = <ls_t006a>-msehi
*              language       = sy-langu
*            IMPORTING
*              output         = <ls_t006a>-msehi
*            EXCEPTIONS
*              unit_not_found = 1
*              OTHERS         = 2.
*          IF sy-subrc <> 0.
*          ENDIF.
*        ENDLOOP.
*        cs_value_help-values = CORRESPONDING #( lt_t006a MAPPING key = msehi value1 =  msehl ) .
*        SORT cs_value_help-values BY key.
*
*
*      WHEN 'Currency'.
*        cs_value_help-values = VALUE #( ( key = 'TRY' value1 = 'Türk Lirası' ) ( key = 'USD' value1 = 'Amerikan doları' ) ) .
*
*      WHEN 'Sbnaman'.
*        SELECT *
*          FROM zmm_t_hay_prs_ex
*          INTO TABLE @DATA(lt_pers_exit).
*
*        cs_value_help-values = CORRESPONDING #( lt_pers_exit MAPPING key = sbnaman value1 =  tanim ) .
*        SORT cs_value_help-values BY key.
*
*      WHEN OTHERS.
*    ENDCASE.

  endmethod.
ENDCLASS.
