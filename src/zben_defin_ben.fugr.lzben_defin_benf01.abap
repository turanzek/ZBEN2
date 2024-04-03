*----------------------------------------------------------------------*
***INCLUDE LZBEN_DEFIN_BENF01.
*----------------------------------------------------------------------*
FORM get_benefits_detail.
  SELECT SINGLE benefit_name
               BENEFIT_GROUP
       FROM zben_benefits
       INTO ( zben_defin_ben-benefit_name,zben_defin_ben-benefit_group )
       WHERE benefit_id = zben_defin_ben-benefit_id.
ENDFORM.
