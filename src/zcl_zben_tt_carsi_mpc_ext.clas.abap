class ZCL_ZBEN_TT_CARSI_MPC_EXT definition
  public
  inheriting from ZCL_ZBEN_TT_CARSI_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZBEN_TT_CARSI_MPC_EXT IMPLEMENTATION.


  METHOD define.
*    DATA:
*      lo_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
*      lo_property    TYPE REF TO /iwbep/if_mgw_odata_property.
*
*
*
*    super->define( ).
*
*    lo_entity_type = model->get_entity_type(
*                            iv_entity_name = 'Image' ).
*    lo_entity_type->set_is_media( ).
*
*    IF lo_entity_type IS BOUND.
***      Set Content Source
*      lo_property = lo_entity_type->get_property(
*                                    iv_property_name = 'Value' ).
*      lo_property->set_as_content_source( ).
*
**      Set Content Type
**      Set Content Type
*      lo_property = lo_entity_type->get_property(
*                                    iv_property_name = 'CatalogId' ).
*      lo_property->set_as_content_type( ).
**      *      Set Content Type
*      lo_property = lo_entity_type->get_property(
*                                    iv_property_name = 'BenefitId' ).
*      lo_property->set_as_content_type( ).
*
*      lo_property = lo_entity_type->get_property(
*                                    iv_property_name = 'FileName' ).
*      lo_property->set_as_content_type( ).
*    ENDIF.


    super->define( ).
    model->get_entity_type( iv_entity_name = `BenefitFile` )->get_property( iv_property_name = `MimeType` )->set_as_content_type( ).
  ENDMETHOD.
ENDCLASS.
