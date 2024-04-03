class ZCL_ABAP_UTILS definition
  public
  final
  create public .

public section.

  class-methods GET_USER_EMAIL
    importing
      !IV_USER type USR21-BNAME optional
    returning
      value(EV_EMAIL) type AD_SMTPADR .
  class-methods GET_USER_NAME
    importing
      !IV_USER type USR21-BNAME optional
    returning
      value(EV_NAME) type ADRP-NAME_TEXT .
  class-methods GET_DOMAIN_FIXED_VALUES
    importing
      !IV_DOMAIN type DD07L-DOMNAME
    preferred parameter IV_DOMAIN
    returning
      value(RT_VALUES) type DD07V_TAB .
  class-methods MESSAGE_NUMBER_TO_RETURN
    importing
      !IV_TYPE type SYST_MSGTY
      !IV_NUMBER type SYST_MSGNO
      !IV_ID type SYST_MSGID
      !IV_MESSAGE_V1 type SYST_MSGV optional
      !IV_MESSAGE_V2 type SYST_MSGV optional
      !IV_MESSAGE_V3 type SYST_MSGV optional
      !IV_MESSAGE_V4 type SYST_MSGV optional
    returning
      value(RS_RETURN) type BAPIRET2 .
  class-methods GET_USER_DETAILS
    importing
      !IV_USER type UNAME
    returning
      value(RS_DETAIL) type ZABAP_USER_DETAILS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAP_UTILS IMPLEMENTATION.


  METHOD get_domain_fixed_values.

    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = iv_domain
        text           = 'X'
        langu          = 'T'
      TABLES
        dd07v_tab      = rt_values
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2.

*    LOOP AT idd07v.
*      WRITE:/ idd07v-domvalue_l, idd07v-ddtext.
*    ENDLOOP.

  ENDMETHOD.


  METHOD get_user_details.

    SELECT SINGLE adr6~smtp_addr as email adrp~name_text
      INTO CORRESPONDING FIELDS OF rs_detail
    FROM usr21
    JOIN adr6 ON usr21~persnumber = adr6~persnumber AND
                 usr21~addrnumber = adr6~addrnumber AND
                 adr6~date_from   = '00010101'
    JOIN adrp ON usr21~persnumber = adrp~persnumber AND
                 adrp~date_from   = '00010101'      AND
                 adrp~nation      = ''
    WHERE usr21~bname = iv_user.

*    SELECT SINGLE adrp~name_text INTO ev_name
*        FROM usr21 JOIN adrp ON usr21~persnumber = adrp~persnumber AND
*                                adrp~date_from   = '00010101'      AND
*                                adrp~nation      = ''
*        WHERE usr21~bname = iv_user.

  ENDMETHOD.


  METHOD get_user_email.

    SELECT SINGLE adr6~smtp_addr INTO ev_email
        FROM usr21 JOIN adr6 ON
      usr21~persnumber = adr6~persnumber AND
      usr21~addrnumber = adr6~addrnumber AND
                                adr6~date_from   = '00010101'
        WHERE usr21~bname = iv_user.

  ENDMETHOD.


  METHOD get_user_name.

    SELECT SINGLE adrp~name_text INTO ev_name
        FROM usr21 JOIN adrp ON usr21~persnumber = adrp~persnumber AND
                                adrp~date_from   = '00010101'      AND
                                adrp~nation      = ''
        WHERE usr21~bname = iv_user.

  ENDMETHOD.


  METHOD message_number_to_return.

    CALL FUNCTION 'BALW_BAPIRETURN_GET2'
      EXPORTING
        type   = iv_type
        cl     = iv_id
        number = iv_number
        par1   = iv_message_v1
        par2   = iv_message_v2
        par3   = iv_message_v3
        par4   = iv_message_v4
      IMPORTING
        return = rs_return.
  ENDMETHOD.
ENDCLASS.
