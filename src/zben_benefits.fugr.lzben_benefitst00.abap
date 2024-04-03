*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBEN_BENEFITS...................................*
DATA:  BEGIN OF STATUS_ZBEN_BENEFITS                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBEN_BENEFITS                 .
CONTROLS: TCTRL_ZBEN_BENEFITS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBEN_BENEFITS                 .
TABLES: ZBEN_BENEFITS                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
