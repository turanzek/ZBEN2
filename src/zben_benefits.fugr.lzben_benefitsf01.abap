*----------------------------------------------------------------------*
***INCLUDE LZBEN_BENEFITSF01.
*----------------------------------------------------------------------*

FORM check_disc_rate.

  IF zben_benefits-discount_rate GT 1.
    MESSAGE e011(zben)." DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
