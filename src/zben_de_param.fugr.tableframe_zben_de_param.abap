*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZBEN_DE_PARAM
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZBEN_DE_PARAM      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
