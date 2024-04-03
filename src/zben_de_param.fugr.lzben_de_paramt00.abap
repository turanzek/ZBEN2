*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBEN_T_PARAMS...................................*
DATA:  BEGIN OF STATUS_ZBEN_T_PARAMS                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBEN_T_PARAMS                 .
CONTROLS: TCTRL_ZBEN_T_PARAMS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBEN_T_PARAMS                 .
TABLES: ZBEN_T_PARAMS                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
