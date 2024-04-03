*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBEN_CONFIG.....................................*
DATA:  BEGIN OF STATUS_ZBEN_CONFIG                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBEN_CONFIG                   .
CONTROLS: TCTRL_ZBEN_CONFIG
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBEN_CONFIG                   .
TABLES: ZBEN_CONFIG                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
