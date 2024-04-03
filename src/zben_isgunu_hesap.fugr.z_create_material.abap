FUNCTION Z_CREATE_MATERIAL.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(CTU) LIKE  APQI-PUTACTIVE DEFAULT 'X'
*"     VALUE(MODE) LIKE  APQI-PUTACTIVE DEFAULT 'N'
*"     VALUE(UPDATE) LIKE  APQI-PUTACTIVE DEFAULT 'L'
*"     VALUE(GROUP) LIKE  APQI-GROUPID OPTIONAL
*"     VALUE(USER) LIKE  APQI-USERID OPTIONAL
*"     VALUE(KEEP) LIKE  APQI-QERASE OPTIONAL
*"     VALUE(HOLDDATE) LIKE  APQI-STARTDATE OPTIONAL
*"     VALUE(NODATA) LIKE  APQI-PUTACTIVE DEFAULT '/'
*"     VALUE(TRKORR_001) LIKE  BDCDATA-FVAL DEFAULT 'HRDK969839'
*"     VALUE(L_DEVCLASS_002) LIKE  BDCDATA-FVAL DEFAULT 'zben'
*"     VALUE(L_AUTHOR_003) LIKE  BDCDATA-FVAL DEFAULT 'YTUZUN'
*"     VALUE(L_SRCSYSTM_004) LIKE  BDCDATA-FVAL DEFAULT 'DER'
*"     VALUE(L_DEVCLASS_005) LIKE  BDCDATA-FVAL DEFAULT 'ZBEN'
*"     VALUE(L_AUTHOR_006) LIKE  BDCDATA-FVAL DEFAULT 'YTUZUN'
*"     VALUE(L_SRCSYSTM_007) LIKE  BDCDATA-FVAL DEFAULT 'der'
*"  EXPORTING
*"     VALUE(SUBRC) LIKE  SYST-SUBRC
*"  TABLES
*"      MESSTAB STRUCTURE  BDCMSGCOLL OPTIONAL
*"--------------------------------------------------------------------

subrc = 0.

perform bdc_nodata      using NODATA.

perform open_group      using GROUP USER KEEP HOLDDATE CTU.

perform bdc_dynpro      using 'SAPCTS_TOOLS' '0100'.
perform bdc_field       using 'BDC_OKCODE'
                              '=%_GC 158 25'.
perform bdc_dynpro      using 'RSWBO051' '1000'.
perform bdc_field       using 'BDC_CURSOR'
                              'TRKORR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ONLI'.
perform bdc_field       using 'TRKORR'
                              TRKORR_001.
perform bdc_dynpro      using 'SAPMSSY0' '0120'.
perform bdc_field       using 'BDC_CURSOR'
                              '05/07'.
perform bdc_field       using 'BDC_OKCODE'
                              '=TRSL'.
perform bdc_dynpro      using 'SAPMSSY0' '0120'.
perform bdc_field       using 'BDC_CURSOR'
                              '07/12'.
perform bdc_field       using 'BDC_OKCODE'
                              '=TRSL'.
perform bdc_dynpro      using 'SAPMSSY0' '0120'.
perform bdc_field       using 'BDC_CURSOR'
                              '09/24'.
perform bdc_field       using 'BDC_OKCODE'
                              '=TRMK'.
perform bdc_dynpro      using 'SAPMSSY0' '0120'.
perform bdc_field       using 'BDC_CURSOR'
                              '10/26'.
perform bdc_field       using 'BDC_OKCODE'
                              '=TRMK'.
perform bdc_dynpro      using 'SAPMSSY0' '0120'.
perform bdc_field       using 'BDC_CURSOR'
                              '10/26'.
perform bdc_field       using 'BDC_OKCODE'
                              '=CATA'.
perform bdc_dynpro      using 'SAPLSTRD' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'KO007-L_SRCSYSTM'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ADD'.
perform bdc_field       using 'KO007-L_DEVCLASS'
                              L_DEVCLASS_002.
perform bdc_field       using 'KO007-L_AUTHOR'
                              L_AUTHOR_003.
perform bdc_field       using 'KO007-L_SRCSYSTM'
                              L_SRCSYSTM_004.
perform bdc_dynpro      using 'SAPLSTRD' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'KO007-L_SRCSYSTM'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ADD'.
perform bdc_field       using 'KO007-L_DEVCLASS'
                              L_DEVCLASS_005.
perform bdc_field       using 'KO007-L_AUTHOR'
                              L_AUTHOR_006.
perform bdc_field       using 'KO007-L_SRCSYSTM'
                              L_SRCSYSTM_007.
perform bdc_dynpro      using 'SAPMSSY0' '0120'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BAC2'.
perform bdc_dynpro      using 'RSWBO051' '1000'.
perform bdc_field       using 'BDC_OKCODE'
                              '/EE'.
perform bdc_field       using 'BDC_CURSOR'
                              'TRKORR'.
perform bdc_dynpro      using 'SAPCTS_TOOLS' '0100'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BACK'.
perform bdc_transaction tables messtab
using                         'SE03'
                              CTU
                              MODE
                              UPDATE.
if sy-subrc <> 0.
  subrc = sy-subrc.
  exit.
endif.

perform close_group using     CTU.





ENDFUNCTION.
INCLUDE BDCRECXY .
